# Service DNS
When a service is created, the kubernetes dns service (CoreDNS) creates a record for the SVC. <br />
  - It maps the svc name to it's IP. **(HOSTNAME)** <br />
  - For each k8s namespace, DNS server creates a sub-domain. **(NAMESPACE)** <br />
  - All the SVCs are further grouped together into another sub-domain called **svc**. **(TYPE)** <br />
  - Finally all the services and pods grouped together into root domain called **cluster.local**. **(ROOT)** <br />
So the FQDN for a service is: ```(service-name).(namespace-name).svc.cluster.local``` <br />

# POD DNS
DNS Records for PODs are not created by default. But it can be enabled. <br />
Unlike Service DNS, it doesn't use Pod name. It replaces the dot(.) in IP address of pod with hypen(-).  <br />
FQDN for a POD is: ```(10-244-2-5).(namespace-name).pod.cluster.local``` <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/4320870b-a103-440f-942d-e51c4e69baec)

# DNS Server (CoreDNS)
Prior to v1.12 the DNS Server implemented by Kubernetes was known as **kube-dns** but after that it's **CodeDNS**. <br />
CoreDNS is deployed as a Pod in the kube-system namespace in k8s cluster. <br />
CoreDNS pod require a configuration file (most of the cases it's named as Corefile). Inside pod it located in ``` cat /etc/coredns/Corefile ``` <br />
  - Within the config file, number of plugins (errors, health, kubernetes, cache etc.) are configured. <br />
  - Plugin that makes CoreDNS work with k8s is **kubernetes** plugin. That's where the top level or root domain name (i.e. **cluster.local**) is set. <br />
  - Any record that DNS server can't solve (i.e. if a pod is trying to reach www.google.com) it is forwarded to the **nameserver** configured in **CoreDNS pod's /etc/resolv.conf** file. <br />
  - CoreDNS pod's /etc/resolv.conf file is set to use the nameserver from kubernetes node. <br />
This Corefile is passed in to the CoreDNS pod as a configmap (name: coredns) object. <br />
So you can modify the configuration by modifying coredns configmap. <br />
When CoreDNS is deployed, it also creates a svc to make it available to other components in the cluster. (default svc name: kube-dns) <br />
The IP address of CoreDNS service is configured as nameserver on Pods. <br />
The DNS configuration in POD is done automatically with help of kubelet when the pods are created. <br />
You can check the kubelet config ``` cat /var/lib/kubelet/config.yaml ```. Check for clusterDNS entry. <br />
