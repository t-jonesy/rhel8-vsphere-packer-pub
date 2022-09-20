source "vsphere-iso" "rhel8"  {
    boot_command = [
    "<up><wait><tab><wait> ins.text init.ks=inst.ks=hd:/dev/sr1:ks.cfg fips=1 <enter>"
  ]
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  datacenter          = var.datacenter
  host                = var.host
  insecure_connection = true

  vm_name       = "rhel8-stig-min-template"
  guest_os_type = "rhel8_64Guest"
  iso_url      = "iso/${var.iso_name}"
  iso_checksum = "sha256:${var.iso_sha256_checksum}"
  shutdown_command      = "echo '${var.ssh_pass}' | sudo -S shutdown -P now"
  shutdown_timeout      = "30m"

  ssh_password          = var.ssh_pass
  ssh_username          = var.build_username
  
  CPUs            = 4
  RAM             = 8192
  RAM_reserve_all = false

  disk_controller_type = ["pvscsi"]
  datastore            = var.datastore
  storage {
    disk_size             = 204800
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network_name
    network_card = "vmxnet3"
  }
cd_content = {
    "/ks.cfg" = templatefile("/cd_files/ks.pkrtpl.hcl", {
      build_username           = var.build_username
      build_password_encrypted = var.build_password_encrypted
      grub_pass                = var.grub_pass
    })
    }
  cd_label     = "OEMDRV"
}
build {
  sources = ["source.vsphere-iso.rhel8"]

  provisioner "shell" {
    environment_vars  = ["RH_USERNAME=${var.rh_username}", "RH_PASSWORD=${var.rh_password}"]
    expect_disconnect = true
    pause_before      = "10s"
    execute_command   = "echo '${var.ssh_pass}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    scripts           = ["scripts/subscription-attach.sh", "scripts/upgrade.sh", "scripts/stig.sh", "scripts/subscription-remove.sh"]
  }
}