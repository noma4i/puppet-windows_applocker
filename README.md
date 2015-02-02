# windows_applocker

Manage Windows Applocker policy.

[Overview of Windows AppLocker](https://technet.microsoft.com/en-us/library/dd759113.aspx)

#### Available options

    `action` Allow | Deny

    `rule_id` uniq numbe to ensure rules deduplication

    `identity` Everyone, Admnistrator or other NT Identity name

    `app_path` Application path

    `app_name` Application name, `calculator.exe`

    `app_sha256` precalculated sha256 checksum

#### How to use

  - WIP -

  ````puppet
    windows_applocker { 'Lock something by Path':
      ensure => 'present',
      action => 'Deny',
      rule_type => 'path',
      rule_id => 1,
      app_path => 'C:\Program Files\Windows Mail\wabmig.exe',
      app_name => 'wabmig.exe'
    }
  ````

  ````puppet
    windows_applocker { 'Lock something By Hash':
      ensure => 'present',
      action => 'Deny',
      rule_type => 'hash',
      rule_id => 2,
      app_path => 'C:\Program Files\Windows Mail\wabmig.exe',
      app_name => 'wabmig.exe'
    }
  ````

  ````puppet
    windows_applocker { 'Lock something By KNOWN Hash':
      ensure => 'present',
      action => 'Deny',
      rule_type => 'hash',
      rule_id => 3,
      app_sha256 => 'ee6fa57f3dc1edb4bf663537665a4b6fe53927479416e4d893d11077699fc4fb',
      app_name => 'wabmig.exe'
    }
  ````