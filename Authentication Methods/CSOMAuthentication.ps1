#Variables for processing
$AdminCenterURL = "https://crescent-admin.sharepoint.com"
 
#User Name Password to connect
$AdminUserName = "Salaudeen@crescent.com"
$AdminPassword = "xbcvvdjzedpcqdjkek" #App Password
 
#Prepare the Credentials
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AdminUserName, $SecurePassword
  
#Connect to SharePoint Online tenant
Connect-SPOService -url $AdminCenterURL -Credential $Cred

# connect sharepoint

#Admin Center URL of your SharePoint Online
$AdminSiteURL= "https://crescent-admin.sharepoint.com"
  
#Connect to SharePoint Online services
Connect-SPOService -url $AdminSiteURL -Credential (Get-Credential)

#MFA
Connect-SPOService -Url https://YourTenant-admin.sharepoint.com

