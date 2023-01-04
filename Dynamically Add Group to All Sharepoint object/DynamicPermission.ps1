
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


$Users = $row.Groups
#Write-Host $Users;
$CharArrayGroup = $Users.Split("||")
#Write-Host $CharArrayEmail;

if($row.ObjectType -eq "List" -or $row.ObjectType -eq "Library")
{
        $SiteURL = $row.SiteURL
        Connect-PnPOnline -Url $SiteURL -Interactive
        Set-PnPList -Identity $row.ObjectName -BreakRoleInheritance -CopyRoleAssignments
 
   For ($j=0; $j -le $CharArrayGroup.count; $j++) {
    Write-Host $CharArrayGroup[$j];
   if($j % 2 -eq 0)
    {
            #Write-Host $CharArrayEmail[$j];
            Set-PnPListPermission  -Identity $row.ObjectName.ToString() -AddRole $row.Permission -Group $CharArrayGroup[$j]
   $newrow = [PSCustomObject] @{
     "Groups" = $CharArrayGroup[$j];
     "Site" = $row.SiteURL;
     "ObjectName" = $row.ObjectName;
     "Status" = "Success";
 }

  $ListItemCollection += $newrow

    }
   }
 }


}
$OutFile = $($CurrentDirPath + "\Result.csv")
$ListItemCollection | Export-CSV $OutFile -NoTypeInformation
#$ListItemCollection | Export-CSV $ExportFile -NoTypeInformation


