# Use the official AWS Lambda Node.js base image (or another base if you're using a different runtime)
FROM public.ecr.aws/lambda/nodejs:14

# Install dependencies
RUN npm install express

# Create an app.js to handle the API request
COPY app.js ${LAMBDA_TASK_ROOT}

# Define the Lambda function
CMD ["app.handler"]
