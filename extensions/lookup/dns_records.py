
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible.plugins.lookup import LookupBase
from ansible.utils.listify import listify_lookup_plugin_terms

import sys

class LookupModule(LookupBase):

    def run(self, terms, **kwargs):

        items = []

        domain_entries = listify_lookup_plugin_terms(self._flatten(terms), templar=self._templar, loader=self._loader)

        print(sys.path)

        for domain_entry in domain_entries:
            domain = domain_entry['domain']

            for record in domain_entry['entries']:
                new_item = {
                    'domain': domain,
                    'record': record['record'],
                    'value': record['value'],
                    'type': record['type'],
                    'state': record['state'] if record.has_key('state') else "present",
                }

                for configKey in ['priority', 'port', 'proto', 'service', 'ttl', 'weight']:
                    if record.has_key(configKey):
                        new_item[configKey] = record[configKey]

                items.append(new_item)

        return items
