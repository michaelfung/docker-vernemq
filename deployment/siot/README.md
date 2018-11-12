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


## expose the ports to the world

Use NodePort so that we can test easily from outside by a port forwarding rule, or IP mapping:

    kubectl expose pod vmq-siot --type NodePort --target-port=8885 --name=vmq-mqtt-ssl
    kubectl expose pod vmq-siot --type NodePort --target-port=8888 --name=vmq-metrics

Read the assigned ports:

    kubectl get services | grep vmq
    vmq-metrics    NodePort    10.43.85.243    <none>        8888:31608/TCP   11m
    vmq-mqtt-ssl   NodePort    10.43.30.174    <none>        8885:32389/TCP   12m

Test it using Node's address (e.g. ros-node3.lan):

    curl -q "http://ros-node3.lan:31608/metrics"

Test it using cluster address (must test from inside cluster):

    curl -q "http://vmq-metrics:8888/metrics"
