# wecloud_project7

******  Project 7 Infrastructure Provisioning Automation Part 3 ******

Member of the team: 
Luis De Marquez
Prithvi kohli
Sara Siddiqui
Bhargav Dalwadi

# Pre-requisites

aws credentials and account
access to dockerhup
aws cli & ekscli 
terraform installed

This repo has 2 sub directories under the top workdir

Directory EKS-P7  ( terraform environment to create AWS EKS Cluster infrastructure)

Directory manifest  ( kubernetes manifest for a demo web-app react using AWS NLB 
                     image from dockerhub )



***** Prerequisites *****
AWS account and credentials with permissions to access multiple AWS Resources;
Have AWS CLI, eksctl, kubectl, terraform Git installed on your machine;


1.  Create AWS EKS Cluster infrastructure

from top workdir

cd EKS-P7

1.1 Initialize terraform & validate

% terraform version
Terraform v1.5.4
on darwin_amd64

% terraform init   

% terraform validate
Success! The configuration is valid.

1.2 Terraform Plan 

% terraform plan -out aws-eks-infra

the end of the command output will be like this:

Saved the plan to: aws-eks-infra

To perform exactly these actions, run the following command to apply:
    terraform apply "aws-eks-infra"

1.3 Terraform apply 

% terraform apply <planfilename>

% terraform apply aws-eks-infra

Note: this task takes around 15 min

the end of the command output will be like this:

Apply complete! Resources: 63 added, 0 changed, 0 destroyed.

Outputs:

cluster_endpoint = "https://A4CEFEB0656218B1039A1E873B301C01.gr7.us-east-1.eks.amazonaws.com"
cluster_name = "Project7"
cluster_security_group_id = "sg-0d1a981245a1eb6ea"
region = "us-east-1"

1.4 Verify infrastructure created via terraform 

% terraform show 

% terraform stale list 


2.  Configure or Update  kubeconfig for kubectl

List the cluster(s) 

% eksctl get cluster
NAME		REGION		EKSCTL CREATED
Project7	us-east-1	False


Update kubeconfig

aws eks update-kubeconfig --region <region-code> --name <my-cluster>

% aws eks update-kubeconfig --region us-east-1 --name Project7
Updated context arn:aws:eks:us-east-1:081967786944:cluster/Project7 in /Users/ldemarquez/.kube/config

% kubectl cluster-info
Kubernetes control plane is running at https://A4CEFEB0656218B1039A1E873B301C01.gr7.us-east-1.eks.amazonaws.com
CoreDNS is running at https://A4CEFEB0656218B1039A1E873B301C01.gr7.us-east-1.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

% kubectl get namespaces
NAME              STATUS   AGE
default           Active   29m
kube-node-lease   Active   29m
kube-public       Active   29m
kube-system       Active   29m

Note below that the EKS nodes have been created 2 in subnet 10.0.1x and 2 in subnet 10.0.3

% kubectl get nodes -o wide 
NAME                         STATUS   ROLES    AGE   VERSION               INTERNAL-IP   EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                  CONTAINER-RUNTIME
ip-10-0-1-155.ec2.internal   Ready    <none>   24m   v1.27.3-eks-a5565ad   10.0.1.155    <none>        Amazon Linux 2   5.10.184-175.749.amzn2.x86_64   containerd://1.6.19
ip-10-0-1-227.ec2.internal   Ready    <none>   25m   v1.27.3-eks-a5565ad   10.0.1.227    <none>        Amazon Linux 2   5.10.184-175.749.amzn2.x86_64   containerd://1.6.19
ip-10-0-3-117.ec2.internal   Ready    <none>   25m   v1.27.3-eks-a5565ad   10.0.3.117    <none>        Amazon Linux 2   5.10.184-175.749.amzn2.x86_64   containerd://1.6.19
ip-10-0-3-34.ec2.internal    Ready    <none>   25m   v1.27.3-eks-a5565ad   10.0.3.34     <none>        Amazon Linux 2   5.10.184-175.749.amzn2.x86_64   containerd://1.6.19


3. Apply Kubenertes manifest 

comeback to the top working dir

cd ..

3.1 Apply manifest

% kubectl create namespace project7
namespace/project7 created

% kubectl apply -f manifest -n project7 
deployment.apps/web created
service/nlb-web created
service/web created

Verify all resources created in namespace project7

% kubectl get all -n project7
NAME                       READY   STATUS    RESTARTS   AGE
pod/web-7b8d59d597-kr7nq   1/1     Running   0          2m16s
pod/web-7b8d59d597-qc5jz   1/1     Running   0          2m16s
pod/web-7b8d59d597-xkw45   1/1     Running   0          2m16s

NAME              TYPE           CLUSTER-IP       EXTERNAL-IP                                                                     PORT(S)        AGE
service/nlb-web   LoadBalancer   172.20.216.225   aaa5b278a18274bde88f23d150fd8118-b590864d2fd03e45.elb.us-east-1.amazonaws.com   80:32474/TCP   2m17s
service/web       ClusterIP      172.20.239.56    <none>                                                                          80/TCP         2m16s

NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web   3/3     3            3           2m17s

NAME                             DESIRED   CURRENT   READY   AGE
replicaset.apps/web-7b8d59d597   3         3         3       2m17s

3.2  Test Web-App

nslookup the service/nlb-web LoadBalancer aaa5b278a18274bde88f23d150fd8118-b590864d2fd03e45.elb.us-east-1.amazonaws.com

wait 5 minutes and run the cmd:

% nslookup aaa5b278a18274bde88f23d150fd8118-b590864d2fd03e45.elb.us-east-1.amazonaws.com
Server:		2607:f798:18:10:0:640:7125:5204
Address:	2607:f798:18:10:0:640:7125:5204#53

Non-authoritative answer:
Name:	aaa5b278a18274bde88f23d150fd8118-b590864d2fd03e45.elb.us-east-1.amazonaws.com
Address: 44.195.191.130
Name:	aaa5b278a18274bde88f23d150fd8118-b590864d2fd03e45.elb.us-east-1.amazonaws.com
Address: 35.170.204.245
Name:	aaa5b278a18274bde88f23d150fd8118-b590864d2fd03e45.elb.us-east-1.amazonaws.com
Address: 3.222.202.96


Test the NLB in the browser % http://aaa5b278a18274bde88f23d150fd8118-b590864d2fd03e45.elb.us-east-1.amazonaws.com

the frist time takes few minutes until the nlb is fully configured in AWS

4.-  Delete the entire environment

4.1 Delete Kubernetes resources

First Delete all the resources in AWS EKS namespace project7 to be sure the AWS NLB is deleted, if not terraform will failed to delete the AWS EKS infrastructure due to dependencies

from top directory 

% kubectl delete -f manifest -n project7             
deployment.apps "web" deleted
service "nlb-web" deleted
service "web" deleted

verify 

% kubectl delete -f manifest -n project7             
deployment.apps "web" deleted
service "nlb-web" deleted
service "web" deleted

4.2  Delete AWS EKS infrastructure created via terraform 

from top directory

cd EKS-P7

% terraform destroy

<this command will list all resources created to be destryoed>

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

  wait until terraform will destroy all AWs EKS infrastructure

   Warning: EC2 Default Network ACL (acl-00101e9348677f767) not deleted, removing from state
│ 
│ 
╵

Destroy complete! Resources: 63 destroyed.

re run the terraform destroy cmd

 Warning: EC2 Default Network ACL (acl-00101e9348677f767) not deleted, removing from state
│ 
│ 
╵

Destroy complete! Resources: 63 destroyed.

all resources have been deleted



