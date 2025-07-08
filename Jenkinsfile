pipeline {
    agent any

    environment {
        // Replace with your Lambda function name
        LAMBDA_FUNCTION_NAME = 'your-lambda-function-name'
        // Jenkins credentials ID for AWS
        AWS_CREDENTIALS_ID = 'aws-creds-id'
        // GitHub repo URL
        GIT_REPO_URL = 'https://github.com/dinesh12-pm/lambda-pipeline.git'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: "${GIT_REPO_URL}", branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    rm -rf package
                    mkdir package
                    pip install -r requirements.txt -t package/
                    cp lambda_function.py package/
                '''
            }
        }

        stage('Zip Package') {
            steps {
                sh '''
                    cd package
                    zip -r9 ../lambda_package.zip .
                '''
            }
        }

        stage('Upload to Lambda') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                 credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    sh '''
                        aws lambda update-function-code \
                            --function-name ${LAMBDA_FUNCTION_NAME} \
                            --zip-file fileb://lambda_package.zip \
                            --region us-east-1
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Lambda function updated successfully.'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
