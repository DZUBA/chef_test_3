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
depends 'mysql', '~> 8.0.2'
depends 'iptables', '~> 3.0.1'
depends 'apache', '~> 0.0.5'
depends 'mysql', '~> 8.1.1'
