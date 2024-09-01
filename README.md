# P81 DevOps Assignment

## Overview

This project is a DevOps assignment that involves setting up infrastructure using Terraform and Terragrunt, and deploying a Python application using GitHub Actions for CI/CD.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Running the Pipeline](#running-the-pipeline)
- [Python Application](#python-application)
- [Terraform and Terragrunt](#terraform-and-terragrunt)
- [GitHub Actions CI/CD](#github-actions-cicd)
- [Contributing](#contributing)
- [License](#license)

## Project Structure

p81-devops-assignment/ 
│ 
  ├── terraform/ # Contains Terraform configuration files
  ├── terragrunt/ # Contains Terragrunt configuration 
  ├── venv/ # Virtual environment directory (excluded from version control) 
  ├── process_json.py # Python script to process JSON data 
  ├── .github/workflows/ # GitHub Actions workflow definitions 
└── README.md # This


## Prerequisites

- [Terraform v1.9.5](https://www.terraform.io/downloads.html)
- [Terragrunt v0.67.1](https://terragrunt.gruntwork.io/)
- Python 3.x installed on your local machine
- An AWS account with necessary IAM permissions

## Setup Instructions

1. **Clone the repository:**

   ```bash
   git clone git@github.com:yourusername/p81-devops-assignment.git
   cd p81-devops-assignment


  
Create a virtual environment:  
bash  
`python3 -m venv venv`

Activate the virtual environment:

* On macOS/Linux:  
  `source venv/bin/activate`

**Install Required Packages**:

* Install `requests` for making HTTP requests and `boto3` for interacting with AWS S3:  
  bash
  `pip install requests`  
  `pip install requests boto3`

**Set up a Python virtual environment:**  
`python3 -m venv venv`  
`source venv/bin/activate`  
`pip install -r requirements.txt`

*   
* **Configure AWS credentials:**  
  Make sure your AWS credentials are properly configured using `aws configure` or through environment variables.

**Set up Terraform and Terragrunt:**  
Install Terraform and Terragrunt if they are not already installed.  
`terraform --version`  
`terragrunt --version`

* 

## **Running the Pipeline**

This project uses GitHub Actions for CI/CD. The pipeline is defined in the `.github/workflows` directory.

* The pipeline will automatically trigger on pushes to the `main` branch.  
* The CI/CD pipeline includes steps to initialize and apply Terraform/Terragrunt configurations and to run the Python script.

## **Python Application**

The Python application (`process_json.py`) processes JSON data, filters it based on price, uploads it to an S3 bucket, and makes it available via CloudFront.

## **Terraform and Terragrunt**

The infrastructure is defined using Terraform and managed using Terragrunt. This includes:

* An S3 bucket to store Terraform state  
* A DynamoDB table for state locking  
* A CloudFront distribution to serve the S3 content

## **GitHub Actions CI/CD**

The project includes a GitHub Actions pipeline that handles the following:

* Setting up the environment  
* Running `terragrunt init` and `terragrunt apply` to deploy infrastructure  
* Running the Python application script

## **Contributing**

If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are warmly welcome.

## **License**

