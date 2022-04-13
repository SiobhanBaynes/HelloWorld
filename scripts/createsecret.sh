#!/bin/bash

for varName in CLIENTID CLIENTSECRET; do
    varVal=$(eval echo "\${$varName}")
    [[ -z $varVal ]] && {
        echo "💥 Error! Required variable '$varName' is not set!"
        varUnset=true
    }
done

envsubst <./secret.template.yaml >../kustomize/secret.yaml
sops --encrypt --in-place ../kustomize/secret.yaml

git add ../kustomize/secret.yaml
git commit -m "Updated secret by script $(date)"
git push
