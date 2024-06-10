#!/bin/bash

# This script installs and configures Microsoft SQL Server on an Ubuntu 22.04 system, including setting up the repository, installing the necessary packages, configuring the firewall, and displaying the server's IP address for connecting to SQL Server from window
 
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

printf "${NOTE} Adding Microsoft GPG key...\n"
if curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc; then
    printf "\n${OK} Microsoft GPG key added successfully.\n"
else
    printf "\n${ERROR} Failed to add Microsoft GPG key.\n"
    exit 1
fi

printf "\n${NOTE} Adding Microsoft SQL Server repository...\n"
if curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | sudo tee /etc/apt/sources.list.d/mssql-server-2022.list; then
    printf "\n${OK} Microsoft SQL Server repository added successfully.\n"
else
    printf "\n${ERROR} Failed to add Microsoft SQL Server repository.\n"
    exit 1
fi

printf "\n${NOTE} Updating package list...\n"
if sudo apt-get update; then
    printf "\n${OK} Package list updated successfully.\n"
else
    printf "\n${ERROR} Failed to update package list.\n"
    exit 1
fi

printf "\n${NOTE} Installing SQL Server...\n"
if sudo apt-get install -y mssql-server; then
    printf "\n${OK} SQL Server installed successfully.\n"
else
    printf "\n${ERROR} Failed to install SQL Server.\n"
    exit 1
fi

printf "\n${NOTE} Running SQL Server setup...\n"
if sudo /opt/mssql/bin/mssql-conf setup; then
    printf "\n${OK} SQL Server setup completed successfully.\n"
else
    printf "\n${ERROR} Failed to complete SQL Server setup.\n"
    exit 1
fi

printf "\n${NOTE} Checking SQL Server status...\n"
if systemctl status mssql-server --no-pager; then
    printf "\n${OK} SQL Server is running.\n"
else
    printf "\n${ERROR} SQL Server is not running. Check the status for more details.\n"
    exit 1
fi

printf "\n${NOTE} Configuring firewall to allow SQL Server traffic on port 1433...\n"
if sudo ufw allow 1433/tcp; then
    printf "\n${OK} Firewall configured successfully.\n"
else
    printf "\n${ERROR} Failed to configure firewall.\n"
    exit 1
fi

printf "\n${NOTE} Restarting SQL Server...\n"
if sudo systemctl restart mssql-server; then
    printf "\n${OK} SQL Server restarted successfully.\n"
else
    printf "\n${ERROR} Failed to restart SQL Server.\n"
    exit 1
fi

printf "\n${OK} SQL Server is installed and configured.\n"
printf "\n${OK} You can use IP address '%s' to connect to SQL Server.\n" "$(ifconfig | grep 'broadcast' | awk '{print $2}')"
