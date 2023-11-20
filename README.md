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
