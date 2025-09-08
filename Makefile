#Deployment with make is under development
FOLDERS = global/api global/iam network database services
STACK = test
ORG = org01

.PHONY: help
help:
	@This make file execute terraform command to all folders for the stack defined by the STACK parameter. Default value for STACK is "test". To run it for other stacks please do it "make all STACK=development"
	@echo init - execute terraform init
	@echo plan - execute terraform plan
	@echo apply - execute terraform apply -auto-approve
	@echo test - execute terraform test
	@echo destroy - execute terraform destroy -auto-approve


.PHONY: validate_stack
validate_stack:
	ls $(ORG)/$(STACK)

.PHONY: help
all: validate_stack


.PHONY: init
init: 
	terraform init

.PHONY: plan
plan:
	terraform plan

.PHONY: apply
apply:
	terraform apply -auto-approve

.PHONY: test
test:
	terraform test

.PHONY: destroy
destroy:
	terraform destroy -auto-approve

$(FOLDERS): validate_stack
	@echo $@
	@echo $(STACK)