$username = "administrator@testdomain.lan"
$password = "Password1"
$secstr = New-Object -TypeName System.Security.SecureString
$password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $secstr

Add-Computer -DomainName TESTDOMAIN.LAN -Credential $cred