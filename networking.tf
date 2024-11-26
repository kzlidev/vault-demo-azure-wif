# Define a virtual network
resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-network"
  address_space       = var.network_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

# Define a public subnet
resource "azurerm_subnet" "public" {
  name                 = "${var.prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.network_public_subnet
}

# Define a subnet
resource "azurerm_subnet" "private" {
  name                 = "${var.prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.network_private_subnet
}

# Define a network security group
resource "azurerm_network_security_group" "public" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  # Define inbound security rules
  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Define outbound security rules
  security_rule {
    name                       = "allow-outbound"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "controller" {
  name                = "${var.prefix}-controller-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.this.name

  allocation_method       = "Static"  # Options are "Static" or "Dynamic"
  idle_timeout_in_minutes = 4  # Optional: The timeout period in minutes for idle public IP addresses
}

# Define a network interface
resource "azurerm_network_interface" "controller_public" {
  name                = "${var.prefix}-controller-public-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.controller.id
  }
}

resource "azurerm_subnet_network_security_group_association" "public_sec_group_association" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_network_interface_security_group_association" "public_sec_group_association" {
  network_interface_id      = azurerm_network_interface.controller_public.id
  network_security_group_id = azurerm_network_security_group.public.id
}
