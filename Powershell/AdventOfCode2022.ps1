
param(
    [Parameter(mandatory=$false)] [int] $day = 100000000
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
    $day2InputData = @(Get-Content -Path "day_02_input.txt" -Delimiter "`n")
    $totalPointsPart1 = @()
    $totalPointsPart2 = @()

    # A / X / 1 = Rock    -> Loose
    # B / Y / 2 = Paper   -> Draw
    # C / Z / 3 = Sissors -> Win

    $day2InputData | ForEach-Object {
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

    $day2InputData | ForEach-Object {
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

function start-day3_prioCalc {
    param(
        [parameter(mandatory=$true)]$letter
    )
    switch ( $letter ){
        { $PSItem -cmatch "[A-Z]"}       { $isUpperCase = $true }
        { $PSItem -cmatch "[a-z]"}       { $isUpperCase = $false }
        default                          { Write-Host "Bad matching char!"; Break }
    }
    if ( $isUpperCase ) {
        $prioNum = ([int][char]$letter - (64-26))
    } else {
        $prioNum = ([int][char]$letter - 96)
    }
    return $prioNum
}
function start-day3 {
    $day3InputData = @(Get-Content -Path "day_03_input.txt" -Delimiter "`n")
    # START Part 1
    $prioResultSumPart1 = 0
    $prioResultSumPart2 = 0
    $groupCounter = 0
    $day3InputData | ForEach-Object {
        #Check if length is div with 2
        $stringCharCount = $PSItem.Length
        $stringInputWhole = $PSItem
        if( $stringCharCount.ToString().ToCharArray()[-1] -match "1|3|5|7|9" ) { 
            write-host "String is uneaven lenght ($($stringCharCount[-1]))"
            Break
        }
        $spitStringCharArrayPart1 = ($stringInputWhole.Substring(0,($stringCharCount/2))).ToCharArray()
        $spitStringCharArrayPart2 = ($stringInputWhole.Substring($stringCharCount - ($stringCharCount/2))).ToCharArray()

        $matchingChar = $null
        $matchingChar = $spitStringCharArrayPart1 | ForEach-Object {
            #Write-Host ($spitStringCharArrayPart2 -cmatch $PSItem) 
            return ($spitStringCharArrayPart2 -cmatch $PSItem) 
        }
        $matchingChar = $matchingChar | Select-Object -First 1
        $prioPart1 = start-day3_prioCalc -letter $matchingChar

        $prioResultSumPart1 = $prioResultSumPart1 + $prioPart1
        
    }
    # END Part 1
    # START Part 2
    $prioResultSumPart2 = 0
    $groupCounter = 0
    1..(($day3InputData.Length)/3) | ForEach-Object {
        $badgeMatchingChar = $day3InputData[$groupCounter].ToString().ToCharArray() | ForEach-Object {
            $currentChar = $null
            $currentChar = $PSItem
            if( ($day3InputData[$groupCounter+1] -cmatch $currentChar) -and ($day3InputData[$groupCounter+2] -cmatch $currentChar) ){
                return $currentChar
            } else { }
        }
        $prioPart2 = start-day3_prioCalc -letter ($badgeMatchingChar | Select-Object -First 1)
        $prioResultSumPart2 = $prioResultSumPart2 + $prioPart2
        $groupCounter = $groupCounter+3
    }
    # END Part 2
    Write-Host "Day 3a: $prioResultSumPart1"
    Write-Host "Day 3b: $prioResultSumPart2"
}

function start-day4 {
    $subsets = $overlaps = 0
    $day4InputData = @(Get-Content -Path "day_04_input.txt" -Delimiter "`n")
    $day4InputData | ForEach-Object {

        $p1a,$p1b,$p2a,$p2b = $_.Split([char[]]('-',','))

        $assignmentsPart1 = [Collections.Generic.HashSet[int]]::new([int[]]($p1a..$p1b))
        $assignmentsPart2 = [Collections.Generic.HashSet[int]]::new([int[]]($p2a..$p2b))

        if ($assignmentsPart1.IsSubsetOf($assignmentsPart2) -or $assignmentsPart2.IsSubsetOf($assignmentsPart1)) {
            $subsets++
        }

        if ($assignmentsPart1.Overlaps($assignmentsPart2) -or $assignmentsPart2.Overlaps($assignmentsPart1)) {
            $overlaps++
        }
    }
    Write-Host "Day 4a: $subsets"
    Write-Host "Day 5b: $overlaps"
}

switch($day){
    1           { start-day1 }
    2           { start-day2 }
    3           { start-day3 }
    4           { start-day4 }
    default     { start-day1; start-day2; start-day3 }
}