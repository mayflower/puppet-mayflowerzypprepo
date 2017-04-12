# Mayflower zypper repo class
#
# This class will install SLES Repos and the Mayflower Repos
#
# @summary Installs SLES Repos and the Mayflower Repos
#
# @example Install SLES repos with the URLs given
# class { 'mayflowerzypprepo':
#   enable_sle => true,
#   sle_url    => "http://your.sles.mirror.here/SLES/11_SP4",
#   enable_sdk => true,
#   sdk_url    => "http://your.sles.mirror.here/SLES_SDK/11_SP4",
# }
#
# @param enable_sle Enables the SLES repo
# @param sle_url URL of the SLES repo
# @param enable_sdk Enables the SLES SDK repo
# @param sdk_url URL of the SLES SDK repo
# @param enable_nodejs Enabled the Mayfloer Node.js repo
class mayflowerzypprepo (
  Boolean $enable_sle    = false,
  String  $sle_url       = undef,
  Boolean $enable_sdk    = false,
  String  $sdk_url       = undef,
  Boolean $enable_nodejs = false,
) {
  $major_version  = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1')
  $service_pack   = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','SP\2')
  $slesrepostring = "SLE_${major_version}_${service_pack}"

  rpmkey { '9CA70524':
    ensure => present,
    source => "http://download.opensuse.org/repositories/home:/mayflower/${slesrepostring}/repodata/repomd.xml.key",
  }

  zypprepo { "Mayflower Packages for ${slesrepostring}":
    name         => "MF-${slesrepostring}",
    baseurl      => "http://download.opensuse.org/repositories/home:/mayflower/${slesrepostring}",
    enabled      => 1,
    autorefresh  => 1,
    gpgcheck     => 0,
    priority     => 97,
    keeppackages => 1,
    type         => 'rpm-md',
  }

  if $enable_nodejs {
    rpmkey { '270E2386':
      ensure => present,
      source => "http://download.opensuse.org/repositories/devel:/languages:/nodejs/${slesrepostring}/repodata/repomd.xml.key",
    }

    zypprepo { "Node.js Packages for ${slesrepostring}":
      name         => "MF-Node.js-${slesrepostring}",
      baseurl      => "http://download.opensuse.org/repositories/devel:/languages:/nodejs/${slesrepostring}/",
      enabled      => 1,
      autorefresh  => 1,
      gpgcheck     => 0,
      priority     => 99,
      keeppackages => 1,
      type         => 'rpm-md',
    }
  }

  if $enable_sle {
    zypprepo { "SLES${major_version}-${service_pack}-${::operatingsystemrelease}-0":
      name         => "SLES${major_version}-${service_pack}-${::operatingsystemrelease}-0",
      baseurl      => $sle_url,
      enabled      => 1,
      autorefresh  => 1,
      gpgcheck     => 0,
      priority     => 99,
      keeppackages => 1,
      type         => 'yast2',
    }
  }

  if $enable_sdk {
    zypprepo { "SLES${major_version}${service_pack}-SDK":
      name         => "SLES${major_version}${service_pack}-SDK",
      baseurl      => $sdk_url,
      enabled      => 1,
      autorefresh  => 1,
      gpgcheck     => 0,
      priority     => 99,
      keeppackages => 1,
      type         => 'yast2',
    }
  }
}
