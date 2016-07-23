#!/usr/bin/env bash

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

package_error=0

if [ ! -x "$(which git)" ]; then
  echo "Missing dependency: Git"
  package_error=1
fi

if [ ! -x "$(which python)" ]; then
  echo "Missing dependency: Python"
  package_error=1
fi

if [ ! -x "$(which pip)" ]; then
  echo "Missing dependency: pip"
  package_error=1
else
  # We'll just do this unconditionally, as it doesn't hurt anything.
  pip install --upgrade requests
fi

if [ ! -x "$(which ansible)" ]; then
  echo "Missing dependency: Ansible"
  package_error=1
fi

if [ "$package_error" == "1" ]; then
  echo "Please resolve dependency errors listed above and re-run this script."
  exit 1
fi

echo "Checking that hostname is set to $1..."

cat /etc/config/system | grep "$1" > /dev/null
statuscode=$?
if [ $statuscode -ne 0 ]; then
  echo "Hostname is not set to $1! Edit /etc/config/system to set the hostname,"
  echo "and then re-run this script with the same arguments."
  exit 1
fi

# Past this point, everything is okay.

# Create the ansible dir and clone the repo.
# Note: we're using /opt/ansible instead of /etc/ansible for consistency across
# operating systems.
if [ ! -d "/opt/ansible" ]; then
  sudo mkdir /opt/ansible
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
sudo ansible-playbook \
  --connection=local \
  --inventory-file=/opt/ansible/configuration/inventory.ini \
  --limit="$1" \
  /opt/ansible/configuration/configure-machines.yml
