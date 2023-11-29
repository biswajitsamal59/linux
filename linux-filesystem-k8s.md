# Networking
## POD Network:
When CNI is configued you can find the deatils in below path: <br />
``` ls /opt/cni/bin/ ``` Node path where all the CNI plugin binaries are stored. <br />
``` ls /etc/cni/net.d/ ``` CNI Config file path. <br />
``` k run busybox --image=busybox --dry-run=client -o yaml -- sleep 1000 > busybox.yml ``` <br />
``` kubectl exec -it busybox -- route ``` <br />
CNI is responsible for assiging IP to the POD where as kube-proxy is for Services. <br />
To check the IP range used by your CNI you can inspect the logs of the CNI pod. <br />
``` kubectl logs -n kube-system kubenet-835463fg ``` <br />
