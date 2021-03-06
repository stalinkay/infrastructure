---

security_sudoers_passworded:
  - cweagans
  - cjcurrie

user_accounts:
  - name: cweagans
    uid: 501
    ssh_public_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDT7Q2+M6sMDM56xSKzMJogPOxWKbIU6QTqeXAR0CBRrR0spML3m1xnYn2AtNScvxlLivnlnAq5RH/CSdAzXpkutGvc7Vm9S6SxlU6YQDS+c805Ib6J0Jwh7uaXUODZujssUldcb00ixQStUEToXaG/v2z0jYfja84PTrrIXib58FdSG+Eu016FJPW4G2q06KIGoxzqGhiFPf67S+OJCLL1PYV1p+Nh3rXIzk0KKR9t9/MYBZjYIELZSCRqf7MFxYay2aGtGm7f/3RiCfbgHw6AxFSRng5SryEutIoGstjzRHPm7KFFTjyrhaRfgVsIB1D+vmtPRa46w/tfd0HO7HrHGZ0eri03PSGbrSplm5qJa/GwVT7pNIqOBnjM7DntgifpWcoLFEftZRH3RiL6GNjEcJ75rO2xf4lUbn2eJHgtpQTOO4iOnu4nniiGQGKb7A8q0ATchKUm8e3KOHLI38GT8q8fzN8d83dmU1c0IFOAV/cFQex1fU2CSVdqG6eIfP8l14ZizMh0hAdSttIEJrAHRAzm6F71WbygcgL7MnWZ3MT5EQVHVtJ/QdGgDJv19Rw+JKXKTKFSftGz3F96uryyENZjamHshfTRacT9iMRfDahQgFJmGRex2mvVMr0ddQaXVliwsz+3SIke4WbexvpQ3RoO4sB+pu5G2JQmB/3p4Q=="
    state: present
    pass: "$6$rounds=656000$BQ2ImRoOpbGgXMX.$5s4BIwZ.HN5Ws1pMfY0.tUqBqEOUEagcCUr7r6lm9TLkGD9FDY3/wK7BTC2Xbn4Ptf6kKfyPXp5/9Z26TQ00m/"
    groups: "{{ user_admin_group }}"
    shell: "bash"
  - name: cjcurrie
    uid: 502
    ssh_public_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUGXIbGdcY1hBAoNCdVr0meRuO8aCSSGJufK1k3T5bbGZwchkZzdeG1UDrFdBo+8kL1BreNeZ7txCyHL6y/8lCCRa9KEdf5ylqCwzTQUUcNQKprkSqyfTHsymiCZMZW60mLiuDlNKUSmCGxiU5LBGEEyIgk8N/YxLtpU6PdGdwb6il6tUHYQbf1anhZAWvSTyo3r+zxwpz20dD1EgWsoebWSCPv9zQb6dQJLg5EWT3he9TPzDRWZ9gg4Y+7UCTcQiFL8kdFOr/ucnPx9HEguTP1qgBjlcG9oKNX5Ym/jIyUuLe6yTeuqtJsut7DOiCxTmTs8fuKXtceTGxHsXEzJej cjcurrie@CJs-MacBook-Pro.local"
    state: present
    pass: "$6$rounds=656000$xd4qCcXElvEoyyF5$qDMdMmag.wYyrjLllW6cCvb4gcr1zCAVHyOFtcW/4j6J8T6YaLf5cd7DH2VuKMiI5MsavnZSYhgJgHDbFmtFS."
    groups: "{{ user_admin_group }}"
    shell: "bash"
