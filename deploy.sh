#!/bin/bash

set -e  # Exit immediately on error

# 📝 CONFIGURATION
LAMBDA_FUNCTION_NAME="your-lambda-function-name"
REGION="us-east-1"

echo "📦 Cleaning up previous packages..."
rm -rf package lambda_package.zip

echo "📁 Creating deployment package..."
mkdir package
pip install -r requirements.txt -t package/
cp lambda_function.py package/

cd package
zip -r9 ../lambda_package.zip .
cd ..

echo "🚀 Deploying to AWS Lambda..."
aws lambda update-function-code \
  --function-name "$LAMBDA_FUNCTION_NAME" \
  --zip-file fileb://lambda_package.zip \
  --region "$REGION"

echo "✅ Deployment successful!"
