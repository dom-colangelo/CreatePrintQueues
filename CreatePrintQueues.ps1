Function Get-File($initialDirectory){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "CSV (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

$PrinterList=Import-Csv (Get-File)

foreach ($Printer in $PrinterList) {
    #If a printer IP is defined, create the port and add the printer. For my use case, I do not share these printers.
    if($Printer.PrintIP){ 
        Add-PrinterPort -Name $Printer.PrintIP -PrinterHostAddress $Printer.PrintIP
        Add-Printer -Name $Printer.PrinterName -DriverName $Printer.PrintDriver -PortName $Printer.PortName 
    }
    #If a printer IP is not defined, create the printer with a pre-created port (useful for NUL ports) then share the resource.
    else{
        Add-Printer -Name $Printer.PrinterName -DriverName $Printer.PrintDriver -PortName $Printer.PortName -Shared -ShareName $Printer.PrinterName
    }
}
