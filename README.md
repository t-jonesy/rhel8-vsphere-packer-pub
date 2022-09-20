# rhel8-vsphere-packer
STIG compliant RHEL 8 build using packer

## Using

* Clone the repo
* Copy vars.auto.pkrvars.hcl.example to vars.auto.pkrvars.hcl
* Fill out the variables
  * use `openssl passwd -6` to generate a hashed password for `buld_password_encrypted`
  * use `grub2-mkpasswd-pbkdf2` to generate a hashed password for `grub_pass`
* build with packer!