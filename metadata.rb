name 'chef_task_3'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'all_rights'
description 'Installs/Configures chef_task_3'
long_description 'Installs/Configures chef_task_3'
version '0.1.0'

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Issues` link
# issues_url 'https://github.com/<insert_org_here>/chef_task_3/issues' if respond_to?(:issues_url)

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Source` link
# source_url 'https://github.com/<insert_org_here>/chef_task_3' if respond_to?(:source_url)

depends 'yum', '~> 4.1.0'
depends 'mysql', '~> 6.0'
depends 'apache', '~> 0.0.5'
depends 'database', '~> 6.1.1'
ruby depends 'mysql2_chef_gem', '~> 1.0'
depends 'simple_iptables', '~> 0.7.5'
