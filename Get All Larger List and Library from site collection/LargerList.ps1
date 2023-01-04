$CurrentDirPath = Split-Path $script:MyInvocation.MyCommand.Path
$SiteURL= "https://test.sharepoint.com/sites/Practice"
$UserName="test@test.onmicrosoft.com"
$Password = "password"
$Threshold = 5000
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword

Try {
    #Connect to PnP Online
    
    Connect-PnPOnline -Url $SiteURL -Credentials $Cred
    #Connect-PnPOnline -Url $SiteURL -Interactive
 
    #Get All Webs from the site collection
    $SubWebs = Get-PnPSubWeb -Recurse -IncludeRootWeb
    $ListInventory= @()
    Foreach ($Web in $SubWebs)
    {
        Write-host -f Yellow "Getting List Item count from site:" $Web.URL
        #Connect to Subweb
        Connect-PnPOnline -Url $Web.URL -Credentials $Cred
 
        #Get all lists and libraries of the Web
        $ExcludedLists  = @("Reusable Content","Content and Structure Reports","Form Templates","Images","Pages","Workflow History","Workflow Tasks", "Preservation Hold Library")
        $Lists= Get-PnPList | Where {$_.Hidden -eq $False -and $ExcludedLists -notcontains $_.Title -and $_.ItemCount  -gt $Threshold}
        foreach ($List in $Lists)
        {
         
            $Data = new-object PSObject
            $Data | Add-member NoteProperty -Name "Site URL" -Value $Web.Url
            $Data | Add-member NoteProperty -Name "Site Name" -Value $Web.Title
            $Data | Add-member NoteProperty -Name "List Title" -Value $List.Title
            $Data | Add-member NoteProperty -Name "List URL" -Value $List.RootFolder.ServerRelativeUrl
            $Data | Add-member NoteProperty -Name "Base Type" -Value $List.BaseType
            $Data | Add-member NoteProperty -Name "Item Count" -Value $List.ItemCount
            
            $ListInventory += $Data
        }
    }
  # Write-Host $ListInventory
$OutFile = $($CurrentDirPath + "\Result.csv")
$ListInventory | Export-CSV $OutFile -NoTypeInformation
#$ListInventory | Export-CSV $CSVFile -NoTypeInformation
    Write-host -f Green "List Inventory Exported to Excel Successfully!"
}
Catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}