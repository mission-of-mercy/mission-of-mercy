# This Vagrantfile brings up an Ubuntu virtual machine running MoM.
#   (https://www.vagrantup.com/)
# If the bootstrap fails, you can run 'vagrant provision' to try again.

$bootstrap = <<THIS_IS_A_BASH_SCRIPT
set -e
# install ansible and use it to run the installer
apt-get update
apt-get install -y ansible cowsay python-pip python-dev
ansible-playbook /vagrant/ansible-playbook.yml -c local -i localhost, | tee /tmp/ansible.log
THIS_IS_A_BASH_SCRIPT

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory=4096
  end
  config.vm.box = "ubuntu/wily64"
  config.vm.hostname = "mom.dev"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provision "shell", inline: $bootstrap
end
