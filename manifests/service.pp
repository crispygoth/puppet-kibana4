# == Class: kibana4
#
# Service creation and mgmt
#
class kibana4::service {

  # init file from template
  if ($kibana4::manage_service_file) {
    file { "/lib/systemd/system/${kibana4::service_name}.service":
      ensure  => present,
      mode    => '0644',
      content => template($kibana4::service_template),
      group   => root,
      owner   => root,
    }
    $require = File["/lib/systemd/system/${kibana4::service_name}.service"]
  } elsif ($kibana4::manage_init_file == true) {
    file { "/etc/init.d/${kibana4::service_name}":
      ensure  => present,
      mode    => '0755',
      content => template($kibana4::init_template),
      group   => root,
      owner   => root,
    }

    file { '/etc/default/kibana4':
      ensure  => file,
      mode    => '0644',
      content => template('kibana4/default.erb'),
      group   => root,
      owner   => root,
    }

    $require = [File["/etc/init.d/${kibana4::service_name}"], File['/etc/default/kibana4']]
  } else {
    $require = undef
  }

  service { 'kibana4':
    ensure     => $kibana4::service_ensure,
    enable     => $kibana4::service_enable,
    name       => $kibana4::service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => $require
  }

}
