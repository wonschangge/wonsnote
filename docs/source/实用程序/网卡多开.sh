
# 网卡1-enp2s0-------------走外网权限
# 网卡2-enx00e04c6c2718----走内网权限
sudo route del default gw 192.168.199.1 dev enp2s0 metric 101
sudo route del default gw 10.42.19.253 dev enx00e04c6c2718 metric 100

sudo route add default gw 192.168.199.1 dev enp2s0 metric 1000
sudo route add default gw 10.42.19.253 dev enx00e04c6c2718 metric 101

# 
sudo route add -net 10.42.0.0/16 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
sudo route add -net 10.44.0.0/16 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
sudo route del -net 172.20.0.0/16 gw 10.42.19.253 dev enx00e04c6c2718 metric 0


# 10.42.181.29:443


172.20.191.0/24,10.42.17.0/24,10.44.17.0/24,10.44.16.0/24,10.42.181.0/24


# 禅道
sudo route add -net 10.42.17.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
sudo route add -net 10.44.17.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
# 统一认证 - 10.44.16.70
sudo route add -net 10.44.16.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
sudo route add -net 10.42.181.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
# gitlab2 --- 172.20.191.209
sudo route add -net 172.20.191.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0


# 禅道
sudo route del -net 10.42.17.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
sudo route del -net 10.44.17.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0
# gitlab2 --- 172.20.191.209
sudo route del -net 172.20.191.0/24 gw 10.42.19.253 dev enx00e04c6c2718 metric 0


sudo route add -net 192.168.199.204/32 gw 192.168.199.1 dev enx00e04c6c2718 metric 0
sudo route add -net 192.168.199.204/0 gw 192.168.199.1 dev enp2s0 metric 100