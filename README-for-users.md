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

### create CodeBuild project
```sh
mv codebuild-project.json codebuild-project-template.json

GITHUB_REPO_URL="https://github.com/cherkavi/aws-codebuild"
sed "s|<GITHUB_REPO_URL>|$GITHUB_REPO_URL|" codebuild-project-template.json > codebuild-project.json
AWS_ROLE_IAM='arn:aws:iam::330996503740:role/service-role/codebuild-a-service-role'
sed --in-place "s|<AWS_ROLE_IAM>|$AWS_ROLE_IAM|" codebuild-project.json

aws codebuild create-project --cli-input-json file://codebuild-project.json
```

## deploy changes 