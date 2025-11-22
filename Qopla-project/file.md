# Steps need to take :

Task: 
1) INstall and configure ALB controller in dev cluster.
2) Deploy one test application with ALB controller 
3) We will migrate backend application from nginx ingress to ALB one


# Execution step

1. Ingress  - it is k8s object which route HTTP request to k8s services (SVC) , for this we can define the rules on host or path base req 

We need controller for this ingress which will controll the ingress

# Deploy ALB controller in EKS

whatever ingress rule we will create ,ALB ingress controller will divert that rules to Application load balancer (ALB) 

1. Deploy ALB controller using Helm 
2. Create IAM policy which give permission to manage Load balancer
3. Create IAM role for Service account which is attach to the ALB ingress controller's service account so that ingress controller pods get the permission to create/delete LB ,create target groups and attach rules , or add SSL certificate and all
4. Attch IAM policy which we created to the IAM role 

- Deploy application using helm

- Deploy ALB ingress controller using helm 

# Trust policy for IAM Role

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::767397973893:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/BAF33361826DEDB146EE69C49A3D2DC"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.ap-south-1.amazonaws.com/id/BAF33361826DEDB146EE69C49A3D2DC:aud": "sts.amazonaws.com",
          "oidc.eks.ap-south-1.amazonaws.com/id/BAF33361826DEDB146EE69C49A3D2DC:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}

here replace it with your - system:serviceaccount:kube-system:aws-load-balancer-controller
system:serviceaccount:namespace:servicenameofaws-load-balancer-controller


-> go to IAM->Roles->create role-> select trusted entity -> web identity
here provider will be - it will of EKS cluster
-> give role name
-> after creating role edit it and past your trust policy from below link
-> https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.2/docs/install/iam_policy.json
-> in role there is option -> add permission -> create inline policy -> json -> past policy from link


===========================

Now using hel install ALB ingress controller in eks and mention it which asume role should it use when it go for creating/updating LB 

helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controtler \
-n namespace \
--set clusterName="clustername", \
--set serviceAccount.creates=true \   
--set serviceAccount.name="aws-load-balancer-controller" \
--set-serviceAccount.annotations.eks|\.amazonaws\\.com/role-arn="arn: aws: iam: :767397973893: role/eks_alb_ingress controller_role

# here 
--set serviceAccount.creates=true \    # it will create SVC for the pod that are created by deployment of ALB controller deployment 

--set serviceAccount.name="aws-load-balancer-controller"  # this name should be same wich we used in trust policy 

--set-serviceAccount.annotations.eks|\.amazonaws\\.com/role-arn="arn: aws: iam: :767397973893: role/eks_alb_ingress controller_role  # ARN of role which we have created

# now we will create ingress using deployment yaml file
-> kubectl get ingressclass
use name of ingressclass which you have created(ALB one) in yaml 

- In annotation we will define will it be internet facing or not , 
which subnet to use (we can also go for tags if don't want to do manually)
using annotation we can define multiple parameter which can be used by ingress

=====================================================================================

### Documentation for Deploying ALB Controller in EKS Cluster

------------------------------------------------------------
Objective:
------------------------------------------------------------
This guide will walk you through the steps required to deploy the AWS Load Balancer (ALB) Ingress Controller in an EKS cluster. This setup will route HTTP(S) traffic to Kubernetes services using an Application Load Balancer (ALB).

------------------------------------------------------------
1. Prerequisites
------------------------------------------------------------
Before starting, ensure the following prerequisites are in place:

- AWS CLI configured with proper permissions.
- kubectl is configured for your EKS cluster.
- Helm 3.x installed.

------------------------------------------------------------
2. Create IAM Policies & Roles
------------------------------------------------------------

Step 2.1: Create IAM Policy for ALB Ingress Controller

The ALB Ingress Controller requires permissions to manage load balancers, target groups, listeners, rules, etc.

1. Download IAM policy:
   - The predefined AWS policy gives ALB controller permissions.
   - Upload this JSON in AWS IAM → Policies → Create Policy.

2. Create IAM Policy:
   - Go to AWS IAM → Policies → Create Policy → JSON.
   - Paste the policy.
   - Name it: ALBIngressControllerPolicy.

------------------------------------------------------------
Step 2.2: Create IAM Role with Trust Policy
------------------------------------------------------------

The IAM role should allow the ALB controller’s Kubernetes service account to assume it.

Trust Policy JSON:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:oidc-provider/oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/YOUR_OIDC_ID"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/YOUR_OIDC_ID:aud": "sts.amazonaws.com",
          "oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/YOUR_OIDC_ID:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}

Steps to create IAM Role:

1. Go to IAM → Roles → Create Role.
2. Select “Web Identity”.
3. Choose the EKS OIDC provider.
4. Select audience sts.amazonaws.com.
5. Name the role: eks-alb-ingress-controller-role.
6. Attach ALBIngressControllerPolicy.
7. Replace trust relationship JSON with the above policy.
8. Create the role.

------------------------------------------------------------
3. Deploy ALB Ingress Controller Using Helm
------------------------------------------------------------

Step 3.1: Add Helm Repo & Install

1. Add EKS charts repository:

helm repo add eks https://aws.github.io/eks-charts
helm repo update

2. Install ALB Ingress Controller:

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
 -n kube-system \
 --set clusterName="your-cluster-name" \
 --set serviceAccount.create=true \
 --set serviceAccount.name="aws-load-balancer-controller" \
 --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/eks-alb-ingress-controller-role"

Notes:
- serviceAccount.create=true → Helm creates the service account.
- serviceAccount.name → Name must match trust policy.
- role-arn → Attach IAM role created earlier.

------------------------------------------------------------
Step 3.2: Verify Installation
------------------------------------------------------------

kubectl get pods -n kube-system

The aws-load-balancer-controller pod must be running.

Ingress Controller should be running as a pod with the name aws-load-balancer-controller.

------------------------------------------------------------
4. Create Ingress Resource
------------------------------------------------------------

Step 4.1: Create Ingress YAML

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  namespace: default
  annotations:
    alb.ingress.kubernetes.
io/scheme: internet-facing
    alb.ingress.kubernetes.io/subnets: subnet-xxxxxxx,subnet-yyyyyyy
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    alb.ingress.kubernetes.io/healthcheck-path: /health
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80

Annotations explanation:
- scheme: internet-facing or internal
- subnets: where ALB is deployed
- target-type: ip or instance
- ssl-redirect: force HTTPS
- healthcheck-path: ALB health check path

------------------------------------------------------------
Step 4.2: Apply Ingress Resource
------------------------------------------------------------

kubectl apply -f my-app-ingress.yaml

This creates the ALB and routes traffic to the service.

------------------------------------------------------------
5. Test the Deployment
------------------------------------------------------------

1. Check ALB in AWS Console → EC2 → Load Balancers.
2. Access via domain defined in Ingress (myapp.example.com).
3. View controller logs:

kubectl logs -n kube-system -l app=aws-load-balancer-controller

------------------------------------------------------------
6. Migrate from Nginx Ingress to ALB Ingress
------------------------------------------------------------

1. Update Ingress class to alb.
2. Remove Nginx Ingress.
3. Validate traffic through ALB.

------------------------------------------------------------
Conclusion
------------------------------------------------------------

You have deployed the AWS ALB Ingress Controller on EKS and configured Kubernetes services to use ALB for HTTP/HTTPS traffic. This setup improves scalability, uses AWS-native load balancing, and simplifies routing for microservices.    