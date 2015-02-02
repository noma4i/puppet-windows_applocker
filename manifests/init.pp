class windows_applocker (
  $ensure   = 'enabled'
){
  case $ensure {
    'enabled', 'present': {

    }
    default: {
      fail('Invalid ensure option!\n')
    }
  }
}
