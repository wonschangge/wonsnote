# 1.创建文件块
dd if=/dev/zero of=1000M_block bs=1M count=1000

# minicom zmodem传输1000M
# Baud rate=1500000, 1.5Mbps(实际应试1.46Mbps), 位传输理论峰值=0.1825MBps=186.88KBps
# BPS(Bytes Per Second)=148900 ETA(Estimated Time of Arrival)=120Minutes1
# BPS换算后为: 145KBps=1.136Mbps
# 1000M的理论传输时间: 1000*1024KB/145KBps/60s=117.7Minutes
dd if=/dev/zero of=1024KB_block bs=1M count=1
# 预计: 7s传完
# 实际: Bytes=1048576 BPS=147905 ETA=7.09s

# 假block, 并不实际占用block, 创建速度与内存速度相当
# dd if=/dev/zero of=1000M_fake_block count=0 seek=100000

# 随机生成100w各1k的文件
# seq 1000000 | xargs -i dd if=/dev/zero of={}.dat bs=1024 count=1



# f