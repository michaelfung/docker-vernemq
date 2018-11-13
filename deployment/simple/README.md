# Simple deployment with kubernetes

Deploy a single VerneMQ server. No clustering, no master/slave, no security ...
for anonymous access.

## create configMap

The _vernemq.conf_ is just stock modified to listen on 0.0.0.0:1883 and allow anonymous access.

Run:

    kubectl create configmap vmq-config --from-file=./vernemq.conf --from-file=./vmq.acl

After done, dump it to a yaml file and check it , edit it and use it to recreate the configmap if needed.

    kubectl get configmap vmq-config -o yaml > vmq-config.yaml


## create a Pod with the configMap

Create pod:

    # delete if aleady exists: kubectl delete pod/vmq
    kubectl create -f ./vmq-pod.yaml


Create service for the pod:

    kubectl expose pod vmq --port=1883 --name=mqtt
    kubectl expose pod vmq --port=8888 --name=vmq-metrics
