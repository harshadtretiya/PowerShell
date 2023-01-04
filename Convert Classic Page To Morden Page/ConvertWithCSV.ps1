$CurrentDirPath = Split-Path $script:MyInvocation.MyCommand.Path

$InvFile = $($CurrentDirPath + "\PageDetails.csv")

$FileExists = (Test-Path $InvFile -PathType Leaf)  

if ($FileExists) {  
    "Loading $InvFile for processing..."  
    $tblData = Import-CSV $InvFile  
} else {  
    "$InvFile not found - stopping import!"  

}
$ListInventory= @()
foreach ($row in $tblData) {

#Set Parameters
$SiteURL= $row.SiteURL 
$ClassicPageName = $row.PageName
    Connect-PnPOnline $SiteURL -Interactive
    $Page = Get-PnPListItem  -List "Site Pages" -Query "<View><Query><Where><And><Eq><FieldRef Name='FileLeafRef'/><Value Type='Text'>$($row.PageName)</Value></Eq><Neq><FieldRef Name='ClientSideApplicationId'/><Value Type='Text'>b6917cb1-93a0-4b97-a84d-7cf49975d4ec</Value></Neq></And></Where></Query></View>" 
    if($Page -ne $null)
    {
        $Data = new-object PSObject
        $Data | Add-member NoteProperty -Name "Site URL" -Value $SiteURL
        #Get the page name
        $PageName = $Page.FieldValues.FileLeafRef
        $Data | Add-member NoteProperty -Name "Page Name" -Value $PageName
        #Check if the page is classic
         ConvertTo-PnPPage -Identity $PageName -Overwrite -TakeSourcePageName -AddPageAcceptBanner
        $ListInventory += $Data
    }
   

}
$OutFile = $($CurrentDirPath + "\Result.csv")
$ListInventory | Export-CSV $OutFile -NoTypeInformation