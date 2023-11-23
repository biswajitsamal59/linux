# Switch and Network Interface:
In a network we connect two computers we need a **Switch**. <br />
To connect a computer to a switch we need an **Network Interface Device** on the host(computer), physical or virtual depending on host. <br />
``` ip link ``` Show all the available interface info on a host. <br />
``` ip link show dev eth0 ```  Show information only for eth0 network interface device. <br />
``` ip addr add 192.168.1.10 dev eth0 ``` Add an IP address to the specified network interface device(eth0). <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/25183196-e479-4954-9ed5-d95e15c238f5)
**Note: The switch can only enable communication within a network** <br />

# Router and Gateway:
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

# DNS:
In a local linux machine we can resolve a Domain Name to IP mapping by adding entry in hosts file. <br />
``` cat /etc/hosts ``` <br />
Translating hostname to IP address is know as **Name Resolution** <br />
We can modify DNS server for a machine by adding nameserver entry in rersolv.conf file. <br />
``` cat /etc/resolv.conf ```
``` nameserver 172.54.144.1 ```

Host machine first use /etc/hosts file then DNS nameserver for name resolution. <br />
This sequence can be changed in /etc/nsswitch.conf. <br />

``` cat /etc/nsswitch.conf ```
``` hosts: files dns ``` files refers to /etc/hosts and dns to DNS Server. <br />

``` cat >> /etc/resolv.conf ```
``` search biswajit.com ``` If you want append a domain name you can add **search** entry in resolv.conf. <br />
``` ping mail ``` Now this resolve to mail.biswajit.com <br />

``` cat >>> /etc/resolv.conf ```
``` nameserver 8.8.8.8 ``` 8.8.8.8 is a public nameserver hosted by google and knows about all the websites. <br />

**Note: nslookup and dig can be used to test DNS resolution. But both don't use /etc/hosts file for lookup instead use DNS server. <br />**
You can configure a linux machine as a DNS server by using DNS server solutions like CoreDNS. <br />
DNS Server by default listens on port 53. <br />

# Other K8S troubleshoot commands
To display active network connections and listening ports
``` netstat -nplt ``` OR <br />
``` ss -nplt ``` **ss** (socket statistics), is successor of **netstat** and is recommended for more modern systems
To display all active network connections and listening ports of etcd
``` netstat -anp | grep etcd ```
``` ss -tunp | grep etcd ```
