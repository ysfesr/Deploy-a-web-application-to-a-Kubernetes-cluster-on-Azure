# Déploiement de Jenkins sur Azure en utilisant Terraform et Ansible :

1. Télécharger et installez Terraform et Ansible sur votre ordinateur.

2. Déployer votre infrastructure Azure en utilisant la configuration définie dans le fichier Terraform:

```bash
terraform init
terraform apply
```

3. Ajouter l'adresse IP, username et password de la machine cree dans le fichier de host d'ansible `hosts.ini`.

5. Lancer Ansible pour configurer et déployer Jenkins sur la machine virtuelle Azure.

```bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i hosts.ini jenkins.yml
```

6. Vérifiez que Jenkins est correctement déployé en vous connectant à l'interface d'administration Jenkins via l'URL:

```console
http://{{ azurerm_public_ip.jenkins.ip_address }}:8080
```
