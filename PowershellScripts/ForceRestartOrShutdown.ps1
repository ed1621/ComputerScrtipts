Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic

(get-process | ? { $_.mainwindowtitle -ne "" -and $_.processname -ne "powershell" } )| stop-process

$wshell = New-Object -ComObject Wscript.Shell

function closeScript
{
    param ([PsObject]$window)
    $window.Close()
}

function pcPowerAction
{
    param ([string]$powerAction)
    if($powerAction -eq "shutdown")
    {
        $wshell.Popup("Shutting Down",3,"pcPowerAction",0);
        Stop-Computer
    }
    if($powerAction -eq "restart")
    {
        $wshell.Popup("Now Restarting",3,"pcPowerAction",0);
        Restart-Computer
    }

}

function GenerateForm
{
    # build form
    $objform = New-Object System.Windows.Forms.Form
    $objForm.Text = "Do you want to shutdown or restart?"
    $objForm.Size = New-Object System.Drawing.Size(380,100)
    $objForm.StartPosition = "CenterScreen"

    # add shutdown button
    $shutdownButton = New-Object System.Windows.Forms.Button
    $shutdownButton.Location = New-Object System.Drawing.Size(50,20)
    $shutdownButton.Size = New-Object System.Drawing.Size(75,23)
    $shutdownButton.Text = "Shutdown"
    $thing = $shutdownButton.Add_Click({pcPowerAction -powerAction "shutdown"})
    $objForm.Controls.Add($shutdownButton)

    # add restart button
    $restartButton = New-Object System.Windows.Forms.Button
    $restartButton.Location = New-Object System.Drawing.Size(140,20)
    $restartButton.Size = New-Object System.Drawing.Size(75,23)
    $restartButton.Text = "Restart"
    $restartButton.Add_Click({pcPowerAction -powerAction "restart"})
    $objForm.Controls.Add($restartButton)

    # add cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Size(230,20)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = "Cancel"
    $cancelButton.Add_Click({closeScript -window $objform})
    $objForm.Controls.Add($cancelButton)

    #show the form
    $objForm.ShowDialog()| Out-Null
}

GenerateForm
