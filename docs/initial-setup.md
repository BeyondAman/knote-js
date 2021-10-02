# Demo - Initial Setup

### Prerequisite
- [AWS Account](https://aws.amazon.com/resources/create-account/)
- Access/Secret keys are generated and configured (Ref: [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html))
- Required CLI Tools: [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli), [Kubectl](https://kubernetes.io/docs/tasks/tools/), [Helm](https://helm.sh/docs/intro/install/)


### Step 1: Setup S3 bucket to store terraform state

Update `terraform/01-prerequisite/envs/terraform.tfvars` file to add required bucket name and region.

```bash
$ cd terraform/01-prerequisite/

$ source ./envs/source.rc
$ terraform plan
$ terraform apply
```

### Step 2: Setup cloud services

We would setup following cloud services:
- `DocumentDB`: AWS managed NoSQL database service that supports MongoDB
- `S3 Bucket`: Tu be used by application
- `VPC`: VPC in which EKS
- `EKS`: Kubernetes cluster to deploy frontend, backend application and other services
- `Secret`: creates a secret in secret manager with required db creds and gives EKS access to read those secrets

1. Update bucket name in `terraform/02-project-setup/envs/backend.conf` with the bucket created in `Step 1`
2. Update `terraform/02-project-setup/envs/terraform.tfvars`
NOTE: make sure to provide unused CIDR range for VPC and subnets

```bash
$ cd terraform/02-project-setup/

$ source ./envs/source.rc
$ terraform plan
$ terraform apply
```

#### DocumentDB Backup Strategy
- **Backup Frequency**: Once a day
- **Backup Window**: A random 30 minute slot between 20:00 UTC and 23:00 UTC
- **Retention Period**: 3 days

### Step 3: Deploy required operators/services in cluster

#### Step 3.1: External Secrets

Used to fetch secrets from External Secret Managers like AWS, GCP, Vault, etc. In our case, we are using it to fetch secrets (db credentials) from AWS Secret Manager

[Refer: Setup External Secrets](https://github.com/external-secrets/external-secrets)

**NOTE** make sure to install it in `external-secrets` namespace and use `kubernetes-external-secrets` as service account (as these details were provided by default in terraform while creating IAM role)

#### Step 3.2: Grafana Stack (optional)

For Logging and Monitoring - deploy Loki, Prometheus, Promtail, and Grafana
[Refer: Setup Grafana Stack](https://grafana.github.io/loki/charts/)

#### Step 3.3: ArgoCD

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. We would be using it to manage CD for Backend deployments.

[Refer: Install ArgoCD](https://argo-cd.readthedocs.io/en/stable/getting_started/)

**NOTE**: The default username of the ArgoCD UI would be `admin` and password can be obtained via below-mentioned command:

```bash
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Step 4: Test: Deploy Applications (optional - can be done via CI/CD as well)

#### Deploy Application Stack
Update `./k8/charts/values.prod.yaml` 

Deploy Helm chart:
```bash
$ helm install -f ./k8/charts/values.prod.yaml knote-demo ./k8/charts
```
OR use ArgoCD to deploy changes to custer

Once deployed, get the External Address of Load balancer service:
```bash
$ kubectl get service
NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)        AGE
application-lb       LoadBalancer   172.20.247.41    a47cb6e9ec97a46a6945962e8867af93-918063790.us-west-2.elb.amazonaws.com    80:31586/TCP   2m5s
```

Access application:

```bash
$ curl http://<EXTERNAL-IP>

Example:
$ curl http://a47cb6e9ec97a46a6945962e8867af93-918063790.us-west-2.elb.amazonaws.com/
```
