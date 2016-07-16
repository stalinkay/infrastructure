# Callback module for Ansible that sends an email when a host is changed or
# a playbook fails.

from ansible.plugins.callback import CallbackBase
from ansible.utils.unicode import to_bytes
import os
import requests

class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'notification'
    CALLBACK_NAME = 'change_fail_notify'
    CALLBACK_NEEDS_WHITELIST = True

    def _notify(self, eventType, host):

        request_data = {
            'namespace': 'ansible',
            'event_type': eventType,
            'context[host]': host,
            'context[somethingelse]': 'whatever'
        }

        request_headers = {
            'User-Agent': 'Ansible'
        }

        r = requests.post(os.getenv('NOTIFY_URL', 'http://requestb.in/uzw7n8uz'), data=request_data, headers=request_headers)

    def v2_playbook_on_stats(self, stats):

        hosts = sorted(stats.processed.keys())
        for h in hosts:

            t = stats.summarize(h)

            has_fail = False
            has_change = False

            if t['failures']:
                has_fail = True

            if t['changed']:
                has_change = True

            if has_fail:
                self._notify('fail', h)

            if has_change:
                self._notify('change', h)
