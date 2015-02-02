define windows_applocker (
  $ensure   = 'enabled',
  $action = 'Allow',
  $rule_id = undef,
  $identity = 'Everyone',
  $app_path = undef,
  $app_name = undef,
  $app_sha256 = undef
){
  case $ensure {
    'enabled', 'present': {
      # exec { "Allow ${app_name}":
      #   command  => template('windows_applocker/rule_hash.ps1.erb'),
      #   provider => 'powershell',
      #   timeout  => 1800
      # }->
      # exec { 'cmd /c gpupdate || exit /b 0':
      #   path      => $::path,
      #   logoutput => false
      # }
    }
    default: {
      fail('Invalid ensure option!\n')
    }
  }
}