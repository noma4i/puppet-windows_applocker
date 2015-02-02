define windows_applocker (
  $ensure   = 'enabled'
){
  case $ensure {
    'enabled', 'present': {
      $permanent_id = 100
      $identity = 'Everyone'
      $app_path = 'C:\Program Files\Windows Mail\wabmig.exe'
      $app_name = 'wabmig.exe'
      $action = 'Allow'
      exec { "Allow ${app_name}":
        command  => template('windows_applocker/rule_hash.ps1.erb'),
        provider => 'powershell',
        timeout  => 1800
      }->
      exec { 'cmd /c gpupdate || exit /b 0':
        path      => $::path,
        logoutput => false
      }
    }
    default: {
      fail('Invalid ensure option!\n')
    }
  }
}