# DevOpsExercise

### **Home Assignment for Senior DevOps Engineer**

#### **Objective**
Demonstrate expertise in Infrastructure as Code (IaC), environment setup, containerization, testing, and observability by designing, implementing, and documenting a deployment solution for a mock application.

Please submit the exercise by creating a new GitHub repository with your code, and share it with me (`roee-co`).

Thank you and good luck!

---

### **Part 1: Infrastructure as Code (IaC)**
1. **Task:**  
   Using **Terraform**, provision the following resources in **AWS**:  
   - A **VPC** with:
     - At least two public and private subnets across multiple availability zones.
     - Necessary route tables, internet gateway, and NAT gateway to enable connectivity.
   - A **Lambda function** (packaged as a **Docker container**) deployed in the private subnets of the VPC and integrated with: (Mock implementation is fine)
     - API Gateway (as a public REST endpoint).
     - An SQS queue for message processing.
   - A MongoDB Atlas cluster (free tier or sandbox).
   - A CloudFront distribution to serve static assets from an S3 bucket.
   - A Cognito user pool with one test user.
   
2. **Deliverables:**  
   - Terraform code in a GitHub repository, structured with best practices (modules, variables, outputs).
   - A `README.md` explaining how to:
     - Deploy the infrastructure.
     - Validate the setup.
     - Build and deploy the Lambda function as a Docker container.

---

### **Part 2: Deployment Pipeline**
1. **Task:**  
   - Create a CI/CD pipeline using **GitHub Actions** to:
     - Lint Terraform code using `terraform fmt` and `terraform validate`.
     - Perform a Terraform security scan to ensure the code is secure.
     - Validate the Dockerfile for best practices (Extra points: find a tool to do it).
     - Build and push the Lambda Docker container to Amazon ECR.
     - Deploy the infrastructure (to a sandbox account) only after the tests pass.

2. **Deliverables:**  
   - GitHub Actions workflow file.
   - Instructions for triggering the pipeline.

---

### **Part 3: Observability and Monitoring**
1. **Task:**  
   - Set up observability, Include:
     - CloudWatch logs and metrics for the Lambda function, with monitoring for:
       - Errors and invocations.
       - Duration and throttles.
     - Alerts for:
       - Lambda function errors exceeding a specified threshold.
       - SQS message queue backlog exceeding a defined limit.
   - Include documentation on how these metrics and alerts can be visualized and acted upon.

2. **Deliverables:**  
   - Terraform code for setting up the observability stack, including metrics and alerts.
   - Explanation in `README.md` on how to monitor and respond to alerts.

---

### **Evaluation Criteria**
- **Code Quality:** Clean, modular, and follows best practices.
- **Documentation:** Clear and easy-to-follow instructions.
- **Completeness:** All deliverables are provided and functional.
- **Problem-Solving:** Creativity and effectiveness in meeting the requirements.
- **Integration:** Effective integration of observability as a core component of the solution.


# Sagi notes
lambda container I prepared is at my account 
```

609418740653.dkr.ecr.us-east-1.amazonaws.com/clarity-lambda:latest

```