#!/usr/bin/env bash

# ATTENTION: This script is run as root periodically, so don't do stupid shit here.

# First, check to see if there is another Ansible run already in progress.
# If so, then exit. 0 exit code because it's not a failure. We're just choosing to skip.
# If not, create the lock file.
if [ -e /opt/ansible/refresh.lock ]; then
  exit 0
else
  echo "Run started at $(date)" > /opt/ansible/refresh.lock
fi

# If we have an internet connection (working DNS + a route to Github), then
# update our local copy of the Ansible playbooks if necessary...
if ping -q -c 1 -W 1 github.com >/dev/null; then
  pushd /opt/ansible/configuration
    # Bring remote refs up to date.
    git remote update

    # Only pull if we need to.
    LOCAL_REF=$(git rev-parse @)
    REMOTE_REF=$(git rev-parse @{u})
    if [ "$LOCAL_REF" != "$REMOTE_REF" ]; then
      git pull
    fi
  popd
fi

# ...then, even if we didn't update, run the Ansible playbook. Using pushd/popd
# so that ansible picks up the configuration options in ansible.cfg.
pushd /opt/ansible/configuration
  if [ -e /opt/ansible/vault_pw ]; then
    ansible-playbook \
      --connection=local \
      --inventory-file=./inventory.ini \
      --limit="$(hostname)" \
      --vault-password-file /opt/ansible/vault_pw \
      ./configure-machines.yml
  else
    ansible-playbook \
      --connection=local \
      --inventory-file=./inventory.ini \
      --limit="$(hostname)" \
      ./configure-machines.yml
  fi
popd

# Finally, remove the lock file so that future configuration changes will run.
rm /opt/ansible/refresh.lock
