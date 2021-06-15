# Mise à jour de vagrant

[==> go home](../README.md)

## Installation des plugins pour avoir un accès internet à travers un proxy

~~~bash
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-proxyconf
~~~

## Mise à jour de Vagrant et de ses plugins

~~~cmd
vagrant plugin update
vagrant box add generic/ubuntu2004
vagrant box update
vagrant box prune
vagrant up  --provider=virtualbox --provision
vagrant ssh
~~~
