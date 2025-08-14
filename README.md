# dind-test
```
// terminal
docker compose up --build
```

```
// terminal
su dinder
curl -fsSL https://get.docker.com/rootless | SKIP_IPTABLES=1  sh

// response
+ PATH=/home/dinder/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /home/dinder/bin/dockerd-rootless-setuptool.sh install --skip-iptables
[INFO] systemd not detected, dockerd-rootless.sh needs to be started manually:

PATH=/home/dinder/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh  --iptables=false

[INFO] Creating CLI context "rootless"
Successfully created context "rootless"
[INFO] Using CLI context "rootless"
Current context is now "rootless"

[INFO] Make sure the following environment variable(s) are set (or add them to ~/.bashrc):
# WARNING: systemd not found. You have to remove XDG_RUNTIME_DIR manually on every logout.
export XDG_RUNTIME_DIR=/home/dinder/.docker/run
export PATH=/home/dinder/bin:$PATH

[INFO] Some applications may require the following environment variable too:
export DOCKER_HOST=unix:///home/dinder/.docker/run/docker.sock
```

```
// terminal
export XDG_RUNTIME_DIR=/home/dinder/.docker/run
export DOCKER_HOST=unix:///home/dinder/.docker/run/docker.sock
dinder@6c53913cdf58:/$ PATH=/home/dinder/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh  --iptables=false

// response
+ [ -w /home/dinder/.docker/run ]
+ [ -d /home/dinder ]
+ rootlesskit=
+ command -v docker-rootlesskit
+ command -v rootlesskit
+ rootlesskit=rootlesskit
+ break
+ [ -z rootlesskit ]
+ : /home/dinder/.docker/run/dockerd-rootless
+ : 
+ : 
+ : builtin
+ : auto
+ : auto
+ : 
+ net=
+ mtu=
+ [ -z  ]
+ command -v slirp4netns
+ slirp4netns --help
+ grep -qw -- --netns-type
+ net=slirp4netns
+ [ -z  ]
+ mtu=65520
+ [ -z slirp4netns ]
+ [ -z 65520 ]
+ host_loopback=--disable-host-loopback
+ [  = false ]
+ dockerd=dockerd
+ [ -z  ]
+ _DOCKERD_ROOTLESS_CHILD=1
+ export _DOCKERD_ROOTLESS_CHILD
+ id -u
+ [ 1000 = 0 ]
+ command -v selinuxenabled
+ exec rootlesskit --state-dir=/home/dinder/.docker/run/dockerd-rootless --net=slirp4netns --mtu=65520  --slirp4netns-sandbox=auto --slirp4netns-seccomp=auto --disable-host-loopback --port-driver=builtin --copy-up=/etc   --copy-up=/run --propagation=rslave /home/dinder/bin/dockerd-rootless.sh --iptables=false
WARN[0000] [rootlesskit:parent] The host root filesystem is mounted as "". Setting child propagation to "rslave" is not     supported. 
nsenter: failed to execute ip: No such file or directory
[rootlesskit:parent] error: failed to setup network &{logWriter:0x4000266e00 binary:slirp4netns mtu:65520 ipnet:<nil>   disableHostLoopback:true apiSocketPath: enableSandbox:true enableSeccomp:true enableIPv6:false ifname:tap0 infoMu:{w:{_:{} mu:{state:0 sema:0}} writerSem:0 readerSem:0 readerCount:{_:{} v:0} readerWait:{_:{} v:0}} info:<nil>}: setting up tap tap0:   executing [[nsenter -t 138 -n -m -U --preserve-credentials ip tuntap add name tap0 mode tap] [nsenter -t 138 -n -m -U     --preserve-credentials ip link set tap0 up]]: exit status 127
[rootlesskit:child ] error: EOF 
```