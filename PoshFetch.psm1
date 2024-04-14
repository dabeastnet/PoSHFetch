<#
.SYNOPSIS
This script displays key system information within a customizable styled layout.

.DESCRIPTION
The script fetches and displays information about the operating system, CPU, RAM, and other system details
in a visually structured format using box-style layouts. It provides options for various box styles and color schemes.

.PARAMETER Logo
The logo to display, which should be passed as a JSON object defining the logo text and its color properties.

.PARAMETER Info
The system information to display, formatted as a JSON object that includes text and its associated foreground and background colors.

.PARAMETER Box
The box style to use for displaying the information, defined as a PowerShell custom object with properties for each part of the box's border.

.EXAMPLE
New-Info -Logo $WaveLogoColored -Info $Info -Box $RoundedBox
This command displays the system information using a wave logo and rounded box styling.

.NOTES
You can modify the script to include more box styles, logos, or to fetch different system information as needed.
Version: 1.0
#>

# Define various box styles for displaying information



# Get system information
$OSVersion = (Get-CimInstance Win32_OperatingSystem).Version
$OSFriendlyName = (Get-WmiObject Win32_OperatingSystem).Caption
$OsBuildVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
$Architecture = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
$HostName = (Get-CimInstance Win32_ComputerSystem).Name
$CurrentUser = ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name).Replace("\","\\")
$UpTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$Now = Get-Date
$UpTimeSpan = $Now - $UpTime
$FormattedUpTime = "{0} days, {1} hours, {2} minutes" -f $UpTimeSpan.Days, $UpTimeSpan.Hours, $UpTimeSpan.Minutes

# Get total physical memory and available memory
$TotalMemory = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
$AvailableMemory = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory * 1024 # Convert to bytes
$UsedMemory = $TotalMemory - $AvailableMemory
$MemoryUsagePercent = ($UsedMemory / $TotalMemory) * 100
$RamUsageString = "$(($UsedMemory / 1GB).ToString("N2")) GB ($($MemoryUsagePercent.ToString("N2"))%)"
$TotalRamString = "$("{0:N2}" -f ($TotalMemory /1GB).ToString("N2")) GB"

# Calculate CPU usage over a 1-second interval
$CpuUsagePercent = (Get-Counter -Counter "\Processor(_Total)\% Processor Time").CounterSamples.CookedValue
$CPUPercentString = $("{0:N2}" -f $CpuUsagePercent)


# Define system information as a JSON object
#Color ref:https://learn.microsoft.com/en-us/dotnet/api/system.consolecolor?view=net-8.0
$Info  = @"
{
    "text":[["Operating System: ","9","0"], ["$OSFriendlyName","7","0"], ["`n","7","0"],
            ["OS Build: ","9","0"], ["$OSVersion - $OsBuildVersion","7","0"], ["`n","7","0"],
            ["Architecture: ","9","0"], ["$Architecture","7","0"], ["`n","7","0"],
            ["Hostname: ","9","0"], ["$HostName","7","0"], ["`n","7","0"],
            ["Current User: ","9","0"], ["$CurrentUser","7","0"], ["`n","7","0"],
            ["System Uptime: ","9","0"], ["$FormattedUpTime","7","0"], ["`n","7","0"],
            ["CPU Usage: ","9","0"], ["$CPUPercentString %","7","0"], ["`n","7","0"],
            ["RAM Usage: ","9","0"], ["$RamUsageString","7","0"], ["`n","7","0"],
            ["Total RAM: ","9","0"], ["$TotalRamString","7","0"], ["`n","7","0"]]
}
"@



$WaveLogoColored = @"
{
    "text": [
        ["         ,.=:^!^!t6Z6z.,                  ", "4", "0"], ["`n","7","0"],
        ["        :tt:::tt666EE6                    ", "4", "0"], ["`n","7","0"],
        ["        Et:::ztt66EEE ", "4", "0"], [" @Ee.,      ..,     ", "2", "0"], ["`n","7","0"],
        ["       ;tt:::tt666EE7", "4", "0"], [" ;EEEEEEttttt66#     ", "2", "0"], ["`n","7","0"],
        ["      :Et:::zt666EEQ.", "4", "0"], [" SEEEEEttttt66QL     ", "2", "0"], ["`n","7","0"],
        ["      it::::tt666EEF", "4", "0"], [" @EEEEEEttttt66F      ", "2", "0"], ["`n","7","0"],
        ["     ;6=*^``````'*4EEV", "4", "0"], [" :EEEEEEttttt66@.      ", "2", "0"], ["`n","7","0"],
        ["     ,.=::::it=., ", "3", "0"], ["`'", "4", "0"], [" @EEEEEEtttz66QF       ", "2", "0"], ["`n","7","0"],
        ["    ;::::::::zt66) ", "3", "0"], ["  '4EEEtttji6P*        ", "2", "0"], ["`n","7","0"],
        ["   :t::::::::tt66.", "3", "0"], [":Z6z.. ", "6", "0"], [" ``", "2", "0"], [" ,..g.        ", "6", "0"], ["`n","7","0"],
        ["   i::::::::zt66F", "3", "0"], [" AEEEtttt::::ztF         ", "6", "0"], ["`n","7","0"],
        ["  ;:::::::::t66V", "3", "0"], [" ;EEEttttt::::t6          ", "6", "0"], ["`n","7","0"],
        ["  E::::::::zt66L", "3", "0"], [" @EEEtttt::::z6F          ", "6", "0"], ["`n","7","0"],
        [" {6=*^``````'*4E6)", "3", "0"], [" ;EEEtttt:::::tZ``          ", "6", "0"], ["`n","7","0"],
        ["             ``", "3", "0"], [" :EEEEtttt::::z7            ", "6", "0"], ["`n","7","0"],
        ["                 'VEzjt:;;z>*``           ", "6", "0"], ["`n","7","0"],
        ["                      ``                  ", "6", "0"], ["`n","7","0"]
    ]
}

"@

$ModernLogoColored = @"
{
    "text": [
        ["                            .oodMMMM", "2", "0"], ["`n","7","0"],
        ["                    .oodMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        ["       ..oodMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        [" oodMMMMMMMMMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "4", "0"], ["   MMMMMMMMMMMMMMMMMMM", "2", "0"], ["`n","7","0"],
        ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "6", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "6", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "6", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "6", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "6", "0"], ["`n","7","0"],
        [" ``^^^^^^MMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "6", "0"], ["`n","7","0"],
        ["       ````````^^^^", "3", "0"], ["   ^^MMMMMMMMMMMMMMMMM", "6", "0"], ["`n","7","0"],
        ["                       ````````^^^^^^MMMM", "6", "0"], ["`n","7","0"]
    ]
}
"@

$ModernLogoBlue = @"
{
    "text": [
        ["                            .oodMMMM", "3", "0"], ["`n","7","0"],
        ["                    .oodMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        ["       ..oodMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" oodMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" MMMMMMMMMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        [" ``^^^^^^MMMMMMM", "3", "0"], ["   MMMMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        ["       ````````^^^^", "3", "0"], ["   ^^MMMMMMMMMMMMMMMMM", "3", "0"], ["`n","7","0"],
        ["                       ````````^^^^^^MMMM", "3", "0"], ["`n","7","0"]
    ]
}
"@

$Box = [PSCustomObject]@{
    TopLeft = "┌"
    TopRight = "┐"
    BottomLeft = "└"
    BottomRight = "┘"
    Horizontal = "─"
    Vertical = "│"
}

$RoundedBox = [PSCustomObject]@{
    TopLeft = "╭"
    TopRight = "╮"
    BottomLeft = "╰"
    BottomRight = "╯"
    Horizontal = "─"
    Vertical = "│"
}

$DoubleBox = [PSCustomObject]@{
    TopLeft = "╔"
    TopRight = "╗"
    BottomLeft = "╚"
    BottomRight = "╝"
    Horizontal = "═"
    Vertical = "║"
}

$BoldBox = [PSCustomObject]@{
    TopLeft = "█"
    TopRight = "███"
    BottomLeft = "█"
    BottomRight = "███"
    Horizontal = "█"
    Vertical = "██"
}

$NoBox = [PSCustomObject]@{
    TopLeft = " "
    TopRight = " "
    BottomLeft = " "
    BottomRight = " "
    Horizontal = " "
    Vertical = " "
}

# Function to create and display system information with selected logo and box style
function Get-Info {
    param (
        [object]$Logo = $WaveLogoColored,
        [object]$Info = $Info,
        [object]$Box = $RoundedBox
    )
    $ConvertedLogo = ($Logo | ConvertFrom-Json).text
    $ConvertedInfo = ($Info | ConvertFrom-Json).text
    $LargestObj = ""
    $global:CurrentInfoIndex = 0
    $FirstLine = $true
    function Get-StringLength {
        param (
            $String
        )
        #This function calculates the maximum string length of the JSON object, so we can add the apropriate amount of spaces and allignment
        $InputTextObject = ""
        $LineLength = $null
        #Rebuild text to multiline string to calculate length
        for ($i = 0; $i -lt ($String.Count); $i++) {
            $InputTextObject += $String[$i][0]
        }

        #Get longest stringlenth
        foreach ($Line in $InputTextObject.split("`n")) {
            if ($Line.length -gt $LineLength) {
                $LineLength = $Line.length
            }
        }
        return $LineLength
    }

    #Get maximum string length
    $LogoLineLength = Get-StringLength $ConvertedLogo
    $InfoLineLenth = Get-StringLength $ConvertedInfo


    #Determine longest object (more testing/handling might be needed if the info object has more lines then the logo)
    if ($ConvertedLogo.Count -gt $ConvertedInfo.Count) {
        $LargestObj = $ConvertedLogo
    }
    else {
        $LargestObj = $ConvertedInfo
    }


    #Logo for-loop
    for ($i = 0; $i -lt $LargestObj.Count; $i++) {
        if ($null -eq ($ConvertedLogo[$i][0]) -or ($ConvertedLogo[$i][0] -eq "`n") -or ($ConvertedLogo[$i][0] -eq "")) {
            #Calculate the spaces it should add to the line
            $SpacesToAdd = $LogoLineLength - $CurrentLogoLineLength
            $Whitespace = " "*($SpacesToAdd+20)
            Write-Host $Whitespace -NoNewline
            $CurrentLogoLineLength = 0
            if ($FirstLine) {
                #Write upper part of box
                $Top =  "$($Box.TopLeft)" + $($Box.Horizontal)*($InfoLineLenth+2) + $($Box.TopRight)
                Write-Host $Top
                $FirstLine = $false
            }
            else {
                if ($global:CurrentInfoIndex -gt $ConvertedInfo.Count) {
                    #Write new line whenever we already finished drawing the box
                    Write-Host ""
                }
                if ($global:CurrentInfoIndex -eq $ConvertedInfo.Count) {
                    #Write bottom part of the box, use $global:CurrentInfoIndex
                    $Bottom =  "$($Box.BottomLeft)" + $($Box.Horizontal)*($InfoLineLenth+2) + $($Box.BottomRight)
                    Write-Host $Bottom
                    $global:CurrentInfoIndex++
                }
                $CurrentInfoLineLength = 0
                #Info for-loop
                for ($SkipBool = $true; ($global:CurrentInfoIndex -lt $ConvertedInfo.Count) -and $SkipBool; $global:CurrentInfoIndex++) {
                    if ($CurrentInfoLineLength -eq 0) {
                        #Left part of the box
                        Write-Host "$($Box.Vertical) " -NoNewline
                    }
                    if ($ConvertedInfo[$global:CurrentInfoIndex][0] -eq "`n") {
                        #Box spaces and end of line
                        $SpacesToAdd = $InfoLineLenth - $CurrentInfoLineLength
                        $Whitespace = " "*($SpacesToAdd+1)
                        Write-Host $Whitespace -NoNewline
                        Write-Host "$($Box.Vertical) " -NoNewline
                        Write-Host $ConvertedInfo[$global:CurrentInfoIndex][0] -ForegroundColor $ConvertedInfo[$global:CurrentInfoIndex][1] -BackgroundColor $ConvertedInfo[$global:CurrentInfoIndex][2] -NoNewline
                        $CurrentInfoLineLength = 0
                        $SkipBool = $false
                    }
                    else {
                        #Write info
                        Write-Host $ConvertedInfo[$global:CurrentInfoIndex][0] -ForegroundColor $ConvertedInfo[$global:CurrentInfoIndex][1] -BackgroundColor $ConvertedInfo[$global:CurrentInfoIndex][2] -NoNewline
                        $CurrentInfoLineLength += $ConvertedInfo[$global:CurrentInfoIndex][0].length
                    }
                }
            }
           
        }
        else {
            #write logo
            Write-Host $ConvertedLogo[$i][0] -ForegroundColor $ConvertedLogo[$i][1] -BackgroundColor $ConvertedLogo[$i][2] -NoNewline
            $CurrentLogoLineLength += $ConvertedLogo[$i][0].Length
        }        

        
    }
}




## Logo options
# New-Info -Logo $WaveLogoColored -Info $Info -Box $RoundedBox
# New-Info -Logo $ModernLogoColored -Info $Info -Box $RoundedBox
# New-Info -Logo $ModernLogoBlue -Info $Info -Box $RoundedBox

## Box options
# New-Info -Logo $WaveLogoColored -Info $Info -Box $Box
# New-Info -Logo $WaveLogoColored -Info $Info -Box $RoundedBox
# New-Info -Logo $WaveLogoColored -Info $Info -Box $DoubleBox
# New-Info -Logo $WaveLogoColored -Info $Info -Box $BoldBox
# New-Info -Logo $WaveLogoColored -Info $Info -Box $NoBox


# End of Script

Export-ModuleMember -Function Get-Info