# = Class: mayflowerzypprepo
#
# This is the mayflower zypper repo class
#
# This class will install SLES Repos and the Mayflower Repos
#
# == Parameters
#
# == Examples
#
# Call mayflowerzypprepo as a parametrized class:
#
# class { 'mayflowerzypprepo' : }
#
class mayflowerzypprepo {
  $major_version = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1')
  $service_pack  = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','SP\2')

  zypprepo { "SLES${major_version}-${service_pack}-${::operatingsystemrelease}-0":
    name         => "SLES${major_version}-${service_pack}-${::operatingsystemrelease}-0",
    baseurl      => "http://uboot4man.dmz.muc.mayflower.zone/SLES/${::operatingsystemrelease}/${::architecture}/",
    enabled      => 1,
    autorefresh  => 1,
    gpgcheck     => 0,
    priority     => 99,
    keeppackages => 1,
    type         => 'yast2',
  }

  zypprepo { "SLES${major_version}${service_pack}-SDK":
    name         => "SLES${major_version}${service_pack}-SDK",
    baseurl      => "http://uboot4man.dmz.muc.mayflower.zone/SLES_SDK/${::operatingsystemrelease}/${::architecture}/",
    enabled      => 1,
    autorefresh  => 1,
    gpgcheck     => 0,
    priority     => 99,
    keeppackages => 1,
    type         => 'yast2',
  }

  rpmkey { '9CA70524':
    ensure => present,
    source => "http://download.opensuse.org/repositories/home:/mayflower/SLE_${major_version}_${service_pack}/repodata/repomd.xml.key",
  }

  zypprepo { "Extra Packages for SLE_${major_version}_${service_pack}":
    name         => "MF-SLES${major_version}${service_pack}",
    baseurl      => "http://download.opensuse.org/repositories/home:/mayflower/SLE_${major_version}_${service_pack}",
    enabled      => 1,
    autorefresh  => 1,
    gpgcheck     => 0,
    priority     => 97,
    keeppackages => 1,
    type         => 'rpm-md',
  }
}
