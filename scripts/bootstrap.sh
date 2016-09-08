#!/usr/bin/env bash

# Exit on a nonzero exit code.
set -e

if [ -z "$1" ]; then
  echo "No hostname provided."
  echo "Usage: mac-linux-bootstrap.sh hostname.for.new.machine.local"
  exit 1
fi

if [ -z "$2" ]; then
  branch="master"
else
  branch="$2"
fi

if [ ! -z "$3" ]; then
  vault_pw = "$3"
fi

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

    # To match the behavior from the macOS provisioner, we'll just do this
    # unconditionally.
    sudo apt-get -qq install python-pip
    pip install --upgrade requests

    if [ ! -x "$(which ansible)" ]; then
      echo "Installing ansible..."
      sudo apt-get install software-properties-common
      sudo apt-add-repository ppa:ansible/ansible
      sudo apt-get update
      sudo apt-get -qq install ansible
    fi

    # Configure the system hostname so that we can use the right playbook for
    # provisioning.
    echo "The hostname that you've chosen for this machine is:"
    echo ""
    echo "  $1"
    echo ""
    echo "Note that this MUST EXACTLY MATCH the hostname configured in the Ansible"
    echo "inventory or provisioning will NOT work as expected. DOUBLE CHECK THIS"
    echo "VALUE RIGHT NOW."
    echo ""
    echo "Waiting 10 seconds before continuing. If you made a typo, now is the time"
    echo "to Ctrl+C before provisioning continues!"
    sleep 6
    echo "Seriously! You better be sure!"
    sleep 2
    echo "Last chance!"
    echo "3"
    sleep 1
    echo "2"
    sleep 1
    echo "1"
    sleep 1
    echo "You can't say you weren't given ample notice!"
    echo "Setting hostname to $1 and continuing..."

    sudo hostnamectl set-hostname $1
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

# If we have a vault pw, save it to /opt/ansible/vault_pw
if [ ! -z "$vault_pw" ]; then
  echo $vault_pw > /opt/ansible/vault_pw
fi

if [ ! -d "/opt/ansible/configuration" ]; then
  sudo git clone --branch=$branch https://github.com/cweagans/infrastructure.git /opt/ansible/configuration
else
  pushd /opt/ansible/configuration
    sudo git pull
  popd
fi

# Run the playbooks for this machine. This will also configure a cron job that
# pulls changes and re-executes the playbooks going forward
if [ -e /opt/ansible/vault_pw ]; then
  sudo ansible-playbook \
    --connection=local \
    --inventory-file=/opt/ansible/configuration/inventory.ini \
    --limit="$(hostname)" \
    --vault-password-file /opt/ansible/vault_pw \
    /opt/ansible/configuration/configure-machines.yml
else
  sudo ansible-playbook \
    --connection=local \
    --inventory-file=/opt/ansible/configuration/inventory.ini \
    --limit="$(hostname)" \
    /opt/ansible/configuration/configure-machines.yml
fi
