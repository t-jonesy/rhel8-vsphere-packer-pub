# Red Hat Enterprise Linux Server 8
### Installs from the first attached CD-ROM/DVD on the system.
cdrom

### Performs the kickstart installation in text mode. 
### By default, kickstart installations are performed in graphical mode.
text

### Accepts the End User License Agreement.
eula --agreed
firstboot --disable

### Sets the language to use during installation and the default language to use on the installed system.
lang en_US.UTF-8

### Sets the default keyboard type for the system.
keyboard --vckeymap=us --xlayouts='us'

### Configure network information for target system and activate network devices in the installer environment (optional)
### --onboot	  enable device at a boot time
### --device	  device to be activated and / or configured with the network command
### --bootproto	  method to obtain networking configuration for device (default dhcp)
### --noipv6	  disable IPv6 on this device
###
### network  --bootproto=static --ip=172.16.11.200 --netmask=255.255.255.0 --gateway=172.16.11.200 --nameserver=172.16.11.4 --hostname centos-linux-8
network  --bootproto=dhcp --device=ens192 --ipv6=auto --activate
network  --hostname=rhel8min

### Set root password.
rootpw --iscrypted ${build_password_encrypted}

### Add a user that can login and escalate privileges.
user --name=${build_username} --iscrypted --password=${build_password_encrypted} --groups=wheel

### Configure firewall settings for the system.
### --enabled	reject incoming connections that are not in response to outbound requests
### --ssh		allow sshd service through the firewall
firewall --enabled --ssh

### Sets up the authentication options for the system.
### The SSDD profile sets sha512 to hash passwords. Passwords are shadowed by default
### See the manual page for authselect-profile for a complete list of possible options.
authselect select sssd with-mkhomedir

### Sets the system time zone.
timezone Etc/UTC --isUtc

### Partitioning
bootloader --location=boot --append="rhgb quiet crashkernel=auto fips=1" --iscrypted --password=${grub_pass}
ignoredisk --only-use=sda
zerombr
clearpart --all --initlabel
part /boot --fstype="xfs" --ondisk=sda --size=1024
part pv.140 --fstype="lvmpv" --ondisk=sda --size=127998
part /boot/efi --fstype="efi" --ondisk=sda --size=512 --fsoptions="defaults,uid=0,gid=0,umask=077,shortname=winnt"
volgroup rhel_rehl8min --pesize=4096 pv.140
logvol /tmp --fstype="xfs" --size=5120 --fsoptions="nodev,nosuid,noexec" --name=tmp --vgname=rhel_rehl8min
logvol /home --fstype="xfs" --size=20480 --fsoptions="nodev" --name=home --vgname=rhel_rehl8min
logvol /var/log/audit --fstype="xfs" --size=10240 --fsoptions="nodev,nosuid,noexec" --name=var_log_audit --vgname=rhel_rehl8min
logvol swap --fstype="swap" --size=4096 --name=swap --vgname=rhel_rehl8min
logvol /var --fstype="xfs" --size=10240 --fsoptions="nodev" --name=var --vgname=rhel_rehl8min
logvol / --fstype="xfs" --grow --size=57340 --name=root --vgname=rhel_rehl8min
logvol /var/log --fstype="xfs" --size=10240 --fsoptions="nodev,nosuid,noexec" --name=var_log --vgname=rhel_rehl8min
logvol /var/tmp --fstype="xfs" --size=10240 --fsoptions="nodev,nosuid,noexec" --name=var_tmp --vgname=rhel_rehl8min


### Do not configure X on the installed system.
skipx

### Packages selection.
%packages
@^minimal-environment
aide
audit
fapolicyd
firewalld
opensc
openscap
openscap-scanner
openssh-server
openssl-pkcs11
policycoreutils
rng-tools
rsyslog
rsyslog-gnutls
scap-security-guide
tmux
usbguard
-abrt
-abrt-addon-ccpp
-abrt-addon-kerneloops
-abrt-cli
-abrt-plugin-logger
-abrt-plugin-rhtsupport
-abrt-plugin-sosreport
-aic94xx-firmware
-alsa-firmware
-alsa-tools-firmware
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-iprutils
-ipw*-firmware
-irqbalance
-ivtv-firmware
-iwl*-firmware
-kernel-firmware
-krb5-workstation
-libertas-usb8388-firmware
-microcode_ctl
-python3-abrt-addon
-ql*-firmware
-rsh-server
-rt61pci-firmware
-rt73usb-firmware
-sendmail
-telnet-server
-tftp-server
-tuned
-vsftpd
-xorg-x11-drv-ati-firmware
-xorg-x11-server-Xorg
-xorg-x11-server-Xwayland
-xorg-x11-server-common
-xorg-x11-server-utils
-zd1211-firmware
%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end

%addon org_fedora_oscap
    content-type = scap-security-guide
    datastream-id = scap_org.open-scap_datastream_from_xccdf_ssg-rhel8-xccdf-1.2.xml
    xccdf-id = scap_org.open-scap_cref_ssg-rhel8-xccdf-1.2.xml
    profile = xccdf_org.ssgproject.content_profile_stig
%end

### Post-installation commands.
%post
chage -M 180 -m 1 -E $(date -d +180days +%Y-%m-%d) -d $(date +%Y-%m-%d) root
chage -M 180 -m 1 -E $(date -d +180days +%Y-%m-%d) -d $(date +%Y-%m-%d) ksuser
%end

### Reboot after the installation is complete.
### --eject attempt to eject the media before rebooting.
reboot