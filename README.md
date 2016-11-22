# chef_task_3

TODO: Cookbook for MySQL server deployment with automated backups and web access to backups

## Cookbook Dependencies

Cookbook contain couple dependencies among them are "yum", "mysql", "mysql2_chef_gem", "apache2", "databases" and "simple_iptables".
"yum" been used to get latest packages and version of mysql which we need. "mysql" used to install MySQL server and configure it. "databases" used to manipulate mysql and "mysql2_chef_gem" is one of it dependecies. "apache2" used to manipulate with web server to get dumps available throught web interface. "simple_iptables" used to manipulate with system's firewall.


## Q & A

Q: what is cookstyle? how it's differs from rubocop?

A: Cookstyle is library for RuboCop, which reviewing latest core updates code style and rules. Cookstyle usually contain main style rules for cookbook and prevents of cookbook style failure after new RuboCop releases.

Q: what is rspec?

A: Rspec is a tool which helps to write right specs for delepor's code.

Q: what is Chef LWRP, HWRP ?

A: Light Weight Resource Provider it's enable to use already exists resources, which helps developers to create their recipes easier and faster. Heavy Weight Resource Providers allows developers to create their own resources, which make development much flexible.

Q: what is Chef custom resource?

A: They are resources that are not built in default Chef resource package. For exemple, Chef provides resources to manage file and system, but when developer need to make his code faster, easier and shorter, they use custom writed resources.

Q: what is encrypted databag, chef-vault?

A: Encrypted data bags allows to use data bags with confidential information not as plain text, but as encrypted. Chef-vault is package which enables to make data bag encryption by using public keys.
