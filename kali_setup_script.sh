#!/bin/bash

# CLI Arguments
# Defaults
PROJECT=""
UPGRADE=true
POSITIONAL=()
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-p|--project)
			PROJECT="$2"
			shift; shift;;
		-u|--upgrade)
			UPGRADE="$2"
			shift; shift;;
		-ov|--openvas)
			OPENVAS="$2"
			shift; shift;;			
	esac
done

# Check for project name
if [[ -z ${PROJECT}  ]]; then
	echo No project specified
	exit 1
fi

echo -e "\n== 0.0 Update Root Password"
passwd root

echo -e "\n== 1.0 Updating OS"
if ${UPGRADE} ; then
	apt update
	apt upgrade -y
fi

# OS Package Installations
echo -e "\n== 2.0 OS Package Installations"

echo -e "\n=== 2.1 Installing Docker"
apt remove docker docker-engine docker.io containerd runc
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
echo 'deb https://download.docker.com/linux/debian stretch stable' > /etc/apt/sources.list.d/docker.list
apt update
apt install -y docker-ce
systemctl start docker
systemctl enable docker

echo -e "\n=== 2.2 Installing Snapd"
apt install -y snapd
systemctl start snapd
systemctl enable snapd
echo -e "export PATH=\$PATH:/snap/bin" >> ~/.bashrc
source ~/.bashrc

echo -e "\n=== 2.3 Installing GoLang"
apt install -y golang
echo -e "export GOPATH=\$HOME/go" >> ~/.bash_profile
source ~/.bash_profile
echo -e "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
source ~/.bashrc

echo -e "\n=== 2.4 Installing Node/NPM"
apt install -y npm
echo -e "export PATH=\$PATH:/opt/node_modules/.bin" >> ~/.bashrc
source ~/.bashrc

echo -e "\n=== 2.4 Installing KeepNote"
apt install -y keepnote

echo -e "\n=== 2.5 Installing SecLists"
apt install -y seclists

echo -e "\n=== 2.6 Installing GoBuster"
apt install -y gobuster

echo -e "\n=== 2.7 Installing CrackMapExec"
apt install -y crackmapexec

echo -e "\n=== 2.8 Installing OpenVAS"
if ${OPENVAS} ; then
	apt install -y openvas
	openvas-setup
	openvas-start
	systemctl enable openvas
else
	echo OpenVAS install skipped.
fi

# GIT based repo installations
echo "== 3.0 Git Repos (~/Downloads/git_repos)"
echo -e "\n=== 3.1 Cloning LinEnum"
git clone https://github.com/rebootuser/LinEnum.git ~/Downloads/git_repos/LinEnum

echo -e "\n=== 3.2 Cloning linuxprivchecker"
git clone https://github.com/sleventyeleven/linuxprivchecker.git ~/Downloads/git_repos/linuxprivcehcker

echo -e "\n=== 3.3 Cloning JAWS"
git clone https://github.com/411Hall/JAWS.git ~/Downloads/git_repos/JAWS

echo -e "\n=== 3.4 Cloning unix-privsec-check"
git clone https://github.com/pentestmonkey/unix-privesc-check.git ~/Downloads/git_repos/unix-privsec-check

echo -e "\n=== 3.5 Cloning windows-privsec-check"
git clone https://github.com/pentestmonkey/windows-privesc-check.git ~/Downloads/git_repos/windows-privsec-check

echo -e "\n=== 3.6 Cloning linux-exploit-suggester"
git clone https://github.com/mzet-/linux-exploit-suggester.git ~/Downloads/git_repos/linux-exploit-suggester

echo -e "\n=== 3.7 Cloning Windows-Exploit-Suggester"
git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git ~/Downloads/git_repos/Windows-Exploit-Suggester

echo -e "\n=== 3.8 Cloning Sherlock"
git clone https://github.com/rasta-mouse/Sherlock.git ~/Downloads/git_repos/Sherlock

echo -e "\n=== 3.9 Cloning Watson"
git clone https://github.com/rasta-mouse/Watson.git ~/Downloads/git_repos/Watson

echo -e "\n=== 3.10 Cloning php-reverse-shell"
git clone https://github.com/pentestmonkey/php-reverse-shell.git ~/Downloads/git_repos/php-reverse-shell

echo -e "\n=== 3.11 Cloning PayloadsAllTheThings"
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git ~/Downloads/git_repos/PayloadsAllTheThings

echo -e "\n== 3.12 Cloning vulscan"
mkdir -p /usr/share/nmap/scripts/vulscan
git clone https://github.com/scipag/vulscan.git ~/Downloads/git_repos/vulscan
cp ~/Downloads/git_repos/vulscan/* /usr/share/nmap/scripts/vulscan
echo "wget http://www.computec.ch/projekte/vulscan/download/cve.csv -O /usr/share/nmap/scripts/vulscan/cve.csv" >> /usr/share/nmap/scripts/vulscan/update.sh
echo "wget http://www.computec.ch/projekte/vulscan/download/osvdb.csv -O /usr/share/nmap/scripts/vulscan/osvdb.csv" >> /usr/share/nmap/scripts/vulscan/update.sh
echo "wget http://www.computec.ch/projekte/vulscan/download/scipvuldb.csv -O /usr/share/nmap/scripts/vulscan/scipvuldb.csv" >> /usr/share/nmap/scripts/vulscan/update.sh
echo "wget http://www.computec.ch/projekte/vulscan/download/securityfocus.csv -O /usr/share/nmap/scripts/vulscan/securityfocus.csv" >> /usr/share/nmap/scripts/vulscan/update.sh
echo "wget http://www.computec.ch/projekte/vulscan/download/securitytracker.csv -O /usr/share/nmap/scripts/vulscan/securitytracker.csv" >> /usr/share/nmap/scripts/vulscan/update.sh
echo "wget http://www.computec.ch/projekte/vulscan/download/xforce.csv  -O /usr/share/nmap/scripts/vulscan/xforce.csv" >> /usr/share/nmap/scripts/vulscan/update.sh
echo -e "* 0 * * * root /usr/share/nmap/scripts/vulscan/update.sh" >> /etc/crontab
/bin/bash /usr/share/nmap/scripts/vulscan/update.sh

echo -e "\n=== 3.13 Cloning SSRFmap"
git clone https://github.com/swisskyrepo/SSRFmap.git ~/Downloads/git_repos/SSRFmap
cd ~/Downloads/git_repos/SSRFmap
pip3 install -r requirements.txt
sed -i 's_#!/usr/bin/python_#!/usr/bin/python3_' ~/Downloads/git_repos/SSRFmap/ssrfmap.py 
ln -s ~/Downloads/git_repos/SSRFmap/ssrfmap.py /usr/bin/ssrfmap

echo -e "\n=== 3.14 Cloning pacu"
git clone https://github.com/RhinoSecurityLabs/pacu.git ~/Downloads/git_repos/pacu
cd ~/Downloads/git_repos
/bin/bash install.sh

echo -e "\n=== 3.15 Cloning XSRFProbe"
git clone https://github.com/0xInfection/XSRFProbe.git ~/Downloads/git_repos/XSRFProbe
cd ~/Downloads/git_repos/XSRFProbe
pip3 install -r requirements.txt
chmod +x ~/Downloads/git_repos/XSRFprobe/xsrfprobe.py
ln -s ~/Downloads/git_repos/XSRFProbe/xsrfprobe.py /usr/bin/xsrfprobe

echo -e "\n=== 3.16 Cloning XSStrike"
git clone https://github.com/s0md3v/XSStrike.git ~/Downloads/git_repos/XSStrike
cd ~/Downloads/git_repos/XSStrike
pipr install -r requirements.txt
chmod +x ~/Downloads/git_repos/XSStrike/xsstrike.py
ln -s ~/Downloads/git_repos/XSStrike/xsstrike.py /usr/bin/xsstrike

echo -e "\n=== 3.17 Cloning aws_pwn"
git clone https://github.com/dagrz/aws_pwn.git ~/Downloads/git_repos/aws_pwn
cd ~/Downloads/git_repos/aws_pwn
pip install -r requirements.txt

echo -e "\n=== 3.18 Cloning subfinder"
git clone https://github.com/subfinder/subfinder.git ~/Downloads/git_repos/subfinder
cd ~/Downloads/git_repos/subfinder
go get
go build
ln -s ~/Downloads/git_repos/subfinder/subfinder /usr/bin/subfinder

echo -e "\n=== 3.19 Cloning ScoutSuite"
git clone https://github.com/nccgroup/ScoutSuite.git ~/Downloads/git_repos/ScoutSuite
cd ~/Downloads/git_repos/ScoutSuite
pip install -r requirements.txt
chmod +x Scout.py
ln -s ~/Downloads/git_repos/ScoutSuite/Scount.py /usr/bin/Scout

echo -e "\n=== 3.20 Cloning NoSQLMap"
git clone https://github.com/codingo/NoSQLMap.git ~/Downloads/git_repos/NoSQLMap
cd ~/Downloads/git_repos/NoSQLMap
python setup.py install

echo -e "\n=== 3.22 Cloning Astra"
docker pull mongo
docker run --name astra-mongo -d mongo
git clone https://github.com/flipkart-incubator/Astra.git ~/Downloads/git_repos/Astra
cd ~/Downloads/git_repos/Astra
docker build -t astra .
docker run --rm -it --link astra-mongo:mongo -p 8094:8094 -d --name astra astra
git clone -b docker-cli https://github.com/flipkart-incubator/Astra.git ~/Downloads/git_repos/Astra-cli
cd ~/Downloads/git_repos/Astra-cli
docker build -t astra-cli .
docker run --rm -it --link astra-mongo:mongo -d --name astra-cli astra-cli

echo -e "\n=== 3.23 Cloning AutoRecon"
git clone https://github.com/Tib3rius/AutoRecon.git ~/Downloads/git_repos/AutoRecon
cd ~/Downloads/git_repos/AutoRecon
pip3 install -r requirements.txt
sed -i "s,'port-scan-profiles.toml','/root/Downloads/git_repos/AutoRecon/port-scan-profiles.toml'," autorecon.py
sed -i "s,'service-scans.toml','/root/Downloads/git_repos/AutoRecon/service-scans.toml'," autorecon.py
chmod +x autorecon.py
ln -s ~/Downloads/git_repos/AutoRecon/autorecon.py /usr/bin/autorecon

echo -e "\n=== 3.24 Cloning LFISuite"
git clone https://github.com/D35m0nd142/LFISuite.git ~/Downloads/git_repos/LFISuite

echo -e "\n=== 3.25 Cloning Empire"
git clone https://github.com/EmpireProject/Empire.git ~/Downloads/git_repos/Empire
cd ~/Downloads/git_repos/Empire/
./setup/install.sh

echo -e "\n=== 3.26 Cloning nishang"
git clone https://github.com/samratashok/nishang.git ~/Downloads/git_repos/nishang

# Additional Installation Steps
echo -e "\n== 4.0 Additional Installations"
echo -e "\n==== 4.1 Installing PhantomJS, SlimerJS, and CasperJS"
apt install -y phantomjs
apt install -y libc6 libstdc++6 libgcc1 libgtk2.0-0 libasound2 libxrender1 libdbus-glib-1-2
cd /opt/
npm install slimerjs
npm install casterjs

echo -e "\n=== 4.2 Installing old FireFox for Casper"
wget https://ftp.mozilla.org/pub/firefox/releases/59.0.3/linux-x86_64/en-US/firefox-59.0.3.tar.bz2 -O /tmp/firefox-59.0.3.tar.bz2
tar vxjf /tmp/firefox-59.0.3.tar.bz2 -C /opt
echo "export SLIMERJSLAUNCHER=/opt/firefox/firefox" >> ~/.bash_profile
source ~/.bash_profile
rm /tmp/firefox-59.0.3.tar.bz2

echo -e "\n=== 4.3 Installing wfuzz"
pip install wfuzz

echo -e "\n=== 4.4 Installing PyCharm"
snap install pycharm-community --classic

echo -e "\n=== 4.5 Installing Atom"
snap install atom --classic

echo -e "\n=== 4.6 Set Firefox Bookmarks"
wget https://github.com/zombyte/kali_setup_script/places.sqlite -O /tmp/places.sqlite
firefox_default_path=$(find ~/.mozilla/firefox/ -name "places.sqlite")
sqlite3 ${firefox_default_path} ".restore /tmp/places.sqlite"

# link nc and stuff to git for hosting

wget https://github.com/zombyte/kali_setup_script/host-git.py -O /usr/bin/host-files
chmod +x /usr/bin/host-files
mkdir -p ~/host-files/os_files
ln -s /usr/share/windows-binaries/ ~/host-files/os_files/windows-binaries
ln -s /usr/share/webshells/ ~/host-files/os_files/webshell
ln -s ~/Downloads/git_repos/ ~/host-files/os_files/webshell

echo -e "\n== 5.0 Burp Moditifications"

echo -e "\n== 6.0 Cleanup"
apt autoremove -y
apt autoclean -y
shutdown -r now
