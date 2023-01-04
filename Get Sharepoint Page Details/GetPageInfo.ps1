#$siteURL = Read-Host "https://tretiya.sharepoint.com"   
 Connect-PnPOnline -Url "https://test.sharepoint.com/SitePages/Home-Page.aspx"  
 $page = Get-PnPClientSidePage -Identity 'Home' #Get the page on which you are going to perform add and remove web parts.  
 $webParts = $page.Controls   
 #if there are more than one webparts   
 foreach($webpart in $webparts) {   
   Write-Host "WebPart Id "   
   $webpart.InstanceId   
   Write-Host "Title "   
   $webpart.Title   
 }  