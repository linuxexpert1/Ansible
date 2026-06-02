Ansible Role: Decommissioning AWS EC2 Instances
====================================

[![Version](https://img.shields.io/static/v1.svg?style=flat&logo=github&label=tag&message=1.0.1&color=blue)](https://github.com/linuxexpert1/mmz-decomm/releases/tag/v1.0.1)

This is a generic Ansible role intended to be used for retiring MMZ's or any instances that reside in AWS Cloud infrastructure 

Requirements
------------
- Set your AWS Credential Environment Variables
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY

- Create the instance IDs list of variables before running the **decomm** role
    - Example:
```yaml
---
#vars file for role/deccom
instance_ids:
  - i-xxxxxxxxxxxxxxxx
  - i-xxxxxxxxxxxxxxxx
  - i-xxxxxxxxxxxxxxxx
  - i-xxxxxxxxxxxxxxxx
```
- Create the Route53 zone records and IPs list of variables before running the **decomm-route53** role
    - Example:
        - See  ./vars/README.txt as example on how to setup the variables
```yaml
---
#vars file for role/deccom
zonedns: "foo.com"
 
ttlvalue: 86400
 
recordns:
  - mmr.foo.com

values:
  - 3.x.x.x
```
Role Variables
--------------
- For Compute and Route53 **decomm** roles
    - See  ./defaults/main.yml
    - See  ./var/instance-id-file.yml 
    - See  ./var/dns-records-file.yml

- AWS_REGION: The region can be set in **defualts/main.yml** file

Executing the roles
------------------------
- Example of running the roles and add them to the site YAML file
  - site.yml file

```yaml
---
- hosts: localhost
  connection: local
  gather_facts: no
  vars:
    operation: 

  environment:
    AWS_REGION: "{{ region }}"

  tasks:

    - name: "Include AWS Compute Decomm roles"
      include_role:
        name: "{{ role_item }}"
      loop:
        - decomm
        - decomm-route53
      loop_control:
        loop_var: role_item
```

Execution Steps for the Decomm
-------------------------------

- Step 1
---------

```bash
$ ansible-playbook site.yml -e operation=stop --> Stop instance(s)
```
- Step 2
---------

```bash
$ ansible-playbook site.yml -e operation=destroy --> Terminate instances(s)
```

- Step 3
---------

```bash
$ ansible-playbook site.yml -e eip_release=true -e dnsaction=DELETE --> Cleanup EIP and DNS route53 
```

Dependencies
------------

None.

Using Galaxy
----------------
- If you are using your own seperate git repo then you can create requirements.yml and use *ansible-galaxy* command to download the roles

 - Example: Include the decomm'ed roles in your requirements.yml file.

```yaml
    - src: git@github.com:linuxexpert1/mmz-decomm.git
      scm: git
      version: "v1.0.0"
      name: decomm-roles
```

Install the required roles using Ansible Galaxy.
```bash
    $  ansible-galaxy install -r requirements.yml  --roles-path=mmz-repo 
    - extracting decomm-roles to /home/ahersi/github/zoom-aws/final/tmp/mmz-repo/decomm-roles
    - decomm-roles (v1.0.0) was installed successfully
    $ 
```
Bugs and Issues
---------------

Have a bug or an issue with this role? [Open a new issue](https://github.com/linuxexpert1/mmz-decomm/issues) here on GitHub.

Changelog
---------

See [changelog](CHANGELOG.md).

Author Information
------------------
This role was created in 2020 by [Abdi Hersi](https://github.com/linuxexpert1).

