# On working
# Activation du RBAC (Role Base Acces Controle)

~~~bash
microk8s enable rbac


openssl req -new -nodes -newkey rsa:2048 -sha256 -keyout k8s_jean.key -out k8s_jean.csr -subj "/C=FR/ST=France/L=Paris/O=Administrateurs/O=Exploitants/O=Developpeurs/emailAddress=jean@gmail.com/OU=JObjects/CN=jean"
openssl req -new -key jean.key -out jean.csr -subj "/CN=jean/O=$group1/O=$group2/O=$group3"

openssl x509 -req -in k8s_jean.csr \
  -CA /var/snap/microk8s/current/certs/ca.crt \
  -CAkey /var/snap/microk8s/current/certs/ca.key \
  -CAcreateserial \
  -out k8s_jean.crt -days 365

microk8s config

~~~

Sources :
- https://www.adaltas.com/en/2019/08/07/users-rbac-kubernetes/
https://tutorialedge.net/golang/executing-system-commands-with-golang/
https://laiyuanyuan-sg.medium.com/build-a-kubectl-plugin-from-scratch-34daa9de15fd

(
  set -x; cd "$(mktemp -d)" &&  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&tar zxvf krew.tar.gz && KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" && "$KREW" install krew
)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"