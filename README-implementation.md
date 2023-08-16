# Project Instructions
1. Set up a Postgres database with a Helm Chart.
2. Create a Dockerfile for the Python application.
    a. You'll submit the Dockerfile
3. Write a simple build pipeline with AWS CodeBuild to build and push a Docker image into AWS ECR.
    a. Take a screenshot of AWS CodeBuild pipeline for your project submission.
    b. Take a screenshot of AWS ECR repository for the application's repository.
4. Create a service and deployment using Kubernetes configuration files to deploy the application.
5. You'll submit all the Kubernetes config files used for deployment (ie YAML files).
    a. Take a screenshot of running the kubectl get svc command.
    b. Take a screenshot of kubectl get pods.
    c. Take a screenshot of kubectl describe svc <DATABASE_SERVICE_NAME>.
    d. Take a screenshot of kubectl describe deployment <SERVICE_NAME>.
6. Check AWS CloudWatch for application logs.
    a. Take a screenshot of AWS CloudWatch logs for the application.
7. Create a README.md file in your solution that serves as documentation  
   for your user to detail how your deployment process works and how   
   the user can deploy changes. The details should not simply rehash  
   what you have done on a step by step basis. Instead, it should help  
   an experienced software developer understand the technologies and  
   tools in the build and deploy process as well as provide them insight  
   into how they would release new builds.