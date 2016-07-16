# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Local Gnome testing instance.
  config.vm.define "gnome" do |gnome|
    gnome.vm.network "private_network", ip: "192.168.123.42"
    gnome.vm.hostname = "penguin.cweagans.net"
    # Ubuntu Gnome 16.04 + vagrant user + ssh access
    gnome.vm.box = "thullsl/gnubuntu"

    gnome.vm.synced_folder ".", "/vagrant",
      type: "nfs",
      mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=1']

    # Less resources than physical hardware, but good enough for prototyping.
    # Uses GUI mode by default.
    gnome.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 4
      vb.gui = true
    end

    gnome.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/cweagans/infrastructure/master/scripts/mac-linux-bootstrap.sh | bash -s -- penguin.cweagans.net develop"
  end

  # Local Dokku configuration testing instance.
  config.vm.define "dokku" do |dokku|
    dokku.vm.network "private_network", ip: "192.168.123.43"
    dokku.vm.hostname = "anvil.cweagans.net"
    dokku.vm.box = "ubuntu/xenial64"
    dokku.vm.synced_folder ".", "/vagrant",
      type: "nfs",
      mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=1']

    # Matches Linode configuration.
    dokku.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 1
    end

    dokku.vm.provision "shell", inline: "curl https://raw.githubusercontent.com/cweagans/infrastructure/master/scripts/mac-linux-bootstrap.sh | bash -s -- anvil.cweagans.net develop"
  end

end
