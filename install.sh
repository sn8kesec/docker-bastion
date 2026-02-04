#!/bin/bash

# Exit on error
set -e

# Must be run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Detect CPU architecture
ARCH=$(uname -m)
case ${ARCH} in
    x86_64)
        echo "[+] Detected x86_64 architecture"
        POWERSHELL_URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-7.4.2-linux-x64.tar.gz"
        GO_URL="https://dl.google.com/go/go1.22.2.linux-amd64.tar.gz"
        AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
        KUBECTL_ARCH="amd64"
        ;;
    aarch64|arm64)
        echo "[+] Detected ARM64 architecture"
        POWERSHELL_URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-7.4.2-linux-arm64.tar.gz"
        GO_URL="https://dl.google.com/go/go1.22.2.linux-arm64.tar.gz"
        AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
        KUBECTL_ARCH="arm64"
        ;;
    *)
        echo "[-] Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

export DEBIAN_FRONTEND=noninteractive

# Update and install base packages
echo "[+] Updating system and installing base packages..."
apt-get update && apt-get upgrade -y
apt-get install -y \
    openvpn \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    uuid \
    pipx \
    libkrb5-dev \
    krb5-config \
    curl \
    gpg \
    unzip \
    git \
    jq \
    dnsutils \
    nano \
    net-tools \
    ldap-utils \
    libssl-dev \
    groff \
    screen \
    nmap \
    make \
    build-essential \
    unzip \
    locate \
    default-jdk \
    tmux \
    docker.io \
    proxychains-ng \
    tcpdump \
    iputils-ping \
    zsh

# Change default shell to zsh
chsh -s $(which zsh)

# Install Powershell
echo "[+] Installing Powershell..."
curl -L -o /tmp/powershell.tar.gz "${POWERSHELL_URL}"
mkdir -p /opt/microsoft/powershell/7
tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
chmod +x /opt/microsoft/powershell/7/pwsh
ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Install GCloud CLI
echo "[+] Installing Google Cloud CLI..."
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get update && apt-get install google-cloud-cli -y

# Install AWS CLI
echo "[+] Installing AWS CLI..."
curl "${AWS_CLI_URL}" -o "awscliv2.zip"
unzip awscliv2.zip
rm -rf awscliv2.zip
./aws/install

# Install Azure CLI
echo "[+] Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install kubectl
echo "[+] Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${KUBECTL_ARCH}/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

# Install Metasploit
echo "[+] Installing Metasploit Framework..."
curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | gpg --dearmor | tee /usr/share/keyrings/metasploit.gpg
echo "deb [signed-by=/usr/share/keyrings/metasploit.gpg] https://apt.metasploit.com/ buster main" | tee /etc/apt/sources.list.d/metasploit-framework.list
apt update && apt install metasploit-framework -y

# Install Rust
echo "[+] Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Go
echo "[+] Installing Go..."
curl -O "${GO_URL}"
tar xvf go*.tar.gz
rm -f go*.tar.gz
chown -R root:root ./go
mv go /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin/' >> ~/.zshrc
export PATH=$PATH:/usr/local/go/bin/

# Install Node.js
echo "[+] Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Install uv and Python versions
echo "[+] Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="/root/.local/bin:$PATH"
echo 'export PATH="/root/.local/bin:$PATH"' >> ~/.zshrc
echo "[+] Installing Python 3.11, 3.12, and 3.13 with uv..."
/root/.local/bin/uv python install 3.11 3.12 3.13

# Setup Powerlevel10k
echo "[+] Setting up Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# Make tools directory
mkdir -p /opt/tools

# Install Python tooling
echo "[+] Installing Python tools..."
pipx ensurepath
pipx install dirsearch
pipx install dnsrecon
pipx install impacket
pipx install bloodhound
pipx install sqlmap
pipx install certipy-ad
pipx install Coercer
pipx install pyldapsearch
pipx install pysqlrecon
pipx install ROADtools --include-deps
pipx install spraycharles
pipx install git+https://github.com/nccgroup/PMapper --include-deps
pipx install git+https://github.com/nccgroup/ScoutSuite --include-deps
pipx install git+https://github.com/blacklanternsecurity/trevorspray
pipx install git+https://github.com/blacklanternsecurity/trevorproxy

# Install additional Python tools from Git
echo "[+] Installing additional Python tools from Git..."
git clone https://github.com/zer1t0/certi.git /opt/tools/certi && cd /opt/tools/certi && pipx install .
git clone https://github.com/cddmp/enum4linux-ng.git /opt/tools/enum4linux-ng && cd /opt/tools/enum4linux-ng && pipx install .

# Install recon-ng
git clone https://github.com/lanmaster53/recon-ng.git /opt/tools/recon-ng
python3 -m venv /root/.local/pipx/venvs/recon-ng
/root/.local/pipx/venvs/recon-ng/bin/pip install -r /opt/tools/recon-ng/REQUIREMENTS
echo "#!/bin/bash
/root/.local/pipx/venvs/recon-ng/bin/python /opt/tools/recon-ng/recon-ng \"\$@\"" > /usr/bin/recon-ng
chmod +x /usr/bin/recon-ng

# Install PetitPotam
git clone https://github.com/topotam/PetitPotam.git /opt/tools/PetitPotam
echo "#!/bin/bash
/root/.local/pipx/venvs/impacket/bin/python /opt/tools/PetitPotam/PetitPotam.py \"\$@\"" > /usr/bin/PetitPotam
chmod +x /usr/bin/PetitPotam

# Install pre2k
git clone https://github.com/garrettfoster13/pre2k.git /opt/tools/pre2k && cd /opt/tools/pre2k && pipx install .

# Install pywhisker
git clone https://github.com/ShutdownRepo/pywhisker.git /opt/tools/pywhisker
python3 -m venv /root/.local/pipx/venvs/pywhisker
/root/.local/pipx/venvs/pywhisker/bin/pip install -r /opt/tools/pywhisker/requirements.txt
echo "#!/bin/bash
/root/.local/pipx/venvs/pywhisker/bin/python /opt/tools/pywhisker/pywhisker.py \"\$@\"" > /usr/bin/pywhisker
chmod +x /usr/bin/pywhisker

# Install PKINITtools
git clone https://github.com/dirkjanm/PKINITtools.git /opt/tools/PKINITtools
python3 -m venv /root/.local/pipx/venvs/PKINITtools
/root/.local/pipx/venvs/PKINITtools/bin/pip install -r /opt/tools/PKINITtools/requirements.txt
echo "#!/bin/bash
/root/.local/pipx/venvs/PKINITtools/bin/python /opt/tools/PKINITtools/getnthash.py \"\$@\"" > /usr/bin/getnthash
chmod +x /usr/bin/getnthash
echo "#!/bin/bash
/root/.local/pipx/venvs/PKINITtools/bin/python /opt/tools/PKINITtools/gets4uticket.py \"\$@\"" > /usr/bin/gets4uticket
chmod +x /usr/bin/gets4uticket

# Install sccmhunter
git clone https://github.com/garrettfoster13/sccmhunter.git /opt/tools/sccmhunter
cd /opt/tools/sccmhunter
python3 -m venv /root/.local/pipx/venvs/sccmhunter
/root/.local/pipx/venvs/sccmhunter/bin/pip install -r /opt/tools/sccmhunter/requirements.txt
echo "#!/bin/bash
/root/.local/pipx/venvs/sccmhunter/bin/python /opt/tools/sccmhunter/sccmhunter.py \"\$@\"" > /usr/bin/sccmhunter
chmod +x /usr/bin/sccmhunter

# Install wmiexec-Pro
git clone https://github.com/XiaoliChan/wmiexec-Pro.git /opt/tools/wmiexec-Pro
cd /opt/tools/wmiexec-Pro
python3 -m venv /root/.local/pipx/venvs/wmiexec-Pro
/root/.local/pipx/venvs/wmiexec-Pro/bin/pip install impacket numpy
echo "#!/bin/bash
/root/.local/pipx/venvs/wmiexec-Pro/bin/python /opt/tools/wmiexec-Pro/wmiexec-pro.py \"\$@\"" > /usr/bin/wmiexec-pro
chmod +x /usr/bin/wmiexec-pro

# Install Java Tools
echo "[+] Installing Java tools..."
mkdir /opt/tools/ysoserial
wget https://github.com/frohoff/ysoserial/releases/latest/download/ysoserial-all.jar -O /opt/tools/ysoserial/ysoserial-all.jar
echo "#!/bin/bash
java -jar /opt/tools/ysoserial/ysoserial-all.jar \"\$@\"" > /usr/bin/ysoserial
chmod +x /usr/bin/ysoserial

# Install Golang tools
echo "[+] Installing Golang tools..."
/usr/local/go/bin/go install github.com/sensepost/gowitness@latest
git clone https://github.com/Macmod/godap /opt/tools/godap && cd /opt/tools/godap && /usr/local/go/bin/go install .
/usr/local/go/bin/go install github.com/ropnop/kerbrute@latest
git clone https://github.com/Synzack/ldapper.git /opt/tools/ldapper && cd /opt/tools/ldapper && /usr/local/go/bin/go mod tidy && /usr/local/go/bin/go install .
git clone https://github.com/MitchellDStein/TeamsUserEnum.git /opt/tools/TeamsUserEnum && cd /opt/tools/TeamsUserEnum/src && /usr/local/go/bin/go install .
/usr/local/go/bin/go install github.com/BishopFox/cloudfox@latest

# Install Perl Tools
echo "[+] Installing Perl tools..."
git clone https://github.com/sullo/nikto /opt/tools/nikto
echo "#!/bin/bash
perl /opt/tools/nikto/program/nikto.pl \"\$@\"" > /usr/bin/nikto
chmod +x /usr/bin/nikto

# Install Bash Tools
echo "[+] Installing Bash tools..."
git clone https://github.com/carlospolop/bf-aws-permissions.git /opt/tools/bf-aws-permissions
ln -s /opt/tools/bf-aws-permissions/bf-aws-permissions.sh /usr/bin/bf-aws-permissions
git clone https://github.com/ChrisTruncer/mikto.git /opt/tools/mikto
echo "#!/bin/bash
bash /opt/tools/mikto/Mikto.sh \"\$@\"" > /usr/bin/mikto
chmod +x /usr/bin/mikto
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install PowerShell Tools
echo "[+] Installing PowerShell tools..."
git clone https://github.com/PowerShellMafia/PowerSploit.git /opt/tools/PowerSploit
git clone https://github.com/NetSPI/MicroBurst.git /opt/tools/MicroBurst
git clone https://github.com/BloodHoundAD/BARK.git /opt/tools/BARK

# Install Terraform
echo "[+] Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update && apt-get install terraform -y

# Cleanup
echo "[+] Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "[+] Installation complete! Please restart your shell to apply all changes."