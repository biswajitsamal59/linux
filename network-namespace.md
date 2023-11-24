![image](https://github.com/biswajitsamal59/linux/assets/61880328/cd1b8712-4f73-4d45-920c-40da3f0d4401)

# Network Namespace
In a host machine we have Network Interface (eth0), Routing Table and APR table. <br />
We want to seal all the host network info from container. <br />
When a container is created it creates a **network namespace**, that way it it has no visibility to any network related info on host. <br />
With the namespace container can have it's own virtual interfaces (veth0), Routing and APR tables. <br />
Steps to create network namespace manually on Linux without container: <br />
``` ip netns add red ``` Create network namespace <br />
``` ip netns add blue ``` <br />
``` ip netns ``` List network namespace <br />
``` ip netns exec red ip link ``` Run ip link command inside red namespace. OR <br />
``` ip -n red link ``` <br />
``` ip netns exec red arp ``` List ARP table inside red namespace <br />
``` ip netns exec red route ``` <br />

# Create connectlivity between network namespaces in a Host
To create connectivity you need to create a virtual network inside Host. <br />
To create virtual network you need a virtual switch. <br />
So create a virtual switch within Host and connect namespaces to it. <br />
You can use **Linux Bridge** or **Open vSwitch** to create virtual switch. (We will use Linux Bridge) <br />
``` ip link add v-eth-0 type bridge ```  Create internal bridge network or switch by adding a new interface to host **(link type bridge)**. <br />
``` ip link set dev v-eth-0 up ``` v-eth-0 will act as an interface to host and switch for the namespaces. <br />

``` ip link add veth-red type veth peer name veth-red-br ``` Create a **pipe** or cable to connect red namespace to v-net-0 bridge **(link type: veth)**. <br />
``` ip link add veth-blue type veth peer name veth-blue-br ``` <br />

``` ip link set veth-red netns red ``` Attach the cabel one end to red namespace. <br />
``` ip link set veth-red-br master v-eth-0 ``` Attach the other end of the cable to bridge network using master. <br />
``` ip link set veth-blue netns blue ``` <br />
``` ip link set veth-blue-br master v-eth-0 ``` <br />

``` ip -n red addr add 192.168.15.1/24 dev veth-red ``` Add IP address to red namespace link. <br />
``` ip -n blue addr add 192.168.15.2/24 dev veth-blue ``` <br />

``` ip -n red link set veth-red up ``` Up the red namespace interface. <br />
``` ip -n blue link set veth-blue up ``` <br />
``` ip link set veth-red-br up ``` <br />
``` ip link set veth-blue-br up ``` <br />
``` ip netns exec red ping 192.168.15.2 ``` Test connectivity between red and blue namespace. <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/e0447766-a6af-4be5-b365-479effbcc598)

# Create connectivity between network namespaces and the Host
By default ping from host to red namespace will not work (try ``` ping 192.168.15.1 ``` from host). <br />
But the bridge swithch v-eth-0 is network interface for host. <br />
So we have an interface on 192.168.15.0/24 network on our host. And we can assign an IP to it. <br />
``` ip addr add 192.168.15.5/24 dev v-eth-0 ``` <br />
Now we can ping red namespace from our host. <br />

# Create connectivity between network namespaces and outside world
![image](https://github.com/biswajitsamal59/linux/assets/61880328/75a6e57c-c442-4a6e-b077-e9ae9b21c279)
(UseCase: Blue namespace: 192.168.15.2/24 --> HostMachine: 192.168.1.2/24 --> ClientMachine: 192.168.1.3/24) <br />
Add route in blue namespace to reach the clientmachine which is in 192.168.1.0/24 network via it's gateway v-eth-0 (192.168.15.5/24) <br />
``` ip netns exec blue ip route add 192.168.1.0/24 via 192.168.15.5 ``` <br />
Our Host has two IP addresses: One in bridge network 192.168.15.5 and another in external network 192.168.1.2 <br />
Still ClientMachine will not be able to reach back to Blue namespace as it's a private network that ClientMachine don't know about. <br />
For this we need to enable NAT in our host machine, so that it will send trafic to ClientMachine with it's own address. <br />
``` iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUERADE ``` <br />
You can add default route in blue namespace if you want to reach any other network which is accessible by Host. <br />
``` ip netns exec blue ip route add default via 192.168.15.5 ``` <br />

If ClientMachine wants to talk to Blue namespace: <br />
We can add route in ClientMachine to connect to 192.168.15.0/24 via Host IP (192.168.1.2). **OR** <br />
We can use port forwarding in the Host machine. <br />
``` iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.15.2:80 ``` <br />

