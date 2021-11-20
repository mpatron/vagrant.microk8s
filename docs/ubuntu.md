# Fabrication d'un pod de test sous Ubuntu

## Création du yaml et lancement du deploiement

~~~bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  namespace: iam
  name: ubuntu
  labels:
    app: ubuntu
spec:
  hostname: ubuntu
  containers:
  - name: ubuntu
    image: ubuntu:latest
    command: ["/bin/sleep", "3650d"]
    imagePullPolicy: IfNotPresent
  restartPolicy: Always
EOF
~~~

## Accès au pod

~~~bash
kubectl exec --namespace iam --stdin --tty ubuntu -- /bin/bash
apt update
DEBIAN_FRONTEND=noninteractive apt install -y dnsutils iputils-ping
TZ=Europe/Paris
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
nslookup kubernetes.default
~~~

~~~bash
apt install -y python3 python3-pip
pip3 install boto3
~~~

~~~python
import boto3
ACCESS_ID = '123456789=='
ACCESS_KEY= '987654321'
# boto3.set_stream_logger('botocore', level='DEBUG')
s3 = boto3.resource('s3',
    aws_access_key_id=ACCESS_ID,
    aws_secret_access_key= ACCESS_KEY,
    endpoint_url='http://minio.iam.svc.cluster.local:9000', 
    config=boto3.session.Config(signature_version='s3v4')
)
for bucket in s3.buckets.all():
    print(bucket.name)
    for my_bucket_object in bucket.objects.all():
        print(my_bucket_object)
~~~
