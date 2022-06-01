# API-exercise

## Technologies/Tools and Frameworks

* *Programming Language - Framework*: Python3.8 - Flask
* *Database* : RDBMS - PostgreSQL
* *Containerization*: Docker
* *Version Control System*: Gitlab
* *Automation Server*: Gitlab CI
* *Chart Museum*: Github Page 
* *Secret Management*: Hashicorp Vault (Unf. , Vault Agent Not Injecting Secrets Yet)
* *Automation*: Bash


## Setup

### Prerequisities
* *jq* : Used for Parsing Hashicorp Vault Credentials
* *docker & docker-compose* : Used for Local Docker Compose Testing
* *helm & kubectl* : Used for for Kubernetes Vault and Application Deployments

# Bash (with Vault Setup)

```
sh setup.sh
```

### Helm Chart

```
helm repo add chart-museum https://muhammedsaidkaya.github.io/chart-museum-test
helm repo update
helm upgrade --install titanic chart-museum/titanic --set serviceAccount.name=titanic-sa
```




##  Setup & fill database 

* By copying a script to the 'docker-entrypoint-initdb.d' path in postgres docker image, I ensured whenever postgres was started scripts would be run and our tables and dummy data were going to be created.

  * COPY init-database.sh /docker-entrypoint-initdb.d/
  * COPY titanic.csv /docker-entrypoint-initdb.d/


## Continous Integration

* To be able to face with the problems quickly, Git Hooks(Pre-commit) were used and Shift Left Principle was applied.

### Git Hooks
* Git Hooks: Pre-commit
  * Check-yaml 
  * Flake8 for Python Codes
  * trailing-whitespace
  * check-executables-have-shebangs

```
pip3 install pre-commit
pre-commit install
```

### Gitlab CI
* Flake8
* Helm Linting for Charts
* Docker Build and Push to Dockerhub
* Trivy - Image Scan
* Helm Package and Push to Chart Museum(Github Pages)



## Deployment

### Docker-Compose Installation

```
docker-compose up --build -d
```

### HELM Installation

* Created Helm CHart Museum on Github with Github Pages

```
helm repo add chart-museum https://muhammedsaidkaya.github.io/chart-museum-test
helm repo update
helm upgrade --install titanic chart-museum/titanic
```

## Secret Management - Hashicorp Vault

* For Secret Management, I tried to use Vault instead of Kubernetes' own Secret and Config resources. Vault was setup in a correct way. But the problem is Vault-Agent-Injector is not injecting the file that includes PostgreSQL Database DB Connection Credentials to the Titanic Api Kubernetes Deployment with the below code block.

```
  annotations:
    vault.hashicorp.com/agent-inject: 'true'
    vault.hashicorp.com/role: 'titanic-role'
    vault.hashicorp.com/agent-inject-secret-database-config.txt: 'titanic/data/database/config'
    vault.hashicorp.com/agent-inject-template-database-config.txt: |
      {{`{{- with secret "titanic/data/database/config" -}}
      {{ range $k, $v := .Data.data }}
        export {{ $k }}={{ $v }}
      {{ end }}
      {{- end -}}`}}
```

* As a result, I created secrets as Environment variables in Container Templates.

```
  env:
  - name: POSTGRES_DB
    value: postgres
  - name: POSTGRES_USER
    value: user
  - name: POSTGRES_PASSWORD
    value: password
  - name: POSTGRES_HOST
    value: titanic-db
```

