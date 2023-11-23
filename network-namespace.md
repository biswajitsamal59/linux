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
![image](https://github.com/biswajitsamal59/linux/assets/61880328/e0447766-a6af-4be5-b365-479effbcc598)

# Create connectivity between network namespaces and the Host
By default ping from host to red namespace will not work (try ``` ping 192.168.15.1 ``` from host). <br />
But the bridge swithch v-eth-0 is network interface for host. <br />
So we have an interface on 192.168.15.0/24 network on our host. And we can assign an IP to it. <br />
``` ip addr add 192.168.15.5/24 dev v-eth-0 ``` <br />
Now we can ping red namespace from our host. <br />
