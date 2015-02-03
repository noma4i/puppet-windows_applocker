define windows_applocker (
  $rule_type = undef,
  $action = 'Allow',
  $rule_id = undef,
  $identity = 'Everyone',
  $app_path = undef,
  $app_name = undef,
  $app_sha256 = undef
){
  $appdata_folder = 'c:\ProgramData'
  if $rule_id == undef {
    fail('RULE ID is COMPULSORY!\n')
  } else {
    exec { "Creating GUID":
      command  => template('windows_applocker/guid.ps1.erb'),
      provider => 'powershell',
      timeout  => 1800
    }
  }
  case $rule_type {
    'path': {
      if $app_path == undef { fail('APP PATH is COMPULSORY!\n') }
      if $app_name == undef { fail('APP NAME is COMPULSORY!\n') }

      exec { "${action} ${app_name}":
        command  => template('windows_applocker/rule_path.ps1.erb'),
        provider => 'powershell',
        subscribe => Exec['Creating GUID'],
        timeout  => 1800
      }

    }
    'hash': {

    }
    'wildcard': {

    }
    default: {
      fail('Invalid RULE TYPE option!\n')
    }
  }
  exec { 'cmd /c gpupdate || exit /b 0':
    path      => $::path,
    subscribe => Exec["${action} ${app_name}"],
    logoutput => false
  }
}
      # exec { "Allow ${app_name}":
      #   command  => template('windows_applocker/rule_hash.ps1.erb'),
      #   provider => 'powershell',
      #   timeout  => 1800
      # }->
      # exec { 'cmd /c gpupdate || exit /b 0':
      #   path      => $::path,
      #   logoutput => false
      # }
