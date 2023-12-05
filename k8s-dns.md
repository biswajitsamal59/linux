# Service DNS
When a service is created, the kubernetes dns service (CoreDNS) creates a record for the SVC. <br />
  - It maps the svc name to it's IP. **(HOSTNAME)** <br />
  - For each k8s namespace, DNS server creates a sub-domain. **(NAMESPACE)** <br />
  - All the SVCs are further grouped together into another sub-domain called **svc**. **(TYPE)** <br />
  - Finally all the services and pods grouped together into root domain called **cluster.local**. **(ROOT)** <br />
So the FQDN for a service is: ```**(service-name).(namespace-name).svc.cluster.local**``` <br />

# POD DNS
DNS Records for PODs are not created by default. But it can be enabled. <br />
Unlike Service DNS, it doesn't use Pod name. It replaces the dot(.) in IP address of pod with hypen(-).  <br />
FQDN for a POD is: ```**(10-244-2-5).(namespace-name).pod.cluster.local**``` <br />
![image](https://github.com/biswajitsamal59/linux/assets/61880328/4320870b-a103-440f-942d-e51c4e69baec)

