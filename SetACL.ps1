#An easy and foolproof way to properly set ACLs on created printers is to copy ACLs from a "master" printer resource. 
#Set the desired permissions on a printer, get the printer object, and copy it's permissions to all other printers.
#This can easily be adapted and incorporated into other scripts. 

$Security = Get-Printer "GOLD-MASTER-PRINTER" -full
Get-Printer * | Foreach-Object {Set-Printer $_.name -PermissionSDDL $Security.PermissionSDDL}
