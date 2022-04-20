#!/bin/bash

for varName in CLIENTID CLIENTSECRET DOCKER_REGISTRY_SERVER; do
    varVal=$(eval echo "\${$varName}")
    [[ -z $varVal ]] && {
        echo "💥 Error! Required variable '$varName' is not set!"
        varUnset=true
    }
done

export DOCKERCONFIGJSON=$(echo '{"auths":{"'$DOCKER_REGISTRY_SERVER'":{"username":"'$CLIENTID'","password":"'$CLIENTSECRET'","auth":"'$(echo -n $CLIENTID:$CLIENTSECRET | base64)'"}}}' | base64 --wrap=0)
envsubst <./secret.template.yaml >../kustomize/secret.yaml
sops --encrypt --in-place ../kustomize/secret.yaml

# git add ../kustomize/secret.yaml
# git commit -m "Updated secret by script $(date)"
# git push
