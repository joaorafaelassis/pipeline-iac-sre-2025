# !/bin/sh
# Parameter 1: Terraform action. Accepted values:init, plan, apply or destroy.
# Parameter 2: Environment path
# Folders should be added on the required deployment order
TERRAFORM_ACTION=$1
ENV_PATH=$2
echo $SHELL
FOLDERS="network databases services"
cd org01
ORGPATH=$(pwd)
STATE_BUCKET=$(grep state_bucket: org.yaml | cut -d: -f2 | tr -d '"\' | tr -d " ")
echo State Bucket name: $STATE_BUCKET
terraform_command () {
    echo "Running terraform $TERRAFORM_ACTION on the directory $(pwd)"
    if [ $TERRAFORM_ACTION == "apply" ] || [ $TERRAFORM_ACTION == "destroy" ]; then
        terraform $TERRAFORM_ACTION -auto-approve
    elif [ $TERRAFORM_ACTION == "init" ]; then
        terraform $TERRAFORM_ACTION \
        -backend-config="prefix=terraform/state/$(pwd | awk -F '/' '{printf "%s/%s\n", $(NF-1), $NF }')" \
        -backend-config="bucket=$STATE_BUCKET"
    else
        terraform $TERRAFORM_ACTION
    fi
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

global_api () {
    cd $ORGPATH/global/api
    terraform_command
}

resources (){
        for F in $1; do
            cd $ORGPATH/env/$ENV_PATH/$F
            terraform_command 
        done
}

if [ "$#" -eq 2 ]; then
    if [ $TERRAFORM_ACTION == "destroy" ]; then
        for FOLDER in $FOLDERS; do
          REVERSED_FOLDERS="$FOLDER $REVERSED_FOLDERS"  # Reverse FOLDERS variable
        done
        echo $REVERSED_FOLDERS
        resources "$REVERSED_FOLDERS"
        global_api
    else
        global_api
        resources "$FOLDERS"
    fi
else
    echo "Error: Script requires the env argument!"
    exit 1  # Exit with an error status
fi
