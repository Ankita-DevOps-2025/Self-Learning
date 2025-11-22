# Deploying GitHub Action Runners with dind-rootless By custome image

# Links
========
# Deploying GitHub Action Runners on GKE with dind-rootless 
=> https://medium.com/google-cloud/github-action-runners-on-gke-with-dind-rootless-bd54e23516c9
# Actions Runner Controller 
=> https://docs.github.com/en/actions/concepts/runners/actions-runner-controller
# Action/runner Dockerfile 
=> https://github.com/actions/runner/blob/main/images/Dockerfile


# Steps 
========
1. Create Dockerfile

2. Create image from Dockerfile
=> docker build -t my-runner-image:latest .
=> docker tag my-runner-image:latest <YOUR_REGISTRY>/my-runner-image:latest
=> docker push <YOUR_REGISTRY>/my-runner-image:latest

3. Download helm chart  -> 1. gha-runner-scale-set  2. gha-runner-scale-set-controller  
=> helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
=> helm repo update
=> helm pull actions-runner-controller/gha-runner-scale-set --untar
=> helm pull actions-runner-controller/gha-runner-scale-set-controller --untar
=> 

4. create namespace in k8s
=> kubectl create namespace arc-runners

5. create required secrets in that namespcae 
=> kubectl create secret generic controller-manager \
  --namespace arc-runners \
  --from-literal=github_app_id=<GITHUB_APP_ID> \
  --from-literal=github_app_installation_id=<GITHUB_INSTALLATION_ID> \
  --from-literal=github_app_private_key="$(cat private-key.pem)"
or
=> kubectl create secret generic controller-manager \
  --namespace arc-runners \
  --from-literal=github_token=<YOUR_GITHUB_PAT>
                    
6. Install gha-runner-scale-set-controller without any changes in that namespace 
=> helm install arc-controller actions-runner-controller/gha-runner-scale-set-controller \
  --namespace arc-runners

7. Install gha-runner-scale-set with updated values of values.yaml in that namespace
=> helm install arc-runner-set actions-runner-controller/gha-runner-scale-set \
  --namespace arc-runners \
  -f values.yaml

8. Verify Installation
=> kubectl get pods -n arc-runners
=> helm list -n arc-runners

