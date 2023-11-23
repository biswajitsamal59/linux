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
``` ip link add v-net-0 type bridge ```  Create internal bridge network or switch by adding a new interface to host with type **bridge**. <br />
``` ip link set dev v-net-0 up ``` v-net-0 will act as an interface to host and switch for the namespaces. <br />
