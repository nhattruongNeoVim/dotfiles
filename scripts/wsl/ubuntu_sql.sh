#!/bin/bash

# This script installs and configures Microsoft SQL Server on an Ubuntu 22.04 system, including setting up the repository, installing the necessary packages, configuring the firewall, and displaying the server's IP address for connecting to SQL Server from window
 
source <(curl -sSL https://is.gd/nhattruongNeoVim_lib)

echo "${NOTE} Adding Microsoft GPG key..."
if curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg; then
    echo "${OK} Microsoft GPG key added successfully."
else
    echo "${ERROR} Failed to add Microsoft GPG key."
    exit 1
fi

echo "${NOTE} Adding Microsoft SQL Server repository..."
if curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | sudo tee /etc/apt/sources.list.d/mssql-server-2022.list; then
    echo "${OK} Microsoft SQL Server repository added successfully."
else
    echo "${ERROR} Failed to add Microsoft SQL Server repository."
    exit 1
fi

echo "${NOTE} Updating package list..."
if sudo apt-get update; then
    echo "${OK} Package list updated successfully."
else
    echo "${ERROR} Failed to update package list."
    exit 1
fi

echo "${NOTE} Installing SQL Server..."
if sudo apt-get install -y mssql-server; then
    echo "${OK} SQL Server installed successfully."
else
    echo "${ERROR} Failed to install SQL Server."
    exit 1
fi

echo "${NOTE} Running SQL Server setup..."
if sudo /opt/mssql/bin/mssql-conf setup; then
    echo "${OK} SQL Server setup completed successfully."
else
    echo "${ERROR} Failed to complete SQL Server setup."
    exit 1
fi

echo "${NOTE} Checking SQL Server status..."
if systemctl status mssql-server --no-pager; then
    echo "${OK} SQL Server is running."
else
    echo "${ERROR} SQL Server is not running. Check the status for more details."
    exit 1
fi

echo "${NOTE} Configuring firewall to allow SQL Server traffic on port 1433..."
if sudo ufw allow 1433/tcp; then
    echo "${OK} Firewall configured successfully."
else
    echo "${ERROR} Failed to configure firewall."
    exit 1
fi

echo "${NOTE} Restarting SQL Server..."
if sudo systemctl restart mssql-server; then
    echo "${OK} SQL Server restarted successfully."
else
    echo "${ERROR} Failed to restart SQL Server."
    exit 1
fi

ip=$(ifconfig | grep broadcast | awk '{print $2}')
echo "${OK} SQL Server is installed and configured."
echo "${OK} You can use IP address '${ip}' to connect to SQL Server."
