#!/usr/bin/bash

cat << EOF > /etc/modules-load.d/rancher.conf
udp_tunnel
ip6_udp_tunnel
ip_set
ip_set_hash_ip
ip_set_hash_net
iptable_filter
iptable_nat
iptable_mangle
iptable_raw
nf_conntrack_netlink
nf_conntrack
nf_defrag_ipv4
nf_nat
nfnetlink
x_tables
xt_addrtype
xt_conntrack
xt_comment
xt_mark
xt_multiport
xt_nat
xt_recent
xt_set
xt_statistic
xt_tcpudp
veth
overlay
macvlan
br_netfilter
EOF
systemctl restart systemd-modules-load.service


sleep 3

sysctl -p
#Kernel参数调优，执行命令
echo "
net.ipv4.ip_forward=1
net.ipv4.conf.all.forwarding=1
net.ipv4.neigh.default.gc_thresh1=4096
net.ipv4.neigh.default.gc_thresh2=6144
net.ipv4.neigh.default.gc_thresh3=8192
net.ipv4.neigh.default.gc_interval=60
net.ipv4.neigh.default.gc_stale_time=120
kernel.perf_event_paranoid=-1
net.ipv4.tcp_slow_start_after_idle=0
fs.inotify.max_user_watches=524288
fs.file-max=2097152
fs.inotify.max_user_instances=8192
fs.inotify.max_queued_events=16384
kernel.softlockup_all_cpu_backtrace=1
kernel.softlockup_panic=1
vm.max_map_count=262144
net.core.netdev_max_backlog=16384
net.ipv4.tcp_wmem=4096 12582912 16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 12582912 16777216
net.core.rmem_max=16777216
net.core.somaxconn=32768
net.ipv4.tcp_max_syn_backlog=8192
vm.swappiness=0
kernel.core_uses_pid=1
net.ipv4.conf.default.accept_source_route=0
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.promote_secondaries=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.all.promote_secondaries=1
fs.protected_hardlinks=1
fs.protected_symlinks=1
net.ipv4.conf.default.arp_announce=2
net.ipv4.conf.lo.arp_announce=2
net.ipv4.conf.all.arp_announce=2
net.ipv4.tcp_max_tw_buckets=5000
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_synack_retries=2
kernel.sysrq=1
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
" >> /etc/sysctl.conf
sysctl -p

sleep 2

### 配置文件最大打开数
cat >> /etc/security/limits.conf <<EOF
      root soft nofile 655350
      root hard nofile 655350
      * soft nofile 655350
      * hard nofile 655350
      * soft    nproc   unlimited
      * hard    nproc   unlimited
      * soft    core    unlimited
      * hard    core    unlimited
      * soft    memlock unlimited
      * hard    memlock unlimited
EOF

#重启主机
#reboot
