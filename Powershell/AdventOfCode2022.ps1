
param(
    [Parameter(mandatory=$true)] [int] $day
)

switch($day){
    1           { start-day1 }
    default     { start-day1 }
}


function start-day1 {
    $day1InputData = @(Get-Content -Path "day_01_input.txt" -Delimiter "`n`n")
    
    [array]$addedUpData = foreach($item in $day1InputData){
        $convertedstringitem = @()
        
        foreach( $stringitem in $( $item-split [System.Environment]::NewLine) ){
            $convertedstringitem += $stringitem.ToInt32($null)
        }
        ($convertedstringitem | Measure-Object -Sum).Sum
    }
    
    $day1b = $(( $addedUpData | Sort-Object -Descending )[0..2])
    
    Write-Host "Day 1a: $(( $addedUpData | Sort-Object -Descending )[0])"
    Write-Host "Day 1b: $(( $day1b | Measure-Object -Sum ).Sum)"
}
