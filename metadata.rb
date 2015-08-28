name              "python"
maintainer        "Noah Kantrowitz"
maintainer_email  "noah@coderanger.net"
license           "Apache 2.0"
description       "Installs Python, pip and virtualenv. Includes LWRPs for managing Python packages with `pip` and `virtualenv` isolated Python environments."
version           "1.4.7"

depends           "build-essential"
depends           "yum-epel"
depends           "windows"

recipe "python", "Installs python, pip, and virtualenv"
recipe "python::package", "Installs python using packages."
recipe "python::source", "Installs python from source."
recipe "python::pip", "Installs pip from source."
recipe "python::virtualenv", "Installs virtualenv using the python_pip resource."
recipe "python::windows", "Installs python on Windows from an MSI package"

%w{ debian ubuntu centos redhat fedora freebsd smartos windows }.each do |os|
  supports os
end
