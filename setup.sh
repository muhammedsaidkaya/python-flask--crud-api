#!/bin/bash

#Vault - Helm Installation
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
cat <<EOF > helm-vault-values.yml
server:
  affinity: ""
  ha:
    enabled: false
EOF
helm install vault hashicorp/vault --values helm-vault-values.yml

#Create cluster keys
kubectl exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
VAULT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")


#Unseal Vault operator
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY

#Vault Login
kubectl exec -it vault-0 -- sh -c "vault login $VAULT_TOKEN"

#Enable Secret Path
kubectl exec -it vault-0 -- sh -c "vault secrets enable -path=titanic kv-v2"

#Enable Kubernetes
kubectl exec -it vault-0 -- sh -c "vault auth enable kubernetes"

#Create kubernetes config
kubectl exec -it vault-0 -- sh -c 'vault write auth/kubernetes/config \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
        issuer="https://kubernetes.default.svc.cluster.local"'

#PUT CREDENTIALS
kubectl exec -it vault-0 -- sh -c 'vault kv put titanic/database/config db="postgres" user="user" password="password"'

#CREATE Policy
kubectl exec -it vault-0 -- sh -c 'vault policy write titanic-policy - <<EOF
    path "titanic/data/database/config" {
      capabilities = ["read"]
    }
    EOF'

#CREATE ROLE
kubectl exec -it vault-0 -- sh -c 'vault write auth/kubernetes/role/titanic-role \
        bound_service_account_names=titanic-sa \
        bound_service_account_namespaces=default \
        policies=titanic-policy \
        ttl=24h'


#CREATE SERVICEACCOUNT
kubectl create sa titanic-sa -n default

#TITANIC APP SETUP
helm repo add chart-museum https://muhammedsaidkaya.github.io/chart-museum-test
helm repo update
helm upgrade --install titanic chart-museum/titanic --set serviceAccount.name=titanic-sa