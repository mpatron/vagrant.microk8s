# General informations

## Quickstart

### Installation

Liens

* [=> Mise à jour de vagrant](docs/mise_a_jour_vagrant.md)
* [=> Fabrication d'une VM vagrant](docs/fabrication_vm_vagrant.md)
* [=> Installation de metallb](docs/metallb.md)

Quick start

~~~powershell
vagrant up  --provider=virtualbox --provision
vagrant ssh
~~~

Exemple d'install de kubernetes :
<https://github.com/kairen/kube-ansible>

Configuration de Git

~~~bash
git config --global user.name "John Doe"
git config --global user.email john.doe@jobjects.org
~~~

Puis entamer la phase de test:

~~~bash
kubectl run nginx-test --image nginxdemos/hello --port 80 --expose
watch kubectl get all --all-namespaces
kubectl logs -f $(kubectl get pods | awk 'NR==2 {print $1}')
kubectl proxy --port=8080 &
curl http://localhost:8080/api/v1/namespaces/default/services/http:nginx-test:/proxy/
fg %1
<Ctrl-C>
kubectl delete deployment nginx-test
kubectl delete service nginx-test
kubectl delete pods nginx-test
~~~

Erreur dans le provisioning, le relancer :

~~~bash
cd /vagrant && PYTHONUNBUFFERED=1 ANSIBLE_NOCOLOR=true ANSIBLE_CONFIG='/vagrant/ansible.cfg' ansible-playbook --limit="all" --inventory-file=inventory.txt --extra-vars=\{\"PROXY_ON\":false,\"PROXY_SERVER\":\"\"\} -v provision.yml
~~~

## Vrac

~~~text
Video expliquant comment utiliser le let'encrypt
old : https://www.youtube.com/watch?v=chwofyGr80c&list=LL&index=1&t=671s
new : https://www.youtube.com/watch?v=UvwtALIb2U8
https://github.com/justmeandopensource/kubernetes
https://github.com/nginxinc/kubernetes-ingress

Putty configuration
"Terminal -> Features" et cochez la case "Disable application keypad mode"
"Terminal -> Keyboard -> "The Function keys and Keypad", il suffit de sélectionner "Linux".

https://linuxize.com/post/how-to-use-linux-screen/
watch kubectl get all -o wide


https://nickjanetakis.com/blog/ngrok-lvhme-nipio-a-trilogy-for-local-development-and-testing
https://medium.com/earlybyte/powerline-for-bash-6d3dd004f6fc

sudo apt install python3-pip
pip3 install --user powerline-status
pip3 install --user powerline-gitstatus

$Env:VAGRANT_DEFAULT_PROVIDER = "virtualbox"

https://github.com/bitnami/charts/tree/master/bitnami/postgresql/#installing-the-chart

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm show values bitnami/postgresql > myvalues.yml
kubectl create namespace myns
helm install --namespace myns --set postgresqlPassword=secretpassword,postgresqlDatabase=mydatabase postgres bitnami/postgresql

export POSTGRES_PASSWORD=$(kubectl get secret --namespace default postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
kubectl run postgres-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:11.8.0-debian-10-r19 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgres-postgresql -U postgres -d mydatabase -p 5432 -c '\l'

~~~
