Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore

$form = New-Object System.Windows.Forms.Form -Property @{
    #AutoSize = $true
    AutoSizeMode = 'GrowAndShrink'
    StartPosition = 'CenterScreen'
}

#Add Button to GUIform that will make more buttons.
$newLinkButton = New-Object System.Windows.Forms.Button -Property @{
    Name = "New Link"
    Text = "Add New Link"
    Tag = "New Link"
    Location = "0, 0"
    Size = "125, 30"
    add_Click = {
        #stuff happens here
    }
}


$scriptActions = [ordered]@{}
Import-Csv ./Buttons.txt -Delimiter " " | ForEach-Object {
    $scriptActions.Add($_.ButtonName, $_.Action)
}

[string[]] $keys = $scriptActions.Keys
$tableRow = 0
$tableCol = 0

#Create table layout to add tables of buttons to.
$mainTableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
#$mainTableLayoutPanel.RowCount = 2
$mainTableLayoutPanel.Controls.Add($newLinkButton, 0, 0)

#create dynamic table for buttons
$buttonTableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
#$buttonTableLayoutPanel.RowCount = $keys.Length


echo $keys.Length
echo $scriptActions

#Loop though the db file and make buttons
for ($i = 0; $i -lt $keys.Length; $i++) {

    $key = $keys[$i]

    $b = New-Object System.Windows.Forms.Button -Property @{
        Name = $key.Replace(' ', '')
        Text = $key
        Tag = $key
        #Location = "$x, $y"
        #Size = "125, 30"
        add_Click = {
            Start-Process $scriptActions[$args[0].Tag]
        }
    }

    $buttonTableLayoutPanel.Controls.Add($b, $tableCol, $tableRow)

    $tableRow++

    #Check if there begins to be too many rows and create new column
    if ($tableRow -gt 6){
        $tableCol++
        $tableRow = 0
    }
}
$mainTableLayoutPanel.Controls.Add($buttonTableLayoutPanel, 0, 1)

$form.controls.add($mainTableLayoutPanel)
$form.ShowDialog()
