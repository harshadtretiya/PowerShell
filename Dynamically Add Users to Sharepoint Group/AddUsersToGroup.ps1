$CurrentDirPath = Split-Path $script:MyInvocation.MyCommand.Path

$InvFile = $($CurrentDirPath + "\UsersToAdd.csv")

$FileExists = (Test-Path $InvFile -PathType Leaf)  

if ($FileExists) {  
    "Loading $InvFile for processing..."  
    $tblData = Import-CSV $InvFile  
} else {  
    "$InvFile not found - stopping import!"  

}
$ListItemCollection = @();


foreach ($row in $tblData) {


$Users = $row.UsersEmail
#Write-Host $Users;
$CharArrayEmail = $Users.Split("||")
#Write-Host $CharArrayEmail;
$SiteURL = $row.SiteURL

 #Connect-PnPOnline -Url https://tretiya.sharepoint.com/sites/$Site -Interactive
 
Connect-PnPOnline -Url $SiteURL -Interactive
#Set-PnPList -Identity $row.ObjectName -BreakRoleInheritance -CopyRoleAssignments
 
   For ($j=0; $j -le $CharArrayEmail.count; $j++) {
    Write-Host $CharArrayEmail[$j];
   if($j % 2 -eq 0)
    {

    
    #Get the Associcated Owners group of the site
    $Web = Get-PnPWeb
    
    if($row.GroupName -eq "Owner")
    {
    $Group = Get-PnPGroup -AssociatedOwnerGroup

    }
    elseif($row.GroupName -eq "Member")
    {
    $Group = Get-PnPGroup -AssociatedMemberGroup

    }
    elseif($row.GroupName -eq "Visitor")
    {
    $Group = Get-PnPGroup -AssociatedVisitorGroup

    }
    Add-PnPGroupMember -LoginName $CharArrayEmail[$j] -Identity $Group

           
           
   $newrow = [PSCustomObject] @{
     "User" = $CharArrayEmail[$j];
     "Site" = $row.SiteURL;
     "GroupName" = $row.GroupName;
     "Status" = "Success";
 }

  $ListItemCollection += $newrow

    }
   }
 


}
$OutFile = $($CurrentDirPath + "\Result.csv")
$ListItemCollection | Export-CSV $OutFile -NoTypeInformation
#$ListItemCollection | Export-CSV $ExportFile -NoTypeInformation






