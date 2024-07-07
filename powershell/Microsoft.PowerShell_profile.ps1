# Tere
function Invoke-Tere() {
    $result = . (Get-Command -CommandType Application tere) $args
    if ($result) {
        Set-Location $result
    }
}
Set-Alias tere Invoke-Tere

# Touch
function touch {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    if (Test-Path -LiteralPath $Path) {
        (Get-Item -Path $Path).LastWriteTime = Get-Date
    } else {
        New-Item -Type File -Path $Path
    }
}

# Neovim switcher
function nvims() {
    $items = "default", "nvim-astro", "nvim-nvchad", "nvim-lazy"
    $config = $items | fzf --prompt="  Neovim Config" --height=~50% --layout=reverse --border --exit-0

    if ([string]::IsNullOrEmpty($config)) {
        Write-Output "Nothing selected"
        break
    }

    if ($config -eq "default") {
        $config = ""
    }

    $env:NVIM_APPNAME=$config
    nvim $args
}

# Which
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Lsd ll
function ll {
    lsd -lh $args
}

# Lsd la
function la {
    lsd -alh $args
}


# Alias
Set-Alias -Name sl -Value scoop list
Set-Alias -Name ss -Value scoop search
Set-Alias -Name si -Value scoop install
Set-Alias -Name sr -Value scoop uninstall
Set-Alias -Name sc -Value scoop cache rm *
Set-Alias -Name scc -Value scoop cleanup *

# Config prompt
oh-my-posh init pwsh --config 'C:/Users/nhatt/scoop/apps/oh-my-posh/current/themes/amro.omp.json' | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }

winfetch
