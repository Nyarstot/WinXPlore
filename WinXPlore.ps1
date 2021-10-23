# WinXPlore 1.0

################### VARIABLES ###################

$global:currentDirectory = $NULL

################### FUNCTIONS ###################

function WinXPlore_PrintApplicationHeader {
    Write-Host "+-------------------------------------------------------------------+"
    Write-Host "| __      __.__       ____  _____________.__                        |"
    Write-Host "|/  \    /  \__| ____ \   \/  /\______   \  |   ___________   ____  |"
    Write-Host "|\   \/\/   /  |/    \ \     /  |     ___/  |  /  _ \_  __ \_/ __ \ |"
    Write-Host "| \        /|  |   |  \/     \  |    |   |  |_(  <_> )  | \/\  ___/ |"
    Write-Host "|  \__/\  / |__|___|  /___/\  \ |____|   |____/\____/|__|    \___  >|"
    Write-Host "|       \/          \/      \_/                                  \/ |"
    Write-Host "+-------------------------------------------------------------------+"
    Write-Host "|                                                                   |"
    Write-Host "|                    Developed by Nikita Kozlov                     |"
    Write-Host "|                   github.com/Nyarstot/WinXPlore                   |"
    Write-Host "|                                                                   |"
    Write-Host "+-------------------------------------------------------------------+"
    Write-Host ""
}

function WinXPlore_CheckPath {
    param (
        $Path
    )
    if (Test-path -Path $Path) {
        return $true
    } else {
        return $false
    }
}

function WinXPlore_GlobalSlashChecker {
    if ($global:currentDirectory.endswith("\")) {

    } else {
        $global:currentDirectory = [string]::Concat($global:currentDirectory, "\")
    }
}

function WinXPlore_TableOfDirectoryContent {
    Get-ChildItem -Path $currentDirectory |
    Select-Object -Property BaseName, Extension, Length |
    Format-Table -AutoSize -Wrap
}

function WinXPlore_ShowDependencies {
    param (
        $Path
    )
    $tmpPath = [string]::Concat($global:currentDirectory, $Path)
    Start-Process -PassThru $tmpPath | Get-Process -Module
}

function WinXPlore_ChangeDirectory {
    param (
        $Path
    )
    
    $testDir = $Path
    if (WinXPlore_CheckPath -Path $testDir == $true) {
        $global:currentDirectory = $testDir
        Write-Host "New directory has been successfully set" -ForegroundColor green
    } else {
        Write-Host "The directory does not exist or is not written correctly" -ForegroundColor -red
        Write-Host "Directory info has been return to previous condition" -ForegroundColor red
    }
}

###################  PROGRAM  ###################

while (1) {
    Clear-Host
    WinXPlore_PrintApplicationHeader

    Write-Host "Enter full directory path you want to work with"
    Write-Host -NoNewline "WinXPlore:> "
    $directory = Read-Host

    if (WinXPlore_CheckPath -Path $directory == $true) {
        $global:currentDirectory = $directory
        WinXPlore_GlobalSlashChecker
        Write-Host "The directory has been successfully picked!" -ForegroundColor green
        Write-Host ""

        [int]$state = 1
        while ($state -ne 0) {
            Write-Host "Show Directory [1] | Show Dependencies [2] | Change Directory [3] | Restart [4] | Quit [5]"

            Write-Host -NoNewline "WinXPlore:> "
            $userChoise = Read-Host
            switch ($userChoise) {
                1 {WinXPlore_TableOfDirectoryContent; break}
                2 {
                    Write-Host "Enter application from current directory"
                    Write-Host -NoNewline "WinXPlore:> "
                    $app = Read-Host
                    WinXPlore_ShowDependencies -Path $app
                    ;break}
                3 { 
                    Write-Host "Enter new directory"
                    Write-Host -NoNewline "WinXPlore:> "
                    $directory = Read-Host

                    WinXPlore_ChangeDirectory -Path $directory

                    ;break}
                4 {$state = 0; break}
                5 {exit}
            }
        }
    } else {
        Write-Host "The directory does not exist or is not written correctly" -ForegroundColor red
    }
}
