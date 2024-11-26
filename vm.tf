resource "azurerm_virtual_machine" "vm" {
  count                 = var.controller_count
  name                  = "${var.prefix}-vm"
  location              = var.region
  resource_group_name   = azurerm_resource_group.this.name
  network_interface_ids = [
    azurerm_network_interface.controller_public.id,
  ]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name          = "${var.prefix}-os-disk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}vm"
    admin_username = var.vm_username
    admin_password = var.vm_password
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("${path.root}/tmp/ssh/azure_vm_key.pub")
      path     = "/home/${var.vm_username}/.ssh/authorized_keys"
    }
  }

#  provisioner "file" {
#    content = base64encode(templatefile("${path.root}/scripts/boundary/install.sh", {
#      boundary_version = var.boundary_version,
#      name             = "boundary",
#      type             = "controller"
#    }))
#
#    destination = "/tmp/install_base64.sh"
#  }

  provisioner "remote-exec" {
    inline = [
      "sudo base64 -d /tmp/install_base64.sh > /tmp/install.sh",
      "sudo mv /tmp/install.sh /home/${var.vm_username}/install.sh",
      "sudo chmod +x /home/${var.vm_username}/install.sh",
      "sudo /home/${var.vm_username}/install.sh",

      "sudo base64 -d /tmp/setup_controller_base64.sh > /tmp/setup.sh",
      "sudo mv /tmp/setup.sh /home/${var.vm_username}/setup.sh",
      "sudo chmod +x /home/${var.vm_username}/setup.sh",
      "sudo /home/${var.vm_username}/setup.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = var.vm_username
    private_key = file("${path.root}/tmp/ssh/azure_vm_key")
    host        = azurerm_public_ip.controller.ip_address
  }
}