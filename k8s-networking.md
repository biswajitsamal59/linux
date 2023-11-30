# Networking
## POD Network:
CNI is responsible for assiging IP to the POD where as kube-proxy is for Services. <br />
When CNI is configued you can find the deatils in below path: <br />
``` ls /opt/cni/bin/ ``` Node path where all the CNI plugin binaries are stored. <br />
``` ls /etc/cni/net.d/ ``` CNI Config file path. <br />
``` k run busybox --image=busybox --dry-run=client -o yaml -- sleep 1000 > busybox.yml ``` <br />
``` kubectl exec -it busybox -- route ``` <br />
Note: The default kubenet plugin does not run as daemonset. But other thrird party CNI like Weave, AzureCNI create a ds. <br />
To check the IP range used by your CNI you can inspect the logs of the CNI pod. <br />
``` kubectl logs -n kube-system weave-net-835463fg ``` <br />

## Service Network:
While a pod is hosted on a node, while a service is hosted across the cluster. It's not bound to a specific node. <br />
Service types: ClusterIP, NodePort and LoadBalancer. <br />
ClusterIP Service is only available only inside cluster. <br />
NodePort Service also get an private IP like ClusterIP svc, which is used for internal pod communication. In addition it also exposes the application on a PORT on all nodes in the cluster so that external users can access svc. <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/9c4efa93-4c84-4ba1-a552-2f4e2766af40)

