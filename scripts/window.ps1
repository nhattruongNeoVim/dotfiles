Write-Host "   ____   __ __   ____  ______      ______  ____   __ __   ___   ____    ____ " -ForegroundColor Blue
Write-Host "  |    \ |  |  | /    ||      |    |      ||    \ |  |  | /   \ |    \  /    |" -ForegroundColor Blue
Write-Host "  |  _  ||  |  ||  o  ||      |    |      ||  D  )|  |  ||     ||  _  ||   __|" -ForegroundColor Blue
Write-Host "  |  |  ||  _  ||     ||_|  |_|    |_|  |_||    / |  |  ||  O  ||  |  ||  |  |" -ForegroundColor Blue
Write-Host "  |  |  ||  |  ||  _  |  |  |        |  |  |    \ |  :  ||     ||  |  ||  |_ |" -ForegroundColor Blue
Write-Host "  |  |  ||  |  ||  |  |  |  |        |  |  |  .  \|     ||     ||  |  ||     |" -ForegroundColor Blue
Write-Host "  |__|__||__|__||__|__|  |__|        |__|  |__|\_| \__,_| \___/ |__|__||___,_|" -ForegroundColor Blue
Write-Host ""
Write-Host ""
Write-Host "-------------------- Script developed by nhattruongNeoVim --------------------"
Write-Host "--------------- Github: httpls://github.com/nhhattruongNeoVim ----------------"
Write-Host ""

# Util function
function Start {
    param ($msg)
    Write-Host("-> "+$msg) -ForegroundColor Green
}

function Done { 
    Write-Host "Done" -ForegroundColor Blue;
    Write-Host 
}

# Start
Start-Process -Wait powershell -verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"

Start -msg "Installing scoop..."
if (Get-Command scoop -errorAction SilentlyContinue)
{
    Write-Warning "Scoop already installed"
}
else {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
Done

Start -msg "Initializing Scoop..."
    scoop install git
    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop bucket add java
    scoop update
Done

Start -msg "Installing Scoop's packages"
    scoop install <# apps #> flow-launcher oh-my-posh fzf winrar lsd
    scoop install <# coding #> git neovim neovide vscode gcc nodejs openjdk python postman alacritty make winfetch lazygit
    scoop install <# reauirement for mason_neovim #> unzip wget gzip pwsh
Done

Start -msg "Installing TGPT(Chat GTP)..."
    scoop install https://raw.githubusercontent.com/aandrew-me/tgpt/main/tgpt.json
Done

Start -msg "Start config"

# Clone dotfiles
Start -msg "Clone dotfiles"
    cd ~
    git clone https://github.com/nhattruongNeoVim/dotfiles
    cd dotfiles
Done

# Config powershell
Start -msg "Config Powershell"
    New-Item -Path $PROFILE -Type File -Force
    $PROFILEPath = $PROFILE
    $profileContent = Get-Content -Path ".\config\window\powershell\Microsoft.PowerShell_profile.ps1"
    $profileContent | Set-Content -Path $PROFILEPath
Done

# Config Alacritty
Start -msg "Config Alacritty"
    $DestinationPath = "~\AppData\Roaming\alacritty"
    If (-not (Test-Path $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath -Force
    }
    Copy-Item ".\config\window\alacritty\alacritty.yml" -Destination $DestinationPath -Force
Done

# Config Neovim
Start -msg "Config Neovim"
    $DestinationPath = "~\AppData\Local"
    If (-not (Test-Path $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath -Force
    }
    Copy-Item ".\config\window\nvim" -Destination $DestinationPath -Force -Recurse
    pip install pynvim
    npm install neovim -g
Done

# Remove dotfiles
Start -msg "Remove dotfiles"
    cd ~
    Remove-Item dotfiles -Recurse -Force
Done

Start -msg "Installing choco..."
if (Get-Command choco -errorAction SilentlyContinue)
{
    Write-Warning "Choco already installed"
}
else {
    Start-Process -Wait powershell -verb runas -ArgumentList "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    Start-Process -Wait powershell -verb runas -ArgumentList "choco feature enable -n allowGlobalConfirmation"
}
Done

Start -msg "Installing Choco's packages"
    Start-Process -Wait powershell -verb runas -ArgumentList "choco install zalopc internet-download-manager vmwareworkstation" 
    # Start-Process -Wait powershell -verb runas -ArgumentList "choco install steam bluestacks" 
Done

Start -msg "Enable Virtualiztion"
Start-Process -Wait powershell -verb runas -ArgumentList @"
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -Norestart
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -Norestart
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -Norestart
    Enable-WindowsOptionalFeature -Online -FeatureName Contaniners -All -Norestart
"@
Done

# Start -msg "Installing WSl..."
# if(!(wsl -l -v)){
#     wsl --install
#     wsl --update
#     wsl --install --no-launch --web-download -d Ubuntu
# }
# else {
#     Write-Warning "Wsl installed"
# }
Done
