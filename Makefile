.DEFAULT_GOAL := create-vms

VAR_FTGT_RES_GROUP_NAME        ?= LAB-FGT-SECHUB-RG
VAR_WORKLOAD1_RES_GROUP_NAME   ?= LAB-WorkLoad-1-RG
VAR_WORKLOAD2_RES_GROUP_NAME   ?= LAB-WorkLoad-2-RG
VAR_REGION                     ?= eastus
VAR_IMAGE                      ?= Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest

CMD_FGT_RES_GROUP_CREATE = az group create --name $(VAR_FTGT_RES_GROUP_NAME) --location $(VAR_REGION)
CMD_WORKLOAD1_RES_GROUP_CREATE = az group create --name $(VAR_WORKLOAD1_RES_GROUP_NAME) --location $(VAR_REGION)
CMD_WORKLOAD2_RES_GROUP_CREATE = az group create --name $(VAR_WORKLOAD2_RES_GROUP_NAME) --location $(VAR_REGION)

CMD_CREATE_WORKLOAD1_VNET = az network vnet create --resource-group $(VAR_WORKLOAD1_RES_GROUP_NAME) --name $(VAR_WORKLOAD1_RES_GROUP_NAME)-VNET --address-prefixes '10.2.0.0/16' --subnet-name $(VAR_WORKLOAD2_RES_GROUP_NAME)-Subnet --subnet-prefix '10.2.0.0/24' --subnet-name 'workload1-default'
CMD_CREATE_WORKLOAD2_VNET = az network vnet create --resource-group $(VAR_WORKLOAD2_RES_GROUP_NAME) --name $(VAR_WORKLOAD2_RES_GROUP_NAME)-VNET --address-prefixes '10.3.0.0/16' --subnet-name $(VAR_WORKLOAD2_RES_GROUP_NAME)-Subnet --subnet-prefix '10.3.0.0/24' --subnet-name 'workload2-default'

CMD_WORKLOAD1_VM = az vm create --resource-group $(VAR_WORKLOAD1_RES_GROUP_NAME) --name Workload1-VM --image $(VAR_IMAGE) --vnet-name $(VAR_WORKLOAD1_RES_GROUP_NAME)-VNET --subnet 'workload1-default' --admin-username azureuser --admin-password 'Password1234!' --public-ip-address '' --size Standard_B1s
CMD_WORKLOAD2_VM = az vm create --resource-group $(VAR_WORKLOAD2_RES_GROUP_NAME) --name Workload2-VM --image $(VAR_IMAGE) --vnet-name $(VAR_WORKLOAD2_RES_GROUP_NAME)-VNET --subnet 'workload2-default' --admin-username azureuser --admin-password 'Password1234!' --public-ip-address '' --size Standard_B1s

CMD_RES_GROUP_1_DELETE = az group delete --name $(VAR_FTGT_RES_GROUP_NAME) --yes --no-wait
CMD_RES_GROUP_2_DELETE = az group delete --name $(VAR_WORKLOAD1_RES_GROUP_NAME) --yes --no-wait
CMD_RES_GROUP_3_DELETE = az group delete --name $(VAR_WORKLOAD2_RES_GROUP_NAME) --yes --no-wait

create-rgs:
	$(CMD_FGT_RES_GROUP_CREATE)
	$(CMD_WORKLOAD1_RES_GROUP_CREATE)
	$(CMD_WORKLOAD2_RES_GROUP_CREATE)

create-vnets: create-rgs
	$(CMD_CREATE_WORKLOAD1_VNET)
	$(CMD_CREATE_WORKLOAD2_VNET)	

create-vms: create-vnets
	$(CMD_WORKLOAD1_VM)
	$(CMD_WORKLOAD2_VM)

delete-rgs:
	$(CMD_RES_GROUP_1_DELETE)
	$(CMD_RES_GROUP_2_DELETE)
	$(CMD_RES_GROUP_3_DELETE)
	
.PHONY: create-rgs create-vnets create-vms delete-rgs

