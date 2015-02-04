define windows_applocker (
  $rule_type = undef,
  $action = 'Allow',
  $rule_id = undef,
  $identity = 'Everyone',
  $app_path = undef,
  $app_name = undef,
  $app_sha256 = undef,
  $app_length = undef
){
  $appdata_folder = 'c:\ProgramData'
  if $rule_id == undef {
    fail('RULE ID is COMPULSORY!\n')
  } else {
    exec { "Creating GUID":
      command  => template('windows_applocker/guid.ps1.erb'),
      creates => "$appdata_folder\rules_$rule_id",
      provider => 'powershell',
    }
  }
  case $rule_type {
    'path': {
      if $app_path == undef { fail('APP PATH is COMPULSORY!\n') }
      if $app_name == undef { fail('APP NAME is COMPULSORY!\n') }
    }
    'hash': {
      if $app_sha256 == undef {
        if $app_path == undef { fail('APP PATH is COMPULSORY!\n') }
        if $app_name == undef { fail('APP NAME is COMPULSORY!\n') }
      } else {
        if $app_name == undef { fail('APP NAME is COMPULSORY!\n') }
        if $app_length == undef { fail('APP LENGTH is COMPULSORY!\n') }
      }
    }
    'wildcard': {
      if $app_path == undef { fail('APP PATH is COMPULSORY!\n') }
      $rule_type = 'path'
    }
    default: {
      fail('Invalid RULE TYPE option!\n')
    }
  }
  exec { "${action} ${app_name}":
    command  => template("windows_applocker/rule_$rule_type.ps1.erb"),
    provider => 'powershell',
    require => Exec['Creating GUID'],
    timeout  => 1800
  }->
  exec { 'cmd /c gpupdate || exit /b 0':
    path      => $::path,
    logoutput => false
  }
}