# react-env-config-changer

#This script is used in build pipeline in setting up the variables inside the .env file. 

#This is particulary helpful for building multiple environments (dev, sit, uat, etc)

################## Start of Script ##################


$items = $args[0].split(";").Trim();
#Setting variables
$content = (Get-Content $PSScriptRoot/.env) 
$newValues = New-Object PSObject
$headers = @()
#Getting headers from current content
$content | ForEach-Object{
   $current=$_.split("=")
   $headers += $current[0]
}
#Getting new value for headers
$items | ForEach-Object{
    $current=$_.split("=")    
    $exist = $headers -contains $current[0]
    #$ndx = [array]::IndexOf($items, $current[0])
    if($exist -and $current[0] -ne ""){        
        $newValues | add-member Noteproperty $current[0] $current[1] 
     }
}
#Writing to env
foreach ($x in $newValues | Get-Member) {
    if ($x.MemberType -eq "NoteProperty" -and $x.Name -notlike "__*") {              
        foreach($line in $content){
            $current=$line.split("=")            
            if($current[0] -eq $x.Name){  
                $ndx = [array]::IndexOf($content, $line)         
                $newLine = "$($x.Name)=$($newValues.$($x.Name))"                
                $content[$ndx] = $content[$ndx] -replace $line,$newLine                
            }
        }
    }
}
Set-Content $PSScriptRoot\.env -Value $content


################## End of Script ##################

**How to use**:
1. Save the script above in ps1 format. It should be saved on the same path where the .env file is.
2. On the build pipeline, add a PowerShell task:
![image](https://user-images.githubusercontent.com/85863019/122189605-a4936600-cec3-11eb-9af6-99168ef796d0.png)
3. On the task's settings > **Script path**, enter the location where the ps1 is saved.
4. On the **Arguments** field, you can enter the variables and their respective values that needs to be set. The variables, paired with their values, are semi-colon deliminated.
Arguments format:
**variable**:**value**;**variable**:**value**
![image](https://user-images.githubusercontent.com/85863019/122190128-208dae00-cec4-11eb-988e-ff38d315e9cb.png)


