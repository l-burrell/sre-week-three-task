#!/bin/bash

namespace="sre"
deployment="swype-app"
maximum_restarts_allowed=3

while true; do
    # check that the pod restarts:
    number_of_restarts=$(kubectl get pods --namespace "${namespace}" -l app="${deployment}" -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

    # display the number of restarts we have done:
    echo "total number of restarts: $number_of_restarts"

    # check restart limit:
    if (( number_of_restarts > maximum_restarts_allowed )); then 
        echo "No remaining restarts. Slowing down the deployment"
        kubectl scale --replicas=0 deployment/"${deployment}"
        break
    fi

    # pause the deployment for 60 seconds
    sleep 60
done
