# Déploiement de Jenkins sur Azure en utilisant Terraform et Ansible :

1. Téléchargez et installez Terraform et Ansible sur votre ordinateur.
2. Créez un fichier Terraform pour définir la configuration de votre infrastructure Azure, en spécifiant les paramètres de votre environnement Jenkins, tels que le type et la taille de la machine virtuelle, le stockage et les réseaux.

3. Exécutez Terraform pour déployer votre infrastructure Azure en utilisant la configuration définie dans le fichier Terraform. Cette étape peut prendre quelques minutes. Par exemple, vous pouvez exécuter la commande suivante pour initialiser Terraform et déployer votre infrastructure :

```bash
terraform init
terraform apply
```

4. Créez un fichier Ansible jenkins.yml pour définir les tâches à exécuter pour configurer et déployer Jenkins sur la machine virtuelle Azure créée par Terraform.

5. Exécutez Ansible pour configurer et déployer Jenkins sur la machine virtuelle Azure en utilisant la configuration définie dans le fichier Ansible.

```bash
ansible-playbook -i hosts jenkins.yml
```

6. Vérifiez que Jenkins est correctement déployé en vous connectant à l'interface d'administration Jenkins via l'URL générée par Ansible. Par exemple, vous pouvez accéder à l'interface d'administration Jenkins en utilisant l'URL suivante :

```console
http://{{ azurerm_public_ip.jenkins.ip_address }}:8080
```
