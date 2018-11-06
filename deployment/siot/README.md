# Deployment for SIOT

## generate tls cert and key

    Place the cert and key file in ./tls folder

## create secret to hold the cert and key

    # syntax:
    # generic NAME [--type=string] [--from-file=[key=]source] [--from-literal=key1=value1] [--dry-run]

    kubectl create secret generic vmq-tls --from-file=./tls


## create configMap

Run:
    # delete if aleady exists: kubectl delete configmap/vmq-siot-config
    kubectl create configmap vmq-siot-config --from-file=./vernemq-siot.conf --from-file=./vmq.acl

After done, dump it to a yaml file and check it , edit it and use it to recreate the configmap if needed.

    kubectl get configmap vmq-siot-config -o yaml > vmq-siot-config.yaml


## create a Pod with the configMap

Create pod:

    # delete if aleady exists: kubectl delete pod/vmq-siot
    kubectl create -f ./vmq-siot-pod.yaml
