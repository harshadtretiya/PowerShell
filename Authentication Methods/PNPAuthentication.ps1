# default password and url
$SiteURL= "https://crescent.sharepoint.com"
$UserName="user"
$Password = "Password"

$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
Connect-PnPOnline -Url $SiteURL -Credentials $Cred


# MFA Account connection
Connect-PnPOnline -Url $SiteURL -Interactive