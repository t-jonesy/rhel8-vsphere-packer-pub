#!/bin/bash -eux
#possibly not needed now that it's in kickstart
#authselect select sssd with-mkhomedir --force
sed -i "s/\(set superusers=\).*/\1=\""$GRUB_USER"\"/g" /etc/grub.d/01_users
grub2-mkconfig -o "$(readlink -e /etc/grub2.cfg)"
mkdir -p /root/stig/
cd /root/stig/
curl "https://access.redhat.com/security/data/oval/com.redhat.rhsa-RHEL8.xml.bz2" -o security-data-oval-com.redhat.rhsa-RHEL8.xml.bz2
oscap xccdf eval --local-files . --profile stig --report report.html --remediate /usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml
