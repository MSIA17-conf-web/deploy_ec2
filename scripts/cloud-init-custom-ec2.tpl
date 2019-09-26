#cloud-config

# Make sure that the root partition fills the entire disk to prevent the return of the disk full issue.
growpart:
  mode: auto
  devices: ['/']

yum_repos:
  docker:
    baseurl: https://download.docker.com/linux/centos/7/$basearch/stable
    enabled: true
    gpgcheck: true
    gpgkey: https://download.docker.com/linux/centos/gpg
    name: Docker CE Stable - $basearch

# Update all the things
package_update: true

# Install our packages to make docker work.
packages:
  - yum-utils
  - device-mapper-persistent-data
  - lvm2
  - wget
  - docker-ce
  - zsh

# Reboot to update the packages if needed. Makes sure the patches actually get applied.
package_reboot_if_required: true

# Configure NTP like we should do! Using AWS magic IP address for NTP.
ntp:
  enabled: true
  ntp_client: chrony
  servers:
    - 169.254.169.123


runcmd:
- echo "${deploymentID}" > /home/gecloud/.deploymentID
- update-ca-trust
- systemctl enable docker
- systemctl start docker
- docker network create the_network

output : { all : '| tee -a /var/log/cloud-init-runcmd.log' }