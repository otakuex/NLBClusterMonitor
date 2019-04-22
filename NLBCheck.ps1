# Check NLB clusters and compare node counts to expected values and outpot as HTML report

function nlbsrvchk ($srvname,$clusternum,$description) {
  $nlbnode = Get-NlbClusterNode -Hostname $srvname
  $numhost = 0
  foreach ($i in $nlbnode) {
    if ($i.State -like "*Converged*") { $numhost += 1 }
  }
  $diffnum = $clusternum - $numhost
    if ($diffnum -ne 0){
      $Report += "<TR bgcolor=#FF9999>
"
      }
    else {
      $Report += "    <TR bgcolor=#C8FFCC>
"
    }
    $Report += "    <TD>$srvname</TD>
        <TD align=center>$clusternum</TD>
        <TD align=center>$numhost</TD>
        <TD align=center>$diffnum</TD>
        <TD>$description</TD>"

    $Report += "</TR>"
return $Report
}

$Outputreport = '<HTML>
<TITLE>Daily NLB Check</TITLE>
<BODY background-color:peachpuff>
<font color =""#99000"" face=""Microsoft Tai le"">
<H2> NLB Check Report </H2></font>
<Table border=1 cellpadding=0 cellspacing=0>
    <TR bgcolor=gray align=center>
        <TH><B>Server Name</B></TD>
        <TH><B>Expected Nodes</B></TD>
        <TH><B>Converged Nodes</B></TD>
        <TH><B>NOT Converged</B></TD>
        <TH><B>Description of Cluster Role</B></TD>
    </TR>
'

$Outputreport += nlbsrvchk -srvname HWCFTLACTRL001 -clusternum 3 -Description "Talks to ALL AServers that handle and deliver the content."
$Outputreport += nlbsrvchk -srvname HWCFTLAMGMT001 -clusternum 2 -description "Manages / creates ALL Backend services (Channels)"
$Outputreport += nlbsrvchk -srvname HWCFTLBMGMT001 -clusternum 2 -description "Manages ALL branch level machines (Ch MAPs, VOD content, Accts, etc…)"
$Outputreport += nlbsrvchk -srvname HWCFTLCFSG101 -clusternum 5 -description "Collects data from STBs"
$Outputreport += nlbsrvchk -srvname HWCFTLCGSG101 -clusternum 5 -description "Delivers client SW and get the STB’s connected to the platform"
$Outputreport += nlbsrvchk -srvname HWCFTLHPNR001 -clusternum 2 -description "Delivers High Priority messages to the STB’s."
$Outputreport += nlbsrvchk -srvname HWCFTLMDSFE101 -clusternum 5 -description "Manage/maintain the communication between STB and Storefront"
$Outputreport += nlbsrvchk -srvname HWCFTLMDSING001 -clusternum 2 -description "Ingest EPG, Asset metadata information."
$Outputreport += nlbsrvchk -srvname HWCFTLMFAPP001 -clusternum 5 -description "Storefront"
$Outputreport += nlbsrvchk -srvname HWCFTLMMGMT001 -clusternum 2 -description "Contracts for Assets on our storefront"
$Outputreport += nlbsrvchk -srvname HWCFTLPOSTER001 -clusternum 2 -description "Maintains posters updated in our lineup over GUIDE"
$Outputreport += nlbsrvchk -srvname HWCFTLSFBR001 -clusternum 2 -description "Ingest EPG, propagate the Keys from Backend to Branch."
$Outputreport += nlbsrvchk -srvname HWCFTLSFSG101 -clusternum 2 -description "Maintain DVR’s in sync to the platform."
$Outputreport += nlbsrvchk -srvname HWCFTLSYNC001 -clusternum 2 -description "Does the first contact with the STB and provide the initial SW file."

$Outputreport += "</Table>
</BODY>
</HTML>"

$Outputreport | Out-File C:\Scripts\NLBCheck.htm

# Email the HTML report with custom subject

$count = (get-content C:\Scripts\NLBCheck.htm | select-string -pattern "FF9999").length
$subject = ""
if($count -gt 1) {$subject = "Daily NLB Check - $count CLUSTERS DEGRADED"}
elseif($count -eq 1) {$subject = "Daily NLB Check - 1 CLUSTER DEGRADED"}
else {$subject = "Daily NLB Check - All OK"}

$smtpServer = "smtp1.HWC.IPTV.COM"
$smtpFrom = "not-reply-MediaroomAlert@hotwirecommunication.com"
$smtpTo = "receipentaddress@test.com"

$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.IsBodyHTML = $true
$message.Body = "<head><pre>$style</pre></head>"

$smtp = New-Object Net.Mail.SmtpClient($smtpServer)

$users = "emanuele.jones@hotwiremail.com","jrodriguez@hotwiremail.com","flopez@hotwiremail.com","rob.reidy@hotwiremail.com","amit.eshet@hotwiremail.com","christopher.peraza@hotwirecommunication.com","kelly.webb@hotwirecommunication.com" # List of users to email your report to (separate by comma)
$fromemail = "not-reply-MediaroomAlert@hotwirecommunication.com"
$server = "smtp1.HWC.IPTV.COM" #enter your own SMTP server DNS name / IP address here
$a = (Get-Date).Hour
$message.Body += Get-Content C:\Scripts\NLBCheck.htm

send-mailmessage -from $fromemail -to $users -subject "$subject" -BodyAsHTML -body $message.Body -priority High -SmtpServer "$server"