### Overview:
These docker images serve as a base image for Penetration Testing and Red Teaming.  I have pre-installed several useful tools that I use day to day on engagements. 

All terminal output will be logged to ~/.logs/ with date and timestamps. If there are any other tools that the community finds useful or want included feel free to submit a pull request.

Thanks to all the developers that put the time and effort into the tools in this container! 

### Usage:
```
# For arm based deployments:
docker run -it sn8kesec/bastion:armv8

# For x86/x64 based deployments:
docker run -it sn8kesec/bastion:amd64
```

### OS
```
~ > cat /etc/os-release                                                                                                                   root@797dfc5b7506 11:15:09 PM
PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
NAME="Debian GNU/Linux"
VERSION_ID="12"
VERSION="12 (bookworm)"
VERSION_CODENAME=bookworm
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

### Programing Lanaguages
- Go
- Java
- NodeJS
- Perl
- Powershell 7
- Python 3
- Rust


### Linux Packages
- openvpn 
- wget
- python3
- python3-pip
- python3-venv
- pipx
- libkrb5-dev
- krb5-config
- curl
- gpg
- unzip
- git
- jq
- dnsutils
- nano
- net-tools
- ldap-utils
- libssl-dev
- screen
- nmap
- make
- build-essential
- unzip
- locate
- default-jdk
- tmux
- docker.io
- proxychains-ng
- tcpdump
- zsh

### Installed Cloud Services CLI
- GCloud
- AWS
- Azure
- kubectl

### Installed 3rd Party Tooling
- [Powershell](https://github.com/PowerShell/PowerShell/)
- [GCloud](https://cloud.google.com/sdk/gcloud/)
- [Metasploit](https://www.metasploit.com/)
- [dirsearch](https://github.com/maurosoria/dirsearch)
- [dnsrecon](https://github.com/darkoperator/dnsrecon)
- [impacket](https://github.com/fortra/impacket)
- [bloodhound.py](https://github.com/dirkjanm/BloodHound.py)
- [sqlmap](https://github.com/sqlmapproject/sqlmap)
- [certipy-ad](https://github.com/ly4k/Certipy)
- [Coercer](https://github.com/p0dalirius/Coercer)
- [pyldapsearch](https://github.com/fortalice/pyldapsearch)
- [pysqlrecon](https://github.com/Tw1sm/PySQLRecon)
- [spraycharles](https://github.com/Tw1sm/spraycharles)
- [PMapper](https://github.com/nccgroup/PMapper)
- [ScoutSuite](https://github.com/nccgroup/ScoutSuite)
- [trevorspray](https://github.com/blacklanternsecurity/trevorspray)
- [trevorproxy](https://github.com/blacklanternsecurity/trevorproxy)
- [certi](https://github.com/zer1t0/certi.git)
- [enum4linux-ng](https://github.com/cddmp/enum4linux-ng.git)
- [recon-ng](https://github.com/lanmaster53/recon-ng.git)
- [PetitPotam](https://github.com/topotam/PetitPotam.git)
- [pre2k](https://github.com/garrettfoster13/pre2k.git)
- [pywhisker](https://github.com/ShutdownRepo/pywhisker.git)
- [PKINITtools](https://github.com/dirkjanm/PKINITtools.git)
- [sccmhunter](https://github.com/garrettfoster13/sccmhunter.git)
- [wmiexec-Pro](https://github.com/XiaoliChan/wmiexec-Pro.git)
- [bf-aws-perms-simulate](https://github.com/carlospolop/bf-aws-perms-simulate.git)
- [bf-aws-permissions](https://github.com/carlospolop/bf-aws-permissions.git)
- [ysoserial](https://github.com/frohoff/ysoserial)
- [godap](https://github.com/Macmod/godap)
- [ldapper](https://github.com/Synzack/ldapper.git)
- [kerbrute](https://github.com/ropnop/kerbrute)
- [TeamsUserEnum](https://github.com/MitchellDStein/TeamsUserEnum.git)
- [cloudfox](https://github.com/BishopFox/cloudfox)
- [nikto](https://github.com/sullo/nikto)
- [mikto](https://github.com/ChrisTruncer/mikto.git)
- [PowerSploit](https://github.com/PowerShellMafia/PowerSploit.git)
- [MicroBurst](https://github.com/NetSPI/MicroBurst.git)
- [BARK](https://github.com/BloodHoundAD/BARK.git)