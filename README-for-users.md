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

### create Elastic Container Registry
```sh
export AWS_ECR_REPO_NAME=udacity-cherkavi-eks

aws ecr create-repository  --repository-name $AWS_ECR_REPO_NAME

# list of all repositories 
aws ecr describe-repositories 

# list of all images in repository
aws ecr list-images  --repository-name $AWS_ECR_REPO_NAME
```

### create CodeBuild role
```sh
ROLE_NAME=aws-codebuild-ecr-push
policy_name=aws-codebuild-ecr-push-policy
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://codebuild-iam-role.json
aws iam put-role-policy --role-name $ROLE_NAME --policy-name $policy_name --policy-document file://codebuild-iam-policy.json

aws iam get-role --role-name  $ROLE_NAME
```

### create CodeBuild project
```sh
GITHUB_REPO_URL="https://github.com/cherkavi/udacity-aws-devops-eks"
AWS_ROLE_IAM=`aws iam get-role --role-name  $ROLE_NAME --output text --query 'Role.Arn'`

sed "s|<GITHUB_REPO_URL>|$GITHUB_REPO_URL|" codebuild-project-template.json > codebuild-project.json
sed --in-place "s|<AWS_ROLE_IAM>|$AWS_ROLE_IAM|" codebuild-project.json

aws codebuild create-project --cli-input-json file://codebuild-project.json
```

## deploy changes 