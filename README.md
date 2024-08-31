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
