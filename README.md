# Personal infrastructure

I use this repository to configure anything I own that can run Ansible and Git.
It turns out that this is not a large number of things, but it's large enough
that it may be unpleasant to keep configuration in sync by hand.

## Overview

Setting up a new machine is as simple as adding it to the inventory, adding some
roles to apply in the configure-machines playbook, and then running the bootstrap
script.

The bootstrap script will ensure that system dependencies are installed (Ansible
and Git, mostly), clone the repo, and then run the playbook. Part of the playbook
sets up a cronjob to continue updating and running the playbook over time, so
changing a setting across all machines is as simple as a single commit to this
repo.

## Usage

I'm using the `curl | bash` pattern. I don't care if you don't like it. It's the
most convenient thing for me. If you happen to have something that's *more*
convenient, do let me know.

Make sure you replace `hostname.local` with the inventory hostname for the machine
that you're configuring. Otherwise, provisioning may not work as expected.

**Stable**:

```
curl https://raw.githubusercontent.com/cweagans/infrastructure/master/scripts/mac-linux-bootstrap.sh | bash -s -- hostname.local
```

**Development**:

```
curl https://raw.githubusercontent.com/cweagans/infrastructure/master/scripts/mac-linux-bootstrap.sh | bash -s -- hostname.local develop
```

## Support

(As in...OS support. I probably won't support you if you choose to use this directly)

  * Ubuntu Xenial (16.04)
  * macOS (most recent)
  * Eventually: Windows (via cygwin installed ansible)

## Known issues

* Ansible's `user` module requires plaintext passwords to update the password on
  macOS. This is dumb. The `user_accounts` role updates passwords for Linux-ish
  systems, but not on macOS for this reason.
