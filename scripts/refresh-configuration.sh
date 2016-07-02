#!/usr/bin/env bash

# ATTENTION: This script is run as root periodically, so don't do stupid shit here.

# If we have an internet connection (working DNS + a route to Github), then
# update our local copy of the Ansible playbooks if necessary...
if ping -q -c 1 -W 1 github.com >/dev/null; then
  pushd /opt/ansible/configuration
    # Bring remote refs up to date.
    git remote update

    # Only pull if we need to.
    LOCAL_REF=$(git rev-parse @)
    REMOTE_REF=$(git rev-parse @{u})
    if [ "$LOCAL" != "$REMOTE" ]; then
      git pull
    fi
  popd
fi

# ...then, even if we didn't update, run the Ansible playbook.
ansible-playbook \
  --connection=local \
  --inventory-file=/opt/ansible/configuration/inventory.ini \
  --limit="$(hostname)" \
  /opt/ansible/configuration/configure-machines.yml
