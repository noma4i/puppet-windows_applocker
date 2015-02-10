# windows_applocker

Manage Windows Applocker policy.

[Overview of Windows AppLocker](https://technet.microsoft.com/en-us/library/dd759113.aspx)

#### Available options

**rule_type**
- path
- hash
- wildcard

**action**
- Allow (default)
- Deny

**rule_id**
- Rule id MUST be uniq. Is used to check rule presence

**identity**
- Everyone (default)
- NT Identity name like: All, Administrator etc

**app_path**
- Path

**app_name**
- Application name, `calculator.exe`

**app_sha256**
- Precalculated sha256 checksum

**app_length**
- Precalculated app length in bytes

#### How to use

  ````puppet
    windows_applocker { 'Default Rule Windows':
      rule_type => 'wildcard',
      rule_id => 100,
      app_path => '%WINDIR%\*',
    }
    windows_applocker { 'Default Rule Program Files':
      rule_type => 'wildcard',
      rule_id => 200,
      app_path => '%PROGRAMFILES%\*',
    }

    windows_applocker { 'Unlock WABMIG':
      rule_type => 'path',
      rule_id => 300,
      app_path => 'C:\Program Files\Windows Mail\wabmig.exe',
      app_name => 'wabmig.exe'
    }

    windows_applocker { 'Unlock WABMIG by hash':
      rule_type => 'hash',
      rule_id => 400,
      app_path => 'C:\Program Files\Windows Mail\wabmig.exe',
      app_name => 'wabmig.exe'
    }

    windows_applocker { 'Unlock WABMIG by PATH Mask':
      rule_type => 'wildcard',
      rule_id => 500,
      app_path => 'C:\Program Files\Windows Mail\*'
    }

    windows_applocker { 'Unlock WABMIG by KNOWN Hash':
      rule_type => 'hash',
      rule_id => 600,
      app_name => 'test.exe',
      app_sha256 => '6c383b5b1c396bdd1484d77d479ca5cb7ac30d8b8352b1975f8c9c59132562ac',
      app_length => '202020'
    }

    windows_applocker { 'Lock Regedit':
      rule_type => 'hash',
      rule_id => 600,
      app_path => '%WINDIR%\regedit.exe',
      app_name => 'regedit.exe',
      action => 'Deny'
    }

  ````
