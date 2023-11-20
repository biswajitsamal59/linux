# Switch and Network Interface
In a network we connect two computers we need a **Switch**. <br />
To connect a computer to a switch we need an **Network Interface Device** on the host(computer), physical or virtual depending on host. <br />
``` ip link ``` Show all the available interface info on a host. <br />
``` ip link show dev eth0 ```  Show information only for eth0 network interface device. <br />

![image](https://github.com/biswajitsamal59/linux/assets/61880328/25183196-e479-4954-9ed5-d95e15c238f5)

Add an IP address to the specified network interface device(eth0)
``` ip addr add 192.168.1.10 dev eth0 ```
