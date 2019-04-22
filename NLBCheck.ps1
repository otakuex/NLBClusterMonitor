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

$Outputreport += nlbsrvchk -srvname FTLACTRL001 -clusternum 3 -Description "Group A controller"
$Outputreport += nlbsrvchk -srvname FTLAMGMT001 -clusternum 2 -description "Group A management"
$Outputreport += nlbsrvchk -srvname FTLBMGMT001 -clusternum 2 -description "Group B management"
$Outputreport += nlbsrvchk -srvname FTLCFSG101 -clusternum 5 -description "Client Facing Service Gateway"
$Outputreport += nlbsrvchk -srvname FTLCGSG101 -clusternum 5 -description "Client Group Service Gateway"
$Outputreport += nlbsrvchk -srvname FTLHPNR001 -clusternum 2 -description "Delivers High Priority messages to clients."
$Outputreport += nlbsrvchk -srvname FTLMDSFE101 -clusternum 5 -description "Manage/maintain the communication between clients and database"
$Outputreport += nlbsrvchk -srvname FTLMDSING001 -clusternum 2 -description "MDS ingestion."
$Outputreport += nlbsrvchk -srvname FTLMFAPP001 -clusternum 5 -description "Feature application"
$Outputreport += nlbsrvchk -srvname FTLMMGMT001 -clusternum 2 -description "Media management"
$Outputreport += nlbsrvchk -srvname FTLPOSTER001 -clusternum 2 -description "Maintains posters images"
$Outputreport += nlbsrvchk -srvname FTLSFBR001 -clusternum 2 -description "Ingest source data, propagate the Keys from Backend to Branch."
$Outputreport += nlbsrvchk -srvname FTLSFSG101 -clusternum 2 -description "Maintain clients' in sync to the platform."
$Outputreport += nlbsrvchk -srvname FTLSYNC001 -clusternum 2 -description "Does the first contact with the clients and provide the initial SW file."

$Outputreport += "</Table>
</BODY>
</HTML>"

$Outputreport | Out-File C:\Scripts\NLBCheck.htm # Change output file path as desired, but make sure to make the same changes to the 2 references below

# Email the HTML report with custom subject

$count = (get-content C:\Scripts\NLBCheck.htm | select-string -pattern "FF9999").length
$subject = ""
if($count -gt 1) {$subject = "Daily NLB Check - $count CLUSTERS DEGRADED"}
elseif($count -eq 1) {$subject = "Daily NLB Check - 1 CLUSTER DEGRADED"}
else {$subject = "Daily NLB Check - All OK"}

$smtpServer = "smtp1.YOURDOMAIN.COM" #enter your own SMTP server DNS name / IP address here
$smtpFrom = "Not-Reply-Alert@someemail.com"
$smtpTo = "receipentaddress@test.com"

$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.IsBodyHTML = $true
$message.Body = "<head><pre>$style</pre></head>"

$smtp = New-Object Net.Mail.SmtpClient($smtpServer)

$users = "user1@someemail.com","user2@someemail.com","user3@someemail.com","user4@someemail.com" # List of users to email your report to (encapsulate in quotes, separate by comma)
$fromemail = "Not-Reply-Alert@someemail.com"
$server = "smtp1.YOURDOMAIN.COM" #enter your own SMTP server DNS name / IP address here
$a = (Get-Date).Hour
$message.Body += Get-Content C:\Scripts\NLBCheck.htm

send-mailmessage -from $fromemail -to $users -subject "$subject" -BodyAsHTML -body $message.Body -priority High -SmtpServer "$server"
