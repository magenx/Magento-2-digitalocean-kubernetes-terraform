
if [[ -e "this.init.lock" ]]; then
  echo
  echo "[!][ERROR]: Lock exists"
  echo
  echo "Terraform workspace available:"
  terraform workspace list
  echo
  exit 1
fi

## install terraform and docker
dpkg-query -l terraform docker >/dev/null || {
apt-get update && apt-get install -y gnupg software-properties-common curl;
mkdir -p /etc/apt/keyrings;
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -;
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main";
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list;
apt-get update && apt-get -y install terraform docker-ce docker-ce-cli containerd.io docker-compose-plugin;
}

## set access token
if [ -z "${DIGITALOCEAN_ACCESS_TOKEN}" ]; then
    echo
    echo "[!][ERROR]: No DIGITALOCEAN_ACCESS_TOKEN token available"
    echo
    exit 1
fi

## start with development workspace
workspace=development

echo
## init terraform
terraform fmt
terraform init

if  [ $? -ne 0 ]; then
    echo
    echo "[!][ERROR]: Terraform init"
    echo
    exit 1
fi

echo
# create terraform workspace
if [ "$(terraform workspace list | grep ${workspace})" == "" ]; then
    terraform workspace new ${workspace}
fi

if  [ $? -ne 0 ]; then
    echo
    echo "[!][ERROR]: Terraform workspace ${workspace} not available"
    echo
    exit 1
fi

echo
echo "[!][INFO]: Running terraform plan to ${workspace}.plan.out.txt"
terraform plan -out ${workspace}.plan.out -no-color 2>&1 > ${workspace}.plan.out.txt

if  [ $? -eq 0 ]; then
    echo
    echo "[X][LOCKED]: Init lock enabled"
    echo
    touch this.init.lock
fi
