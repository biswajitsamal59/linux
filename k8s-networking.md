# Networking
## POD Network:
CNI(invoked by Kubelet) is responsible for assiging IP to the POD where as kube-proxy is for Services. <br />
When CNI is configued you can find the deatils in below path: <br />
``` ls /opt/cni/bin/ ``` Node path where all the CNI plugin binaries are stored. <br />
``` ls /etc/cni/net.d/ ``` CNI Config file path. <br />
``` k run busybox --image=busybox --dry-run=client -o yaml -- sleep 1000 > busybox.yml ``` <br />
``` kubectl exec -it busybox -- route ``` <br />
Note: The default kubenet plugin does not run as daemonset. But other thrird party CNI like Weave, AzureCNI create a ds. <br />
To check the IP range (POD CIDR) used by your CNI you can inspect the logs of the CNI pod. <br />
``` kubectl logs -n kube-system weave-net-835463fg ``` <br />

## Service Network:
A pod is hosted on a node, while a service is hosted across the cluster. It's not bound to a specific node. <br />
Service types: ClusterIP, NodePort and LoadBalancer. <br />
ClusterIP Service is only available only inside cluster. <br />
NodePort Service also get an private IP like ClusterIP svc, which is used for internal pod communication. In addition it also exposes the application on a PORT on all nodes in the cluster so that external users can access svc. <br />
Services get IP from service CIDR range which is configured in kube-api-server. <br />
POD CIDR and Service CIDR shouldn't overlap. <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/9c4efa93-4c84-4ba1-a552-2f4e2766af40)
On each node Kubelet invoke CNI plugin to configure networking of the pod. <br />
Similarly each node run another component called Kube-Proxy. <br />
Kube-Proxy watches the changes in cluster through Kube-apiserver. And everytime a new service to be created, kube-proxy gets into action. <br />
Unlike POD, Services are not assigned to any node. These are cluster wide concept. <br />
PODs have containers, which has n/w namespaces with interfaces and IPs assigned to those interfaces. <br />
But for services there are no processes or namespaces or interfaces. It's just a virtual object. So then how svc get IP? <br />
  - When we a create svc obj in k8s it is assigned an IP from pre-defined range (service CIDR). <br />
  - Kube-proxy running on each node, gets that IP and creates forwarding rule on each node in the cluster. <br />
  - Kube-proxy supports different **proxy-modes**(userspace or ipvs or iptables) to create forwarding rule. **iptables** is the default option. <br />
  - We can set proxy-mode while configuring kube-proxy service. ``` kube-proxy --proxy-mode [userspace | iptables | ipvs] ... ``` <br />
  - Iptables creates a DNAT rule to forward the traffic. <br />
  ``` iptables -L -t nat | grep db-service ``` <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/189f412f-0522-44b5-962f-82234e63d757)
![image](https://github.com/biswajitsamal59/linux/assets/61880328/8dc542d0-81f2-4640-b9d7-49bf851b74d8)
Kube-proxy also creates these forwarding entries in it's logs as well. <br />
``` cat /var/log/kube-proxy.log ``` <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/bb1d5d65-f253-4cd6-b461-e046b9e7da16)

