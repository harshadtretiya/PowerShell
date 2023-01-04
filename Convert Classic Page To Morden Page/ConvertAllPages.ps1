#Set Parameters
$CurrentDirPath = Split-Path $script:MyInvocation.MyCommand.Path
$SiteURL="YourSite"
 
#Connect to Site
Connect-PnPOnline $SiteURL -Interactive #-Credentials (Get-Credential)
 
#Get All Pages from "Site Pages" Library
$Pages = Get-PnPListItem -List SitePages -PageSize 500


 
Try {
    $ListInventory= @()
    ForEach($Page in $Pages)
    {

    $Data = new-object PSObject
    $Data | Add-member NoteProperty -Name "Site URL" -Value $SiteURL

        #Get the page name
        $PageName = $Page.FieldValues.FileLeafRef
        $Data | Add-member NoteProperty -Name "Page Name" -Value $PageName
        Write-host "Converting Page:"$PageName
 
        #Check if the page is classic
        If($Page.FieldValues["ClientSideApplicationId"] -eq "b6917cb1-93a0-4b97-a84d-7cf49975d4ec")
        {
            Write-host "`tPage is already Modern:"$PageName -f Yellow
            $Data | Add-member NoteProperty -Name "Result" -Value "Already Modern"

        }
        Else
        {
            #Convert the classic page to modern page
            ConvertTo-PnPPage -Identity $PageName -Overwrite -TakeSourcePageName -AddPageAcceptBanner
            $Data | Add-member NoteProperty -Name "Result" -Value "Converted"
            Write-host "`tPage Converted to Modern!" -f Green    
        }
        $ListInventory += $Data
    }

}
Catch {
    write-host -f Red "Error Converting Classic Page to Modern!" $_.Exception.Message
}
$OutFile = $($CurrentDirPath + "\Result.csv")
$ListInventory | Export-CSV $OutFile -NoTypeInformation

