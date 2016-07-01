#!/usr/bin/env bash

# Exit on a nonzero exit code.
set -e

# Bail out if we're in a Windows environment.
case "$OSTYPE" in
  win*)
    echo "This bootstrap script does not support Windows."
    echo "Consider contributing a powershell script instead."
    exit 1
    ;;
  cygwin*)
    echo "This bootstrap script does not support Windows."
    echo "Consider contributing a powershell script instead."
    exit 1
    ;;
esac

# Ask for sudo password upfront, and then update the sudo timestamp until we're
# done setting things up. Thanks to @kevinSuttle for the example in his OSXDefaults
# project.
echo "Requesting elevated privileges to configure system:"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# There are some base dependencies that we need in order to provision the machine
# with Ansible. Installation of these dependencies varies by operating system,
# so we'll just handle every case we can.
case "$(uname)" in

  "Darwin")
    # Before we can do anything else, we need Homebrew. Homebrew's installation
    # script will also take care of installing xcode's cli tools if necessary.
    if [ ! -x "$(which brew)" ]; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # If some future version of macOS doesn't ship with Git, this will make sure
    # this bootstrap script continues to work. Even if we don't install git here,
    # the mac provisioning stuff will upgrade the system git later.
    if [ ! -x "$(which git)" ]; then
      brew install git
    fi

    # We also need to install Ansible. This is slightly complicated by the fact
    # that the version in Homebrew can update at any time, so if there are compat
    # issues between macOS and everything else, we'll pin this to a specific release
    # later.
    if [ ! -x "$(which ansible)" ]; then
      brew install ansible
    fi

    # Configure the system hostname so that we can use the right playbook for
    # provisioning.
    echo "Enter this system's hostname. Note that this MUST EXACTLY MATCH the"
    echo "hostname configured in the Ansible inventory or provisioning will NOT"
    echo "work as expected."
    read new_hostname
    echo "You entered: $new_hostname"
    echo "Waiting 10 seconds before continuing. If you made a typo, now is the time"
    echo "to Ctrl+C before provisioning continues!"
    sleep 7
    echo "Seriously! You better be sure!"
    sleep 1
    echo "Last chance!"
    echo "3"
    sleep 1
    echo "2"
    sleep 1
    echo "1"
    sleep 1
    echo "Setting hostname to $new_hostname and continuing..."

    sudo scutil --set ComputerName $new_hostname
    sudo scutil --set HostName $new_hostname
    # @TODO: This is failing for some reason.
    # sudo scutil --set LocalHostName $new_hostname
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $new_hostname
    ;;

  "Linux")
    # Bail out early if we're on a RHEL based distro. Nothing personal. I just
    # don't use them.
    if [ -e "/etc/fedora-release" ] || [ -e "/etc/redhat-release" ]; then
      echo "Unsupported Linux distro."
      echo "If you believe this to be an error, please open an issue."
      exit 1
    fi

    if [ ! -x "$(which git)" ]; then
      echo "Installing git..."
      sudo apt-get -qq install git
    fi

    if [ ! -x "$(which ansible)" ]; then
      echo "Installing ansible..."
      sudo apt-get install software-properties-common
      sudo apt-add-repository ppa:ansible/ansible
      sudo apt-get update
      sudo apt-get -qq install ansible
    fi

    # Configure the system hostname so that we can use the right playbook for
    # provisioning.
    echo "Enter this system's hostname. Note that this MUST EXACTLY MATCH the"
    echo "hostname configured in the Ansible inventory or provisioning will NOT"
    echo "work as expected."
    read new_hostname
    echo "You entered: $new_hostname"
    echo "Waiting 10 seconds before continuing. If you made a typo, now is the time"
    echo "to Ctrl+C before provisioning continues!"
    sleep 7
    echo "Seriously! You better be sure!"
    sleep 1
    echo "Last chance!"
    echo "3"
    sleep 1
    echo "2"
    sleep 1
    echo "1"
    sleep 1
    echo "Setting hostname to $new_hostname and continuing..."

    sudo hostnamectl set-hostname $new_hostname
    ;;

  "*")
    echo "Unsupported operating system: $(uname)"
    echo "If you believe this to be an error, please open an issue."
    exit 1
    ;;

esac

# Create the ansible dir and clone the repo.
# Note: we're using /opt/ansible instead of /etc/ansible for consistency across
# operating systems.
if [ ! -d "/opt/ansible" ]; then
  sudo mkdir /opt/ansible
fi

if [ ! -d "/opt/ansible/pull" ]; then
  sudo git clone https://github.com/cweagans/infrastructure.git /opt/ansible/configuration
fi

# Run the playbooks for this machine. This will also configure a cron job that
# pulls changes and re-executes the playbooks going forward
sudo ansible-playbook \
  --connection=local \
  --inventory-file=/opt/ansible/configuration/inventory.ini \
  --limit="$(hostname)" \
  /opt/ansible/configuration/configure-machines.yml
