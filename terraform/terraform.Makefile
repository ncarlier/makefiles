.SILENT :

PROXY_GATEWAY?=http://gateway-fr.priv.atos.fr:3128

define tfcmd
HTTPS_PROXY=${PROXY_GATEWAY} \
NO_PROXY=localhost \
terraform
endef

user_data.yml:
	echo "Creating user_data file..."
	cp user_data.yml.tmpl user_data.yml
	while read USER
	do
		curl -sL -w "\n" "https://gitlab.kazan.priv.atos.fr/$$USER.keys" | while read KEY
		do echo "      - $$KEY" >> user_data.yml
		done 
	done < users.txt
.ONESHELL:
.DELETE_ON_ERROR:

tf-plan: user_data.yml
	echo "Building execution plan..."
	terraform plan
.PHONY: tf-plan

tf-apply:
	echo "Applying execution plan..."
	${tfcmd} apply
.PHONY: tf-apply

tf-show:
	echo "Show plan status..."
	${tfcmd} show
.PHONY: tf-show

tf-destroy:
	echo "Destroying plan..."
	${tfcmd} destroy
.PHONY : tf-destroy

tf-get-ip:
	$(eval TF_IP = `terraform output ip`)
.PHONY : tf-get-ip

tf-ssh: tf-get-ip
	echo "Connecting to $(TF_IP)..."
	ssh cloud@$(TF_IP)
.PHONY : tf-ssh

