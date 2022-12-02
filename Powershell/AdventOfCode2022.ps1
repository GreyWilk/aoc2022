
param(
    [Parameter(mandatory=$true)] [int] $day
)


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

function start-day2 {
    $day1InputData = @(Get-Content -Path "day_02_input.txt" -Delimiter "`n")
    $totalPointsPart1 = @()
    $totalPointsPart2 = @()

    # A / X / 1 = Rock    -> Loose
    # B / Y / 2 = Paper   -> Draw
    # C / Z / 3 = Sissors -> Win

    $day1InputData | ForEach-Object {
        switch( $PSItem ){
            'A X'         { $totalPointsPart1 += ( 1 + 3 ) }
            'B Y'         { $totalPointsPart1 += ( 2 + 3 ) }
            'C Z'         { $totalPointsPart1 += ( 3 + 3 ) }
            'A Y'         { $totalPointsPart1 += ( 2 + 6 ) }
            'B Z'         { $totalPointsPart1 += ( 3 + 6 ) }
            'C X'         { $totalPointsPart1 += ( 1 + 6 ) }
            'A Z'         { $totalPointsPart1 += ( 3 + 0 ) }
            'B X'         { $totalPointsPart1 += ( 1 + 0 ) }
            'C Y'         { $totalPointsPart1 += ( 2 + 0 ) }
            default       { Write-host "WTF!"; break }
        }
        #break
    }

    $infoTable = [pscustomobject] @{
        A = [pscustomobject]@{
            X = 3 # Loose with Sissors
            Y = 1 # Draw with Rock
            Z = 2 # Win with Paper
        }
        B = [pscustomobject]@{
            X = 1 # Loose with Rock
            Y = 2 # Draw with Paper
            Z = 3 # Win with Sissors
        }
        C = [pscustomobject]@{
            X = 2 # Loose with Paper
            Y = 3 # Draw with Sissors
            Z = 1 # Win with Rock
        }
    }

    $day1InputData | ForEach-Object {
        $matchValue = $PSItem[0]
        $switchValue = $PSItem[2]
        switch( $switchValue ){
            'X'             { $totalPointsPart2 += ( [int]$($infoTable.$matchValue.$switchValue) + 0 ) }
            'Y'             { $totalPointsPart2 += ( [int]$($infoTable.$matchValue.$switchValue) + 3 ) }
            'Z'             { $totalPointsPart2 += ( [int]$($infoTable.$matchValue.$switchValue) + 6 ) }
            default         { Write-host "WTF! [2]"; break }
        }
    }

    Write-Host "Day 2a: $( ($totalPointsPart1 | Measure-Object -Sum).Sum )"
    Write-Host "Day 2b: $( ($totalPointsPart2 | Measure-Object -Sum).Sum )"
}

switch($day){
    1           { start-day1 }
    2           { start-day2 }
    default     { start-day1 }
}