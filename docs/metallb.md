# Metallb avec microk8s

Kubernetes n'expose pas ses reseaux internes. Par defaut, rien n'est accésssible depuis l'exterrieur du kubernetes. Il existe un méthode d'accès avec proxyport mais dans la pratique, on l'active, on la déactive, etc. Pendant la phase de developpement d'un dockerfile ou une application, ça peut devenir saoulant. Alors il y a notre sauveur : Metallb., Il permet d'exposer les IP des services de façon simple quand le kubernetes est installé sur des VM ou en barre metal. En fait, Metallb est le ClusterIP du baree metal ! Et c'est très facile d'usage.
Liste des fichiers en version version 0.10.2 au 2 aout 2021.

## Installation à la main

Source :
<https://github.com/metallb/metallb/blob/v0.10.2/manifests/metallb.yaml>

~~~bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
~~~

## Installation sur microk8s

Vérifier que le host portant microk8s a bien un carte sur la même plage 192.168.56.0/24, par exemple 192.168.56.150.

~~~bash
microk8s enable metallb:192.168.56.190-192.168.56.210
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
vagrant@master:~$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/tutorial-2.yaml
vagrant@master:~$ kubectl get services
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)        AGE
kubernetes   ClusterIP      10.152.183.1     <none>           443/TCP        3h17m
nginx        LoadBalancer   10.152.183.172   192.168.56.190   80:32219/TCP   43s
~~~

Contenu du fichier tutorial-2.yaml

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1
        ports:
        - name: http
          containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
~~~

~~~powershell
vagrant@master:~$ curl http://192.168.56.190
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

## Aller plus loin

Il est peut être utile d'installer un outils permettant d'administrer kubernetes de façon visuel comme portainer. Voici la commande d'installation avec helm :

~~~bash
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm install --create-namespace -n portainer portainer portainer/portainer --set service.type=LoadBalancer
~~~
