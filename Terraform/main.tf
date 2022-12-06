# Configure Azure provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

# Create a resource group
resource "azurerm_resource_group" "jenkins" {
  name     = "jenkins-rg"
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "jenkins" {
  name                = "jenkins-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Create a subnet
resource "azurerm_subnet" "jenkins" {
  name                 = "jenkins-subnet"
  resource_group_name  = azurerm_resource_group.jenkins.name
  virtual_network_name = azurerm_virtual_network.jenkins.name
  address_prefix       = "10.0.1.0/24"
}

# Create a public IP address
resource "azurerm_public_ip" "jenkins" {
  name                = "jenkins-public-ip"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
  allocation_method   = "Dynamic"
}

# Create a network security group
resource "azurerm_network_security_group" "jenkins" {
  name                = "jenkins-nsg"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}

# Create a virtual machine
resource "azurerm_virtual_machine" "jenkins" {
  name                  = "jenkins-vm"
  location              = azurerm_resource_group.jenkins.location
  resource_group_name   = azurerm_resource_group.jenkins.name
  network_interface_ids = [azurerm_network_interface.jenkins.id]
  vm_size               = var.jenkins_vm_size #"Standard_DS1_v2"

  storage_os_disk {
    name              = "jenkins-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "jenkins-vm"
    admin_username = "{{ var.ssh_user }}"
    ssh_keys {
      path     = "/home/{{ var.ssh_user }}/.ssh/authorized_keys"
      key_data = file("{{ var.ssh_public_key_file }}")
    }
  }

  os_profile_linux_config {
    disable_password_authentication = true
  }
}

# Create a network interface
resource "azurerm_network_interface" "jenkins" {
  name                = "jenkins-nic"
  location            = azurerm_resource_group.jenkins.location
  resource_group_name = azurerm_resource_group.jenkins.name
  network_security_group_id = azurerm_network_security_group.jenkins.id
  ip_configuration {
    name                          = "jenkins-pip"
    subnet_id                     = azurerm_subnet.jenkins.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jenkins.id
  }
}

# Output the public IP address of the Jenkins VM
output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins.ip_address
}

# Create a data disk for the Jenkins VM
resource "azurerm_managed_disk" "jenkins_data_disk" {
  name                 = "jenkins-data-disk"
  location             = azurerm_resource_group.jenkins.location
  resource_group_name  = azurerm_resource_group.jenkins.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"
}

# Attach the data disk to the Jenkins VM
resource "azurerm_virtual_machine_data_disk_attachment" "jenkins_data_disk" {
  managed_disk_id             = azurerm_managed_disk.jenkins_data_disk.id
  virtual_machine_id          = azurerm_virtual_machine.jenkins.id
  lun                         = 0
  caching                     = "None"
  create_option               = "Attach"
}
