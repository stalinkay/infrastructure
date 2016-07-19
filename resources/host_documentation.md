# Host documentation

## Preface

All hosts in this inventory are named according to the naming scheme defined by
http://mnx.io/blog/a-proper-server-naming-scheme/. The wordlist in use can be found
in `naming_wordlist.md`.

## Servers

### mustang.cweagans.net

* Host: Linode
* Datacenter: Fremont, CA, USA
* IP: 45.33.52.72
* OS: Ubuntu 16.04
* Additional names:
  * app01.fnc.cweagans.net
  * dokku.cweagans.net
* Notes:
  * 2GB RAM, 1 CPU core
  * 24GB SSD storage
  * 2TB xfer/month
  * 40Gbps in/125Mbps out

## Workstations

### legacy.cweagans.net

* Make: Apple
* Model: Macbook Pro
* OS: macOS
* Notes:
  * SSD + 16GB RAM
  * Will be removed from inventory upon configuring replacement machines. Target: Summer 2016

### voyager.cweagans.net

* Make: Asus
* Model: Q304U
* OS: Ubuntu 16.04
* Notes:
  * Encrypted mobile workstation
  * Shipped with 1TB HDD. Upgraded to 256GB SSD on purchase.
  * 6GB RAM, i5 CPU
  * Spec'd for light mobile work and long battery life

### cockpit.cweagans.net

* Make/model: n/a (hand built)
* OS: Ubuntu 16.04
* Notes:
  * Desktop workstation
  * Shared hardware with hazard.cweagans.net (dual boot)
  * SSD boot drive + 1TB data
  * 32GB RAM

### hazard.cweagans.net

* Make/model: n/a (hand built)
* OS: Windows 10 Home
* Notes:
  * Desktop workstation (mostly for gaming)
  * Shared hardware with cockpit.cweagans.net (dual boot)
  * SSD boot drive + 1TB data
  * 32GB RAM

## Appliances

### network.cweagans.net

* Make: Linksys
* Model: WRT1900ACS
* OS: OpenWRT Chaos Calmer (15.x)
* Additional names:
  * fwl01.boi.cweagans.net
  * home.cweagans.net (outside of the home network)
  * router.home.cweagans.net (inside of the home network)
* Notes:
  * Router/gateway for home network
  * Local DNS resolution
  * Wireless router
* Problems
  * Chronic stability problems (wireless drops frequently; wired seems okay)

### jupiter.cweagans.net

* Make: Synology
* Model: DSplay415
* OS: Synology DiskStation
* Additional names:
  * sto01.boi.cweagans.net
  * nas.home.cweagans.net
* Notes:
  * Home NAS/backup server/media server
  * Runs misc other services

### solar.cweagans.net

* Make/model: n/a (hand built)
* OS: Ubuntu 16.04
* Additional names:
  * app01.boi.cweagans.net
  * statusboard.home.cweagans.net
* Notes:
  * 2GB RAM. 1.6Ghz Atom
  * Should eventually transition to OpenWRT with a custom configuration

### octopus.cweagans.net

* Make: Raspberry
* Model: Pi 3 Model B 1.2
* OS: OctoPi (customization of Raspbian)
* Additional names:
  * app02.boi.cweagans.net
  * octoprint.home.cweagans.net
* Notes:
  * Runs Octoprint for controlling the 3D printer
  * Eventually should transition to OpenWRT with a custom configuration
