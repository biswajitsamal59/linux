# Switch and Network Interface
In a network we connect two computers we need a **Switch**. <br />
To connect a computer to a switch we need an **Network Interface Device** on the host(computer), physical or virtual depending on host. <br />
``` ip link ``` Show all the available interface info on a host. <br />
``` ip link show dev eth0 ```  Show information only for eth0 network interface device. <br />
``` ip addr add 192.168.1.10 dev eth0 ``` Add an IP address to the specified network interface device(eth0). <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/25183196-e479-4954-9ed5-d95e15c238f5)
**Note: The switch can only enable communication within a network** <br />

# Router and Gateway
**Router** helps to connect two network together. <br />
You need to configure **Route** using **Gateway**. <br />
Routing needs to be configured in each system. <br />
``` ip route ``` Show the route table. <br />
``` ip route add 192.168.2.0/24 via 192.168.1.1 ``` If System B wants to talk to System C. You can configure below route on System B. <br />
``` ip route add 192.168.1.0/24 via 192.168.2.1 ``` Configure on System C to talk to System B. <br />
``` ip route add default via 192.168.2.1 ``` Configure a **default gateway** i.e. for any other destination ip use 192.168.2.1 as gateway. **(default=0.0.0.0)** <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/ff6b0a65-b582-4cb3-b517-e237fdaccff2)
**Note: If you want to use linux machine as a router, then IP Forwarding needs to be enabled on the system** <br />
By default in a Linux system packets are not forwarded from one n/w interface to other.
``` cat /proc/sys/net/ipv4/ip_forward ``` By default it's set to 0. <br />
``` echo 1 > /proc/sys/net/ipv4/ip_forward ``` To set packet forwarding temporarily. Will not persists on system restart. <br />
``` /etc/sysctl.conf ``` Set **net.ipv4.ip_forward=1** to enable packet forwarding for IPv4. Will persist on system restart. <br />
