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
    exec { "Creating GUID for Rule #${rule_id}":
      command  => template('windows_applocker/guid.ps1.erb'),
      provider => 'powershell',
    }
  }
  case $rule_type {
    'path': {
      $real_rule = $rule_type
      if $app_path == undef { fail('APP PATH is COMPULSORY!\n') }
      if $app_name == undef { fail('APP NAME is COMPULSORY!\n') }
    }
    'hash': {
      $real_rule = $rule_type
      if $app_sha256 == undef {
        if $app_path == undef { fail('APP PATH is COMPULSORY!\n') }
        if $app_name == undef { fail('APP NAME is COMPULSORY!\n') }
      } else {
        if $app_name == undef { fail('APP NAME is COMPULSORY!\n') }
        if $app_length == undef { fail('APP LENGTH is COMPULSORY!\n') }
      }
    }
    'wildcard': {
      $real_rule = 'path'
      if $app_path == undef { fail('APP PATH is COMPULSORY!\n') }
    }
    default: {
      fail('Invalid RULE TYPE option!\n')
    }
  }
  exec { "${action} ${app_name} by ${rule_type} rule #${rule_id}":
    command  => template("windows_applocker/rule_${real_rule}.ps1.erb"),
    provider => 'powershell',
    require => Exec["Creating GUID for Rule #${rule_id}"],
    timeout  => 1800
  }
}