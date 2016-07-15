#!/usr/bin/env bash

# Exit on a nonzero exit code.
set -e

# If no arg is provided, bail early.
if [ -z "$1" ]; then
  echo "You must provide the name for your new role."
  exit 1
fi

# Bail out if the role already exists.
if [ -e "roles/$1" ]; then
  echo "Role $1 already exists."
  exit 1
fi

mkdir roles/$1
mkdir roles/$1/defaults
mkdir roles/$1/tasks
echo "---" > roles/$1/defaults/main.yml
echo "---" > roles/$1/tasks/setup-Darwin.yml
echo "---" > roles/$1/tasks/setup-Debian.yml
cat << EOF > roles/$1/tasks/main.yml
---

- include: setup-Debian.yml
  when: ansible_os_family == 'Debian'

- include: setup-Darwin.yml
  when: ansible_os_family == 'Darwin'

EOF

echo "Done."
