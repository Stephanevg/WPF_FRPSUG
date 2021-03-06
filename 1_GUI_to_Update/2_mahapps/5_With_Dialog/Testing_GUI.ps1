[System.Reflection.Assembly]::LoadFrom('Assembly\MahApps.Metro.dll')      
[System.Reflection.Assembly]::LoadFrom('Assembly\System.Windows.Interactivity.dll') 
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null



function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("Testing_GUI.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

$Global:Current_Folder =(get-location).path 


########################################################################################################################################################################################################	
#*******************************************************************************************************************************************************************************************************
# 																		BUTTONS AND LABELS INITIALIZATION 
#*******************************************************************************************************************************************************************************************************
########################################################################################################################################################################################################

# ListBox
$DataGrid_XML = $Form.findname("DataGrid_XML")
$Choose_DS = $Form.findname("Choose_DS") 

$Browse = $Form.findname("Browse") 


$Reboot_Radio = $Form.findname("Reboot_Radio") 
$Hide_radio = $Form.findname("Hide_radio") 

$Appli_Enable = $Form.findname("Appli_Enable") 
$Appli_Reboot = $Form.findname("Appli_Reboot") 
$Appli_Hide = $Form.findname("Appli_Hide") 

$TextBox_Browse = $Form.findname("TextBox_Browse") 

$object = New-Object -comObject Shell.Application  

$Open_Settings = $Form.findname("Open_Settings") 
$FlyOutContent = $Form.findname("FlyOutContent") 



$toto = $Form.FindName("btn")


$toto.Add_Click({
	# Simple Dialog	
	[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Hello :-)", "Oh Yeahhhh")		

	# Dialog de validation	
	# $okAndCancel = [MahApps.Metro.Controls.Dialogs.MessageDialogStyle]::AffirmativeAndNegative
	# $result = [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalMessageExternal($Form,"hello","On continue ?",$okAndCancel)
	# If($result -eq "Affirmative")
	# {
	# [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Hello :-)", "Yes")			
	# }
	# Else
	# {
	# [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Hello :-)", "Cancel")			
	# }
		
    # Dialog de login
    # $Login = [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalLoginExternal($Form,"Login:","Type your credentials :)") 
    # $User_Login = $Login.Username
    # $User_PWD  = $Login.Password	
	# [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Credentials :-)", "User is: $User_Login Password is: $User_PWD")		
})




$Open_Settings.Add_Click({
    $FlyOutContent.IsOpen = $true    
})





# Action sur un button


# Cocher décocher un CheckBox
$Appli_Reboot.IsChecked = $True
$Appli_Hide.IsChecked = $True
$Appli_Enable.IsChecked = $False

# Cocher décocher un RadioButton
$Reboot_Radio.IsChecked = $False
$Hide_radio.IsChecked = $True


Function Populate_W10_Deployment_ListBox
	{		
		$Share_XML = "DeploymentShare_Infos.xml"										
		$Global:my_share_xml = [xml] (Get-Content $Share_XML)	
		foreach ($data in $my_share_xml.selectNodes("DeploymentShares/DeploymentShare"))				
			{
				$Choose_DS.Items.Add($data.label)	| out-null	
			}					
	}				
Populate_W10_Deployment_ListBox	


Function Populate_Datagrid_XML # Function to list your applications in the datagrid
	{			
		$Global:List_XML_Content = ""
		$Input_XML = ""		
		
		$Global:List_XML_Content = "DeploymentShare_Infos.xml"						
		$Input_XML = [xml] (Get-Content $List_XML_Content)		
		foreach ($data in $Input_XML.selectNodes("DeploymentShares/DeploymentShare"))		
			{
				$XML_values = New-Object PSObject
				$XML_values = $XML_values | Add-Member NoteProperty Label $data.Label –passthru				
				$XML_values = $XML_values | Add-Member NoteProperty Path $data.Path –passthru
				$XML_values = $XML_values | Add-Member NoteProperty Version $data.Version –passthru
				$DataGrid_XML.Items.Add($XML_values) > $null
			}		
	}		
Populate_Datagrid_XML

	
	

$Form.ShowDialog() | Out-Null

