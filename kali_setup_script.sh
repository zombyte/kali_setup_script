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
else
	echo OS Updates skipped.
fi

# OS Package Installations
echo -e "\n== 2.0 OS Package Installations"

echo -e "\n=== 2.1 Installing Snapd"
apt install -y snapd
systemctl start snapd
systemctl enable snapd
echo -e "export PATH=\$PATH:/snap/bin" >> ~/.bashrc
source ~/.bashrc

wait
echo -e "\n=== 2.2 Installing GoLang"
apt install -y golang
echo -e "export GOPATH=\$HOME/go" >> ~/.bash_profile
echo -e "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
wait
source ~/.bash_profile
source ~/.bashrc

wait
echo -e "\n=== 2.3 Installing Node/NPM"
apt install -y npm
echo -e "export PATH=\$PATH:/opt/node_modules/.bin" >> ~/.bashrc
source ~/.bashrc

wait
echo -e "\n=== 2.4 Installing PIP3"
apt install -y python3-pip

wait
echo -e "\n=== 2.5 Installing KeepNote"
apt install -y keepnote

wait
echo -e "\n=== 2.6 Installing SecLists"
apt install -y seclists

wait
echo -e "\n=== 2.7 Installing GoBuster"
apt install -y gobuster

wait
echo -e "\n=== 2.8 Installing CrackMapExec"
apt install -y crackmapexec

wait
echo -e "\n=== 2.9 Installing OpenVAS"
if ${OPENVAS} ; then
	apt install -y openvas
	openvas-setup
	openvas-start
	systemctl enable openvas
else
	echo OpenVAS install skipped.
fi

# GIT based repo installations
wait
echo "== 3.0 Git Repos (~/Downloads/git_repos)"
echo -e "\n=== 3.1 Cloning LinEnum"
git clone https://github.com/rebootuser/LinEnum.git ~/Downloads/git_repos/LinEnum

wait
echo -e "\n=== 3.2 Cloning linuxprivchecker"
git clone https://github.com/sleventyeleven/linuxprivchecker.git ~/Downloads/git_repos/linuxprivcehcker

wait
echo -e "\n=== 3.3 Cloning JAWS"
git clone https://github.com/411Hall/JAWS.git ~/Downloads/git_repos/JAWS

wait
echo -e "\n=== 3.4 Cloning unix-privesc-check"
git clone https://github.com/pentestmonkey/unix-privesc-check.git ~/Downloads/git_repos/unix-privesc-check

wait
echo -e "\n=== 3.5 Cloning windows-privsec-check"
git clone https://github.com/pentestmonkey/windows-privesc-check.git ~/Downloads/git_repos/windows-privesc-check

wait
echo -e "\n=== 3.6 Cloning linux-exploit-suggester"
git clone https://github.com/mzet-/linux-exploit-suggester.git ~/Downloads/git_repos/linux-exploit-suggester

wait
echo -e "\n=== 3.7 Cloning Windows-Exploit-Suggester"
git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git ~/Downloads/git_repos/Windows-Exploit-Suggester

wait
echo -e "\n=== 3.8 Cloning Sherlock"
git clone https://github.com/rasta-mouse/Sherlock.git ~/Downloads/git_repos/Sherlock

wait
echo -e "\n=== 3.9 Cloning Watson"
git clone https://github.com/rasta-mouse/Watson.git ~/Downloads/git_repos/Watson

wait
echo -e "\n=== 3.10 Cloning php-reverse-shell"
git clone https://github.com/pentestmonkey/php-reverse-shell.git ~/Downloads/git_repos/php-reverse-shell

wait
echo -e "\n=== 3.11 Cloning PayloadsAllTheThings"
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git ~/Downloads/git_repos/PayloadsAllTheThings

wait
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

wait
echo -e "\n=== 3.13 Cloning SSRFmap"
git clone https://github.com/swisskyrepo/SSRFmap.git ~/Downloads/git_repos/SSRFmap
cd ~/Downloads/git_repos/SSRFmap
pip3 install -r requirements.txt
sed -i 's_#!/usr/bin/python_#!/usr/bin/python3_' ~/Downloads/git_repos/SSRFmap/ssrfmap.py 
chmod +x ~/Downloads/git_repos/SSRFmap/ssrfmap.py
ln -s ~/Downloads/git_repos/SSRFmap/ssrfmap.py /usr/bin/ssrfmap

wait
echo -e "\n=== 3.14 Cloning pacu"
git clone https://github.com/RhinoSecurityLabs/pacu.git ~/Downloads/git_repos/pacu
cd ~/Downloads/git_repos/pacu
/bin/bash ~/Downloads/git_repos/pacu/install.sh

wait
echo -e "\n=== 3.15 Cloning XSRFProbe"
git clone https://github.com/0xInfection/XSRFProbe.git ~/Downloads/git_repos/XSRFProbe
cd ~/Downloads/git_repos/XSRFProbe
pip3 install -r requirements.txt
chmod +x ~/Downloads/git_repos/XSRFprobe/xsrfprobe.py
ln -s ~/Downloads/git_repos/XSRFProbe/xsrfprobe.py /usr/bin/xsrfprobe

wait
echo -e "\n=== 3.16 Cloning XSStrike"
git clone https://github.com/s0md3v/XSStrike.git ~/Downloads/git_repos/XSStrike
cd ~/Downloads/git_repos/XSStrike
pip3 install -r requirements.txt
chmod +x ~/Downloads/git_repos/XSStrike/xsstrike.py
ln -s ~/Downloads/git_repos/XSStrike/xsstrike.py /usr/bin/xsstrike

wait
echo -e "\n=== 3.17 Cloning aws_pwn"
git clone https://github.com/dagrz/aws_pwn.git ~/Downloads/git_repos/aws_pwn
cd ~/Downloads/git_repos/aws_pwn
pip install -r requirements.txt

wait
echo -e "\n=== 3.18 Cloning subfinder"
git clone https://github.com/subfinder/subfinder.git ~/Downloads/git_repos/subfinder
cd ~/Downloads/git_repos/subfinder
go build
ln -s ~/Downloads/git_repos/subfinder/subfinder /usr/bin/subfinder

wait
echo -e "\n=== 3.19 Cloning ScoutSuite"
git clone https://github.com/nccgroup/ScoutSuite.git ~/Downloads/git_repos/ScoutSuite
cd ~/Downloads/git_repos/ScoutSuite
pip install -r requirements.txt
chmod +x ~/Downloads/git_repos/ScoutSuite/Scout.py
ln -s ~/Downloads/git_repos/ScoutSuite/Scout.py /usr/bin/Scout

wait
echo -e "\n=== 3.20 Cloning NoSQLMap"
git clone https://github.com/codingo/NoSQLMap.git ~/Downloads/git_repos/NoSQLMap
cd ~/Downloads/git_repos/NoSQLMap
python setup.py install

wait
echo -e "\n=== 3.21 Cloning AutoRecon"
git clone https://github.com/Tib3rius/AutoRecon.git ~/Downloads/git_repos/AutoRecon
cd ~/Downloads/git_repos/AutoRecon
pip3 install -r requirements.txt
sed -i 's\__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))\__location__ = "/root/Downloads/git_repos/AutoRecon\"' ~/Downloads/git_repos/AutoRecon/autorecon.py
chmod +x ~/Downloads/git_repos/AutoRecon/autorecon.py
ln -s ~/Downloads/git_repos/AutoRecon/autorecon.py /usr/bin/autorecon

wait
echo -e "\n=== 3.22 Cloning LFISuite"
git clone https://github.com/D35m0nd142/LFISuite.git ~/Downloads/git_repos/LFISuite

wait
echo -e "\n=== 3.23 Cloning Empire"
git clone https://github.com/EmpireProject/Empire.git ~/Downloads/git_repos/Empire
cd ~/Downloads/git_repos/Empire/
/bin/bash setup/install.sh

wait
echo -e "\n=== 3.24 Cloning nishang"
git clone https://github.com/samratashok/nishang.git ~/Downloads/git_repos/nishang

# Additional Installation Steps
wait
echo -e "\n== 4.0 Additional Installations"
echo -e "\n==== 4.1 Installing PhantomJS, SlimerJS, and CasperJS"
apt install -y phantomjs
apt install -y libc6 libstdc++6 libgcc1 libgtk2.0-0 libasound2 libxrender1 libdbus-glib-1-2
cd /opt/
apt install npm
npm install slimerjs
npm install casterjs

wait
echo -e "\n=== 4.2 Installing old FireFox for Casper"
wget https://ftp.mozilla.org/pub/firefox/releases/59.0.3/linux-x86_64/en-US/firefox-59.0.3.tar.bz2 -O /tmp/firefox-59.0.3.tar.bz2
tar vxjf /tmp/firefox-59.0.3.tar.bz2 -C /opt
echo "export SLIMERJSLAUNCHER=/opt/firefox/firefox" >> ~/.bash_profile
source ~/.bash_profile
rm /tmp/firefox-59.0.3.tar.bz2

wait
echo -e "\n=== 4.3 Installing wfuzz"
pip install wfuzz

wait
echo -e "\n=== 4.4 Installing PyCharm"
if [[ $(uname -a | awk '{print $9}') == "i686" ]]; then
	wget https://jetbrains.com/python/pycharm-community-2018.3.5.tar.gz -O /tmp/pycharm-community.tgz
	tar xzf /tmp/pycharm-community.tgz -C /opt/
	ln -s /opt/pycharm-community-2018.3.5/bin/pycharm.sh /usr/bin/pycharm
	rm /tmp/pycharm-community.tgz
	echo -e "[Desktop Entry]\nName=PyCharm Community 2018.3.5\nExec=/opt/pycharm-community-2018.3.5/bin/pycharm.sh\nStartupNotify=true\nTerminal=false\nType=Application\nIcon=/opt/pycharm-community-2018.3.5/bin/pycharm.png" >> /usr/share/applications/pycharm-community.desktop
else
	snap install pycharm-community --classic
fi

wait
echo -e "\n=== 4.5 Installing Atom"
if [[ $(uname -a | awk '{print $9}') == "i686" ]]; then
	snap install atom --classic
else
	echo "Can't install Atom on x86"
fi

wait
echo -e "\n=== 4.6 Set Firefox Bookmarks"
firefox_default_path=$(find ~/.mozilla/firefox/ -name "places.sqlite")
kill -s TERM $(pidof firefox-esr)
sqlite3 ${firefox_default_path} ".restore /tmp/places.sqlite"

wait
echo -e "\n=== 4.7 Set up host-files"
wget https://raw.githubusercontent.com/zombyte/kali_setup_script/master/host-files.py -O /usr/bin/host-files
chmod +x /usr/bin/host-files
mkdir -p ~/host-files/os_files
ln -s /usr/share/windows-binaries/ ~/host-files/os_files/windows-binaries
ln -s /usr/share/webshells/ ~/host-files/os_files/webshell
ln -s ~/Downloads/git_repos/LinEnum/LinEnum.sh ~/host-files/LinEnum.sh
ln -s ~/Downloads/git_repos/linux-exploit-suggester/linux-exploit-suggester.sh ~/host-files/linux-exploit-suggester.sh
ln -s ~/Downloads/git_repos/linuxprivchecker/linuxprivchecker.py ~/host-files/linuxprivchecker.py
ln -s ~/Downloads/git_repos/php-reverse-shell/php-reverse-shell.php ~/host-files/php-reverse-shell.php
ln -s ~/Downloads/git_repos/unix-privesc-check/upc.sh ~/host-files/upc.sh
ln -s ~/Downloads/git_repos/Windows-Exploit-Suggester/windows-exploit-suggester.py ~/host-files/windows-exploit-suggester.py
ln -s ~/Downloads/git_repos/windows-privesc-check/windows-privesc-check2.exe ~/host-files/windows-privesc-check2.exe
ln -s ~/Downloads/git_repos/windows-privesc-check/windows_privesc_check.py ~/host-files/windows-privesc-check.py

wait
echo -e "\n== 5.0 Burp Moditifications"

wait
echo -e "\n== 6.0 Cleanup"
apt-get autoremove -y
apt-get autoclean -y
shutdown -r now
