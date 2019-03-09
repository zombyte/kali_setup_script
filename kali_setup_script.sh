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
read -rsp $'Press any key to continue...\n' -n1 key

echo -e "\n== 1.0 Updating OS"
if ${UPGRADE} ; then
	apt update
	apt upgrade -y
else
	echo OS Updates skipped.
fi
read -rsp $'Press any key to continue...\n' -n1 key

# OS Package Installations
echo -e "\n== 2.0 OS Package Installations"

echo -e "\n=== 2.1 Installing Snapd"
apt install -y snapd
systemctl start snapd
systemctl enable snapd
echo -e "export PATH=\$PATH:/snap/bin" >> ~/.bashrc
source ~/.bashrc
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 2.2 Installing GoLang"
apt install -y golang
echo -e "export GOPATH=\$HOME/go" >> ~/.bash_profile
source ~/.bash_profile
echo -e "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
source ~/.bashrc
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 2.3 Installing Node/NPM"
apt install -y npm
echo -e "export PATH=\$PATH:/opt/node_modules/.bin" >> ~/.bashrc
source ~/.bashrc
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 2.4 Installing PIP3"
apt install -y python3-pip
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 2.5 Installing KeepNote"
apt install -y keepnote
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 2.6 Installing SecLists"
apt install -y seclists
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 2.7 Installing GoBuster"
apt install -y gobuster
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 2.8 Installing CrackMapExec"
apt install -y crackmapexec
read -rsp $'Press any key to continue...\n' -n1 key

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
read -rsp $'Press any key to continue...\n' -n1 key

# GIT based repo installations
wait
echo "== 3.0 Git Repos (~/Downloads/git_repos)"
echo -e "\n=== 3.1 Cloning LinEnum"
git clone https://github.com/rebootuser/LinEnum.git ~/Downloads/git_repos/LinEnum
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.2 Cloning linuxprivchecker"
git clone https://github.com/sleventyeleven/linuxprivchecker.git ~/Downloads/git_repos/linuxprivcehcker
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.3 Cloning JAWS"
git clone https://github.com/411Hall/JAWS.git ~/Downloads/git_repos/JAWS
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.4 Cloning unix-privsec-check"
git clone https://github.com/pentestmonkey/unix-privesc-check.git ~/Downloads/git_repos/unix-privsec-check
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.5 Cloning windows-privsec-check"
git clone https://github.com/pentestmonkey/windows-privesc-check.git ~/Downloads/git_repos/windows-privsec-check
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.6 Cloning linux-exploit-suggester"
git clone https://github.com/mzet-/linux-exploit-suggester.git ~/Downloads/git_repos/linux-exploit-suggester
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.7 Cloning Windows-Exploit-Suggester"
git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git ~/Downloads/git_repos/Windows-Exploit-Suggester
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.8 Cloning Sherlock"
git clone https://github.com/rasta-mouse/Sherlock.git ~/Downloads/git_repos/Sherlock
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.9 Cloning Watson"
git clone https://github.com/rasta-mouse/Watson.git ~/Downloads/git_repos/Watson
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.10 Cloning php-reverse-shell"
git clone https://github.com/pentestmonkey/php-reverse-shell.git ~/Downloads/git_repos/php-reverse-shell
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.11 Cloning PayloadsAllTheThings"
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git ~/Downloads/git_repos/PayloadsAllTheThings
read -rsp $'Press any key to continue...\n' -n1 key

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
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.13 Cloning SSRFmap"
git clone https://github.com/swisskyrepo/SSRFmap.git ~/Downloads/git_repos/SSRFmap
cd ~/Downloads/git_repos/SSRFmap
pip3 install -r requirements.txt
sed -i 's_#!/usr/bin/python_#!/usr/bin/python3_' ~/Downloads/git_repos/SSRFmap/ssrfmap.py 
ln -s ~/Downloads/git_repos/SSRFmap/ssrfmap.py /usr/bin/ssrfmap
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.14 Cloning pacu"
git clone https://github.com/RhinoSecurityLabs/pacu.git ~/Downloads/git_repos/pacu
cd ~/Downloads/git_repos
/bin/bash install.sh
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.15 Cloning XSRFProbe"
git clone https://github.com/0xInfection/XSRFProbe.git ~/Downloads/git_repos/XSRFProbe
cd ~/Downloads/git_repos/XSRFProbe
pip3 install -r requirements.txt
chmod +x ~/Downloads/git_repos/XSRFprobe/xsrfprobe.py
ln -s ~/Downloads/git_repos/XSRFProbe/xsrfprobe.py /usr/bin/xsrfprobe
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.16 Cloning XSStrike"
git clone https://github.com/s0md3v/XSStrike.git ~/Downloads/git_repos/XSStrike
cd ~/Downloads/git_repos/XSStrike
pipr install -r requirements.txt
chmod +x ~/Downloads/git_repos/XSStrike/xsstrike.py
ln -s ~/Downloads/git_repos/XSStrike/xsstrike.py /usr/bin/xsstrike
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.17 Cloning aws_pwn"
git clone https://github.com/dagrz/aws_pwn.git ~/Downloads/git_repos/aws_pwn
cd ~/Downloads/git_repos/aws_pwn
pip install -r requirements.txt
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.18 Cloning subfinder"
git clone https://github.com/subfinder/subfinder.git ~/Downloads/git_repos/subfinder
cd ~/Downloads/git_repos/subfinder
go get
go build
ln -s ~/Downloads/git_repos/subfinder/subfinder /usr/bin/subfinder
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.19 Cloning ScoutSuite"
git clone https://github.com/nccgroup/ScoutSuite.git ~/Downloads/git_repos/ScoutSuite
cd ~/Downloads/git_repos/ScoutSuite
pip install -r requirements.txt
chmod +x Scout.py
ln -s ~/Downloads/git_repos/ScoutSuite/Scount.py /usr/bin/Scout
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.20 Cloning NoSQLMap"
git clone https://github.com/codingo/NoSQLMap.git ~/Downloads/git_repos/NoSQLMap
cd ~/Downloads/git_repos/NoSQLMap
python setup.py install
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.21 Cloning AutoRecon"
git clone https://github.com/Tib3rius/AutoRecon.git ~/Downloads/git_repos/AutoRecon
cd ~/Downloads/git_repos/AutoRecon
pip3 install -r requirements.txt
sed -i 's\__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))\/root/Downloads/git_repos/AutoRecon\' ~/Downloads/git_repos/AutoRecon/autorecon.py
chmod +x ~/Downloads/git_repos/autorecon.py
ln -s ~/Downloads/git_repos/AutoRecon/autorecon.py /usr/bin/autorecon
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.22 Cloning LFISuite"
git clone https://github.com/D35m0nd142/LFISuite.git ~/Downloads/git_repos/LFISuite
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.23 Cloning Empire"
git clone https://github.com/EmpireProject/Empire.git ~/Downloads/git_repos/Empire
cd ~/Downloads/git_repos/Empire/
./setup/install.sh
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 3.24 Cloning nishang"
git clone https://github.com/samratashok/nishang.git ~/Downloads/git_repos/nishang
read -rsp $'Press any key to continue...\n' -n1 key

# Additional Installation Steps
wait
echo -e "\n== 4.0 Additional Installations"
echo -e "\n==== 4.1 Installing PhantomJS, SlimerJS, and CasperJS"
apt install -y phantomjs
apt install -y libc6 libstdc++6 libgcc1 libgtk2.0-0 libasound2 libxrender1 libdbus-glib-1-2
cd /opt/
npm install slimerjs
npm install casterjs
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 4.2 Installing old FireFox for Casper"
wget https://ftp.mozilla.org/pub/firefox/releases/59.0.3/linux-x86_64/en-US/firefox-59.0.3.tar.bz2 -O /tmp/firefox-59.0.3.tar.bz2
tar vxjf /tmp/firefox-59.0.3.tar.bz2 -C /opt
echo "export SLIMERJSLAUNCHER=/opt/firefox/firefox" >> ~/.bash_profile
source ~/.bash_profile
rm /tmp/firefox-59.0.3.tar.bz2
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 4.3 Installing wfuzz"
pip install wfuzz
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 4.4 Installing PyCharm"
snap install pycharm-community --classic
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 4.5 Installing Atom"
snap install atom --classic
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 4.6 Set Firefox Bookmarks"
firefox_default_path=$(find ~/.mozilla/firefox/ -name "places.sqlite")
kill -s TERM $(pidof firefox-esr)
sqlite3 ${firefox_default_path} ".restore /tmp/places.sqlite"
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n=== 4.7 Set up host-files"
wget https://raw.githubusercontent.com/zombyte/kali_setup_script/master/host-files.py -O /usr/bin/host-files
chmod +x /usr/bin/host-files
mkdir -p ~/host-files/os_files
ln -s /usr/share/windows-binaries/ ~/host-files/os_files/windows-binaries
ln -s /usr/share/webshells/ ~/host-files/os_files/webshell
ln -s ~/Downloads/git_repos/ ~/host-files/git_repos
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n== 5.0 Burp Moditifications"
read -rsp $'Press any key to continue...\n' -n1 key

wait
echo -e "\n== 6.0 Cleanup"
apt-get autoremove -y
apt-get autoclean -y
#shutdown -r now
