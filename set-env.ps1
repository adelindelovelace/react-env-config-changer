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