# Resource-2: Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name = "myvnet-1"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
  tags = {
    "Name" = "myvet-1"
  }
}

# Resource-2: Subnet 

resource "azurerm_subnet" "mysubnet" {
  name = "mysubnet-1"
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = [ "10.0.2.0/24" ]

  resource_group_name = azurerm_resource_group.myrg1.name  
  
}

#Resource-3 Public IP Address

resource "azurerm_public_ip" "mypublicip" {
  count = 2
  name = "mypublicip-${count.index}"
  allocation_method = "Static"
  tags = {
    "enviroment" = "dev"
  }

  location = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
  domain_name_label = "app1-vm-${count.index}-${random_string.myrandom.id}"
}

#Resource-4 Network Interface
resource "azurerm_network_interface" "myvmnic" {
  count = 2
  name = "vmnic-${count.index}"

  location = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name 

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index)

  }
}
