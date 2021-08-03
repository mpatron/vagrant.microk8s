# Metallb avec microk8s

Kubernetes n'expose pas ses reseaux internes. Afin de ne pas utiliser proxyport qui n'est pas d'usage souple. Metallb, lui, permet d'exposer les IP des services de façon simple quand le kubernetes est installé sur des VM ou en barre metal.
Liste des fichiers en version version 0.10.2 au 2 aout 2021.

## Installation à la main

Source :
<https://github.com/metallb/metallb/blob/v0.10.2/manifests/metallb.yaml>

~~~bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
~~~

## Installation avec helm

~~~bash
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -f metallb_values.yml
~~~

~~~bash
vagrant@master:~$ cat metallb_values.yml
configInline:
  address-pools:
   - name: default
     protocol: layer2
     addresses:
     - 192.168.56.210-192.168.56.230
~~~

~~~bash
vagrant@master:~$ helm repo add metallb https://metallb.github.io/metallb
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /var/snap/microk8s/2346/credentials/client.config
"metallb" has been added to your repositories
~~~

~~~bash
vagrant@master:~$ helm install metallb metallb/metallb -f metallb_values.yml
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /var/snap/microk8s/2346/credentials/client.config
W0803 08:08:41.966149   99039 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0803 08:08:41.979634   99039 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0803 08:08:42.375934   99039 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0803 08:08:42.435406   99039 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
NAME: metallb
LAST DEPLOYED: Tue Aug  3 08:08:40 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
MetalLB is now running in the cluster.
LoadBalancer Services in your cluster are now available on the IPs you
defined in MetalLB's configuration:

config:
  address-pools:
  - addresses:
    - 192.168.56.210-192.168.56.230
    name: default
    protocol: layer2

To see IP assignments, try `kubectl get services`.
~~~

## Test avec nginx

~~~bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/tutorial-2.yaml
~~~

~~~powershell
vagrant@master:~$ curl http://192.168.56.210
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
~~~
