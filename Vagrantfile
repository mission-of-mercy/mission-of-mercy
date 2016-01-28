# This Vagrantfile brings up an Ubuntu virtual machine running MoM.
#   (https://www.vagrantup.com/)
# If the bootstrap fails, you can run 'vagrant provision' to try again.

$bootstrap = <<THIS_IS_A_BASH_SCRIPT
set -e
# fetch dependencies
apt-get update
apt-get install -y apt-file git libpq-dev make nginx nodejs postgresql qt4-default qt4-qmake ruby-dev ruby redis xvfb
# setup psql
sudo -u postgres createuser --superuser vagrant
# TODO: set the password to 'vagrant' without manual invervention
# run application setup
cd /vagrant/
xvfb -a bundle exec ./bin/setup
THIS_IS_A_BASH_SCRIPT

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory=4096
  end
  config.vm.box = "ubuntu/wily64"
  config.vm.hostname = "mission-of-mercy-dev"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provision "shell", inline: $bootstrap
end
