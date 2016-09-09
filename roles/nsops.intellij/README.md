# Ansible: IntelliJ IDEA Community

[![Build Status](https://travis-ci.org/nsops/ansible-intellij.svg?branch=master)](https://travis-ci.org/nsops/ansible-intellij) [![Ansible Galaxy](http://img.shields.io/badge/galaxy-nsops.intellij-blue.svg?style=flat)](https://galaxy.ansible.com/nsops/intellij/)

Install IntelliJ Idea Community in Ubuntu

### Requirements
- Java. It's recommended to install Ansible role: ```nsops.java```.

### Variables
None

### Dependencies
None

### Usage
```yaml
- hosts: all
  role:
    - { name: nsops.intellij }
```

### License
MIT