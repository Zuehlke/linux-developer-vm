name 'vm'
maintainer 'Your Name'
maintainer_email 'your.name@example.com'
license 'MIT'
description 'Installs/Configures a Linux Developer VM'
long_description IO.read(File.join(File.dirname(__FILE__), '../../README.md'))
version '0.1.0'
issues_url 'https://github.com/Zuehlke/linux-developer-vm/issues'
source_url 'https://github.com/Zuehlke/linux-developer-vm'

chef_version '~> 12'

supports 'ubuntu'

depends 'apt', '7.1.1'
