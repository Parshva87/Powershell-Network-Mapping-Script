
    




function main{

param 
( 
    $msg = "New Device Connected to the Network", 
    $title = "New Device Found", 
    $icon = "Warning", 
    $timeout=1 
) 

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null 
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null

    #Find Gateway
    Write-Output "GateWay"
    #gate_way 
     Write-Output "Your Network Default Gateway"
$Gateway = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DefaultIPGateway
#Write-Output $Gateway


$testv = ($Gateway.Split([Environment]::NewLine) | Select -First 1)
Write-Output $testv

$wshell = New-Object -ComObject Wscript.Shell
#$popupt = $wshell.Popup("Test",0,"Scanning Report",4+32)




$testip = $testv.Substring(0, $testv.IndexOf('.') + 1 + $testv.Substring($testv.IndexOf('.') + 1).IndexOf('.')+ $testv.Substring($testv.IndexOf('.') + 1).IndexOf('.')+1 )
Write-Output "Test IP is"
Write-Output $testip

    #List All Connected device to the network
    Write-Output "Scanning Connected Device"
    connected-device

    #Post Scanning
    Write-Output "Port Scan"
    port_scan


    Write-Output " test"
  #  gateway_scan


    #Scan for new connected device
    new_device


   # Write-Output "Testing Balloon"
   # bpopup

   #Scan Machine Open Port Initial Scan
   scan_device_port

   #Scan Machine Open Port After Some Time
   scan_device_port_AS

    #Delete Created file
    Write-Output "Delete temp files"
    del_fun

}







function gate_way{


   
#return $testip
}



function connected-device{
 #Write-Output "Finding Available IP on Local Network"
 Write-Output " Connected Device"
 ip_scan | Out-File C:\NewFolder\IP_List.txt -Append

}



#List All Connected device to the network
function ip_scan{
#Write-Output "ip-scan"
#Write-Output "Finding Available IP on Local Network"
1..20 |
    %{
      $IP= "$testip.$_" 
      if(Test-Connection $IP -count 1 -q){
            Write-Output $IP
          # Write-Output $IP | Out-File  C:\NewFolder\IP_List.txt -Append
       #     Write-Output $IP
        }
 }
}



#Scan for new connected devices on network
function new_device{
$fileA = "C:\NewFolder\IP_List.txt"
Write-Output "Finding Available IP on Local Network"
ip_scan | Out-File C:\NewFolder\New_IP_List.txt
$fileB = "C:NewFolder\New_IP_List.txt"
#Scan Network for connected device



if($fileC = ((Compare-Object -ReferenceObject $(Get-Content $fileA) -DifferenceObject $(Get-Content $fileB))| Format-Table InputObject))

 {"New Device Connected`n"
  Write-Output $fileC | Out-File C:\NewFolder\testa.txt
  $fileD = "C:\NewFolder\testa.txt"
  $v = 3..20 | %{(Get-Content $fileD)[$_]}
  Write-Output $v | Out-File "C:\NewFolder\testb.txt"

    
$Balloon = new-object System.Windows.Forms.NotifyIcon  
$Balloon.Icon = [System.Drawing.SystemIcons]::Information 
$Balloon.Visible = $true; 
$Balloon.ShowBalloonTip($timeout, $title, $msg, $icon); 

Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue 
Register-ObjectEvent $Balloon BalloonTipClicked -sourceIdentifier click_event -Action { 
$response = [System.Windows.MessageBox]::Show('Do You Want to scan this $v device', 'New Device Connected','YesNoCancel','Error' )
if($response="yes"){
 nmap $v -p- -sv | Out-File "C:\NewFolder\New_Device_Scanning_Details.txt"
}

} | Out-Null 

Wait-Event -timeout 15 -sourceIdentifier click_event > $null 
Remove-Event click_event -ea SilentlyContinue 
Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue 
$Balloon.Dispose()

 }

Else {"No New Device Connected"}


}

function port_scan{
#Write-Output "Scanning Port..."
#2013..2016 | % {echo ((new-object Net.Sockets.TcpClient).Connect("127.0.0.1",$_)) "Port $_ is open!"} 2>$null


   Write-Output "Post Scanning"
   foreach($line in Get-Content C:\NewFolder\IP_List.txt) {
     if($line -match $regex){
        #Write-Output $line
    
      % {write-host "------"; write-host "$line"; 22,53,80,445 | % {echo ((new-object Net.Sockets.TcpClient).Connect("$line",$_)) "Port $_ is open!"} 2>$null | Out-File "C:\NewFolder\Port_Scan_Details.txt"}

      }
   }

}



#Scan all the local Network for connected Device and Open ports
function gateway_scan{
    Write-Output $testv
    nmap $testv/24

}



function del_fun{

    Remove-Item   C:\NewFolder\IP_List.txt
    Write-Output "All items deleted`n"

}





function scan_device_port{
nmap localhost -p- | Out-File C:\NewFolder\Start_Time_PS.txt
}



function scan_device_port_AS{


nmap localhost -p- | Out-File  C:\NewFolder\psc.txt
$filet = "C:\NewFolder\psc.txt"
$file1 = "C:\NewFolder\psc1.txt"
$tv = 5..20 | %{(Get-Content $filet)[$_]}
#Write-Output $tv

if($fileC = ((Compare-Object -ReferenceObject $(Get-Content $filet) -DifferenceObject $(Get-Content $file1))| Format-Table InputObject)){
Write-Output $fileC | Out-File "C:\NewFolder\psc1-1.txt"
$filepsc = "C:\NewFolder\psc1-1.txt"
#Write-Output $filepsc
 



 $linepsc = Get-Content $filepsc
 foreach ($line in $linepsc)
{
    ($line.Split("/"))[0] | Out-File "C:\NewFolder\fpsc1-1.txt" -Append
}
$filefs = "C:\NewFolder\fpsc1-1.txt"
$filefsv = 3..20 | %{(Get-Content $filefs)[$_]}
Write-Output $filefsv




$Balloon = new-object System.Windows.Forms.NotifyIcon  
$Balloon.Icon = [System.Drawing.SystemIcons]::Information 
$Balloon.Visible = $true; 
$Balloon.ShowBalloonTip($timeout, $title, $msg, $icon); 

Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue 
Register-ObjectEvent $Balloon BalloonTipClicked -sourceIdentifier click_event -Action { 
$response = [System.Windows.MessageBox]::Show("Do You Want to scan this $filefsv port", 'New Device Connected','YesNoCancel','Error' )
if($response="yes"){
 $a= $filefsv[0]
 $b = $filefsv[1]
 nmap localhost "-p$a,$b" | Out-File "C:\NewFolder\New_Device_Scanning_Details.txt"
}

} | Out-Null 

Wait-Event -Timeout 15 -sourceIdentifier click_event > $null 
Remove-Event click_event -ea SilentlyContinue 
Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue 
$Balloon.Dispose()



Write-Output "Item Delete"
Remove-Item $filefs
}
Else{"0 New Open Ports Founds"}





}








function bpopup{


$Balloon = new-object System.Windows.Forms.NotifyIcon  
$Balloon.Icon = [System.Drawing.SystemIcons]::Information 
$Balloon.Visible = $true; 
$Balloon.ShowBalloonTip($timeout, $title, $msg, $icon); 

Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue 
Register-ObjectEvent $Balloon BalloonTipClicked -sourceIdentifier click_event -Action { 
$response = [System.Windows.MessageBox]::Show('Do You Want to scan this devic', 'New Device Connected','YesNoCancel','Error' )

} | Out-Null 

Wait-Event -timeout 15 -sourceIdentifier click_event > $null 
Remove-Event click_event -ea SilentlyContinue 
Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue 
$Balloon.Dispose()


}



#Entry point
main

#Invoke-Command -ComputerName PARSHVA -Scriptblock $script