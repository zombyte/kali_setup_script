A simple script that completes installs the following tools and configurations to my liking. Broken into sections by installation method. 

### 0.0 Reset Root Password
Change that shit from toor

### 1.0 OS Updates
- OS Updates 

### OS Package Installations
- [Docker](https://github.com/docker/docker-ce)
- [Snap](https://github.com/snapcore/snapd)
- [Go](https://github.com/golang/go)
- [Node](https://github.com/nodejs/node)
- [NPM](https://github.com/npm/cli)
- [SecLists](https://github.com/danielmiessler/SecLists)
- [GoBuster](https://github.com/OJ/gobuster)
- [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec)
- [KeepNote](https://github.com/mdrasmus/keepnote)
- [OpenVAS](https://github.com/greenbone/openvas-scanner)

### GIT based repo installation
A [x] signifies modified to be universally accessible in the file system. Relevant details below. I wasn't able to do this for all script/applications however since my bash-fu/python-fu is scrub level at best.

- [ ][LinEnum](https://github.com/rebootuser/LinEnum)
- [ ][linuxprivchecker](https://github.com/sleventyeleven/linuxprivchecker)
- [ ][JAWS](https://github.com/411Hall/JAWS)
- [ ][unix-priv-check](https://github.com/pentestmonkey/unix-privesc-check)
- [ ][windows-priv-check](https://github.com/pentestmonkey/windows-privesc-check)
- [ ][linux-exploit-suggester](https://github.com/mzet-/linux-exploit-suggester)
- [ ][Windows-Exploit-Suggester](https://github.com/GDSSecurity/Windows-Exploit-Suggester)
- [ ][Watson](https://github.com/rasta-mouse/Watson)
- [ ][Sherlock](https://github.com/rasta-mouse/Sherlock)
- [ ][php-reverse-shell](https://github.com/pentestmonkey/php-reverse-shell)
- [ ][PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings])
- [ ][vulscan](https://github.com/scipag/vulscan) - Added update.sh to hourly update csv db files. Added update exec to cron.
- [x][SSRFmap](https://github.com/swisskyrepo/SSRFmap) - updates shebang to python3, chmod +x, and set symlink
- [ ][pacu](https://github.com/RhinoSecurityLabs/pacu)
- [x][XSRFProbe](https://github.com/0xInfection/XSRFProbe) - chmod +x and set symlink
- [x][XSStrike](https://github.com/s0md3v/XSStrike) - chmod +x and set symlink
- [ ][aws_pwn](https://github.com/dagrz/aws_pwn)
- [x][subfinder](https://github.com/subfinder/subfinder) - set symlink
- [x][ScoutSuite](https://github.com/nccgroup/ScoutSuite) - chmod +x and set symlink
- [x][NoSQLMap](https://github.com/codingo/NoSQLMap)
- [ ][Astra](https://github.com/flipkart-incubator/Astra)
- [x][AutoRecon](https://github.com/Tib3rius/AutoRecon) - Update toml files to FQDN, chmod +x, and set symlink
- [ ][LFISuite](https://github.com/D35m0nd142/LFISuite)
- [ ][Empire](https://github.com/EmpireProject/Empire)
- [ ][nishang](https://github.com/samratashok/nishang)

### Additionally Scripted Installations
- [PhantomJS](https://github.com/ariya/phantomjs)
- [SlimerJS](https://github.com/laurentj/slimerjs)
- [CasperJS](https://github.com/casperjs/casperjs)
- [FireFox v59.0.3](https://ftp.mozilla.org/pub/firefox/releases/59.0.3/)
- [wfuzz](https://github.com/xmendez/wfuzz)
- [pycharm-community](https://www.jetbrains.com/pycharm/download/)
- [atom](https://github.com/atom/atom)

### Easy Execution
`curl https://raw.githubusercontent.com/zombyte/kali_setup_script/master/kali_setup_script.sh | bash -s -- -u true -p project`

### ToDo
- fix issue with host-git script running from /usr/bin
- Install burp pro
- Add more bookmarks
- Make mindmap of test process, save to repo, and set to background
- Add better logic for installation
- Add update logic to update git repos
- Update readme to table fromat
- Add flags for each tool 
- Add installation groups
