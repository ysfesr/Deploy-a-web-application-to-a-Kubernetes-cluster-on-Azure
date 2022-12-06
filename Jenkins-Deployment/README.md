# Déploiement de Jenkins sur Azure en utilisant Terraform et Ansible :

1. Téléchargez et installez Terraform et Ansible sur votre ordinateur.
2. Créez un compte Azure et générez un fichier de clé d'accès pour accéder à votre compte via Terraform et Ansible.
3. Créez un fichier Terraform azure.tf pour définir la configuration de votre infrastructure Azure, en spécifiant les paramètres de votre environnement Jenkins, tels que le type et la taille de la machine virtuelle, le stockage et les réseaux.

4. Exécutez Terraform pour déployer votre infrastructure Azure en utilisant la configuration définie dans le fichier Terraform. Cette étape peut prendre quelques minutes. Par exemple, vous pouvez exécuter la commande suivante pour initialiser Terraform et déployer votre infrastructure :

terraform init
terraform apply

5. Créez un fichier Ansible jenkins.yml pour définir les tâches à exécuter pour configurer et déployer Jenkins sur la machine virtuelle Azure créée par Terraform. Par exemple, vous pouvez inclure les tâches suivantes dans votre fichier Ansible.

6. Exécutez Ansible pour configurer et déployer Jenkins sur la machine virtuelle Azure en utilisant la configuration définie dans le fichier Ansible. Par exemple, vous pouvez utiliser la commande suivante pour exécuter Ansible :

ansible-playbook jenkins.yml

7. Vérifiez que Jenkins est correctement déployé en vous connectant à l'interface d'administration Jenkins via l'URL générée par Ansible. Par exemple, vous pouvez accéder à l'interface d'administration Jenkins en utilisant l'URL suivante :

http://{{ azurerm_public_ip.jenkins.ip_address }}:8080