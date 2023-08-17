# Instructions for developers

## deployment process

### dockerfile local check  
```sh
export CONTAINER_NAME=analytics
export CONTAINER_TAG=1.0.1
```
#### check building of the docker file
```sh
docker build . -f Dockerfile --tag $CONTAINER_NAME:$CONTAINER_TAG
```
#### check built up docker file
```sh
docker run --entrypoint="" -it $CONTAINER_NAME:$CONTAINER_TAG  /bin/sh
```

### create AWS infrastructure 
```sh
export AWS_ECR_REPO_NAME=udacity-cherkavi-eks
export ROLE_CODEBUILD=aws-codebuild-ecr-push
export ROLE_CODEBUILD_POLICY=aws-codebuild-ecr-push-policy
export CODEBUILD_PROJECT_NAME=aws-dockerbuild-coworkingspace
export CODEBUILD_GITHUB_REPO_URL="https://github.com/cherkavi/udacity-aws-devops-eks"
export AWS_S3_CODEBUILD_LOGS="${CODEBUILD_PROJECT_NAME}-s3-logs"
```

#### ECR: Elastic Container Registry
*create*
```sh
aws ecr create-repository  --repository-name $AWS_ECR_REPO_NAME
```
*check*
```sh
# list of all repositories 
aws ecr describe-repositories 

# list of all images in repository
aws ecr list-images  --repository-name $AWS_ECR_REPO_NAME
```
*delete*
```sh
aws ecr delete-repository  --repository-name $AWS_ECR_REPO_NAME
```


#### CodeBuild
##### CodeBuild role
*create*
```sh
aws iam create-role --role-name $ROLE_CODEBUILD --assume-role-policy-document file://codebuild-iam-role.json
aws iam put-role-policy --role-name $ROLE_CODEBUILD --policy-name $ROLE_CODEBUILD_POLICY --policy-document file://codebuild-iam-policy.json
```
*check*
```sh
aws iam get-role --role-name $ROLE_CODEBUILD
aws iam get-role-policy --role-name $ROLE_CODEBUILD --policy-name $ROLE_CODEBUILD_POLICY
```
*delete*
```sh
# echo "delete role: " $ROLE_CODEBUILD " with policy: " $ROLE_CODEBUILD_POLICY
# aws iam delete-role-policy --role-name $ROLE_CODEBUILD --policy-name $ROLE_CODEBUILD_POLICY
# aws iam delete-role --role-name $ROLE_CODEBUILD
```

##### CodeBuild S3 bucket for logs
*create*
```sh
aws s3 mb s3://$AWS_S3_CODEBUILD_LOGS
```
*check*
```sh
aws s3 ls
aws s3 ls --recursive s3://$AWS_S3_CODEBUILD_LOGS
# aws s3api get-object --bucket $AWS_S3_CODEBUILD_LOGS --key 63a94d38-45f1-4b3f-9a22-f3bebf1a1650.gz 63a94d38-45f1-4b3f-9a22-f3bebf1a1650.gz
```
*delete*
```sh
# echo "remove bucket: ${AWS_S3_CODEBUILD_LOGS}
# aws s3 rb s3://$AWS_S3_CODEBUILD_LOGS
```

##### CodeBuild project
*create*
```sh
ROLE_CODEBUILD_IAM=`aws iam get-role --role-name  $ROLE_CODEBUILD --output text --query 'Role.Arn'`
echo $ROLE_CODEBUILD_IAM

# create codebuild-project.json document from template 
sed "s|<GITHUB_REPO_URL>|$CODEBUILD_GITHUB_REPO_URL|" codebuild-project-template.json > codebuild-project.json
sed --in-place "s|<AWS_ROLE_IAM>|$ROLE_CODEBUILD_IAM|" codebuild-project.json
sed --in-place "s|<PROJECT_NAME>|$CODEBUILD_PROJECT_NAME|" codebuild-project.json
sed --in-place "s|<AWS_ECR_REPOSITORY_NAME>|$AWS_ECR_REPO_NAME|" codebuild-project.json
sed --in-place "s|<AWS_S3_CODEBUILD_LOGS>|$AWS_S3_CODEBUILD_LOGS|" codebuild-project.json

aws codebuild create-project --cli-input-json file://codebuild-project.json
```
*check*
```sh
aws codebuild batch-get-projects --names $CODEBUILD_PROJECT_NAME
aws codebuild list-projects 
```

*delete*
```sh
# echo "delete project by name: "$CODEBUILD_PROJECT_NAME
# aws codebuild delete-project --name $CODEBUILD_PROJECT_NAME
```


## deploy changes 
### build docker image and push it to ECR
[!!! init env variables !!!](#create-aws-infrastructure)
```sh
BUILD_VERSION=1.0.1
aws codebuild start-build --project-name $CODEBUILD_PROJECT_NAME --environment-variables CONTAINER_TAG=$BUILD_VERSION

aws codebuild list-builds-for-project --project-name $CODEBUILD_PROJECT_NAME
aws codebuild batch-get-builds --ids aws-dockerbuild-coworkingspace:e8a61490-ce3b-4079-98f6-50db93a3299d
```