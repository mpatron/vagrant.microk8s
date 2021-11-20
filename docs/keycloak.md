# Installation de keycloak sur Kubernetes

Avant tout installer OperatorHub.io
https://operatorhub.io/how-to-install-an-operator
kubectl create -f https://raw.githubusercontent.com/operator-framework/operator-lifecycle-manager/master/deploy/upstream/quickstart/olm.yaml

Puis keycloak :
https://www.keycloak.org/getting-started/getting-started-operator-kubernetes
kubectl create -f https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/operator-examples/mykeycloak.yaml

Liste des versions de keycloak (15.0.2 au 20 aout 2021) :
https://github.com/keycloak/keycloak-operator/tags
https://github.com/keycloak/keycloak-quickstarts/tags

Exemple de opérator
https://github.com/keycloak/keycloak-quickstarts/tree/latest/operator-examples

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm show values bitnami/keycloak > keycloak-values-5.0.7-origin.yaml
cp keycloak-values-5.0.7-origin.yaml keycloak-values.yaml

kubectl create namespace iam
helm install keycloak bitnami/keycloak --namespace iam

1. Get the Keycloak URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        You can watch its status by running 'kubectl get --namespace iam svc -w keycloak'

    export SERVICE_PORT=$(kubectl get --namespace iam -o jsonpath="{.spec.ports[0].port}" services keycloak)
    export SERVICE_IP=$(kubectl get svc --namespace iam keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "http://${SERVICE_IP}:${SERVICE_PORT}/auth"

2. Access Keycloak using the obtained URL.
3. Access the Administration Console using the following credentials:

  echo Username: user
  echo Password: $(kubectl get secret --namespace iam keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)


kubectl apply -f https://raw.githubusercontent.com/ansible/awx-operator/0.15.0/deploy/awx-operator.yaml
https://github.com/ansible/awx-operator/tags
https://github.com/ansible/awx-operator/tree/0.15.0#basic-install


~~~bash
git clone https://github.com/ansible/awx-operator.git
cd awx-operator/
git checkout tags/<tag> -b <new-branch-name>
git checkout tags/0.15.0 -b 0.15.0
export NAMESPACE=<namespace-name>
make deploy

kubectl get pods -n $NAMESPACE

vagrant@master:~$ cd awx-operator/
vagrant@master:~/awx-operator$ git checkout tags/0.15.0 -b 0.15.0
Switched to a new branch '0.15.0'
vagrant@master:~/awx-operator$ export NAMESPACE=iam
vagrant@master:~/awx-operator$ make deploy
cd config/manager && /home/vagrant/awx-operator/bin/kustomize edit set image controller=quay.io/ansible/awx-operator:0.15.0
cd config/default && /home/vagrant/awx-operator/bin/kustomize edit set namespace iam
/home/vagrant/awx-operator/bin/kustomize build config/default | kubectl apply -f -
Warning: resource namespaces/iam is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
namespace/iam configured
customresourcedefinition.apiextensions.k8s.io/awxbackups.awx.ansible.com created
customresourcedefinition.apiextensions.k8s.io/awxrestores.awx.ansible.com created
customresourcedefinition.apiextensions.k8s.io/awxs.awx.ansible.com created
serviceaccount/awx-operator-controller-manager created
role.rbac.authorization.k8s.io/awx-operator-awx-manager-role created
role.rbac.authorization.k8s.io/awx-operator-leader-election-role created
clusterrole.rbac.authorization.k8s.io/awx-operator-metrics-reader created
clusterrole.rbac.authorization.k8s.io/awx-operator-proxy-role created
rolebinding.rbac.authorization.k8s.io/awx-operator-awx-manager-rolebinding created
rolebinding.rbac.authorization.k8s.io/awx-operator-leader-election-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/awx-operator-proxy-rolebinding created
configmap/awx-operator-awx-manager-config created
service/awx-operator-controller-manager-metrics-service created
deployment.apps/awx-operator-controller-manager created
vagrant@master:~/awx-operator$ kubectl get pods -n $NAMESPACE
NAME                                               READY   STATUS              RESTARTS   AGE
keycloak-postgresql-0                              1/1     Running             0          35m
keycloak-0                                         1/1     Running             0          35m
awx-operator-controller-manager-647f4c5c7d-qr2m4   0/2     ContainerCreating   0          44s
vagrant@master:~/awx-operator$
~~~

~~~bash
cat <<EOF | kubectl apply -f -
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
spec:
  service_type: LoadBalancer
EOF
~~~

~~~bash
kubectl get pods,services -l "app.kubernetes.io/managed-by=awx-operator" --all-namespaces
kubectl get secret ansible-awx-admin-password -o jsonpath="{.data.password}" | base64 --decode
~~~

https://www.linuxtechi.com/install-ansible-awx-kubernetes-minikube/
