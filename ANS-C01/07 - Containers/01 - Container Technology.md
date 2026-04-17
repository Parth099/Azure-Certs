# Containers

Briefly explained as I already know this topic.

## Elastic Container Service (ECS)

AWS Cluster Manager for Docker containers. It allows you to run and manage Docker containers on a cluster of EC2 instances. It provides a simple API for deploying and scaling containerized applications, and it integrates with other AWS services such as Elastic Load Balancing, Auto Scaling, and CloudWatch.

There are two modes:

1. farget: serverless compute engine for containers that allows you to run containers without having to manage the underlying infrastructure. Each Task is injected into the VPC and has its own elastic network interface, which means that you can use security groups and network ACLs to control access to your tasks. In reality, you are still running on EC2 instances but, you are sharing with other users.

2. EC2: allows you to run containers on a cluster of EC2 instances that you manage. You specify the number of EC2 instances you want to use, and ECS will manage the deployment and scaling of your containers across those instances (via Auto Scaling Groups) and availability zones.

### Running Application

The minimum unit in ECS is the container definition which describes your image (image URI or ports). You place one or more container definitions into a task definition, which is a blueprint for your application. It can hold things like network configurations and IAM roles.

Now tasks are static. They run your application as you intended it with scaling or availability. To make it dynamic, you can use services. Services allow you to run and maintain a specified number of instances of a task definition simultaneously in an ECS cluster. If any of the tasks fail or stop, the service scheduler will launch another instance of the task definition to replace it, ensuring that the desired number of tasks is always running.

## Elastic Kubernetes Service (EKS)

AWS Cluster Manager for Kubernetes. It allows you to run and manage Kubernetes clusters on AWS. It provides a highly available and scalable Kubernetes control plane, and it integrates with other AWS services such as Elastic Load Balancing, Auto Scaling, IAM, and CloudWatch.

- The ETCD is already distributed across multiple availability zones.

- EKS Admin has a public endpoint
