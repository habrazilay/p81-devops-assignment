**Daniel’s DevOps Assignment Insights**

**Terraform:**  
To create the `aws_cloudfront_distribution`, I referenced the example provided by the Terraform Registry: [CloudFront Distribution Example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront\_distribution).

**Challenges faced**:

Throughout this assignment, I encountered several challenges:

1. **CloudFront Configuration:** Initially, I configured CloudFront to use Origin Access Control (OAC) instead of Origin Access Identity (OAI). OAC is designed to provide more granular access control, but it also introduces additional complexity. This led to issues with ensuring that CloudFront could access the S3 bucket on behalf of users while keeping the bucket itself private. Due to the complexity, I decided to destroy the initial configuration and revert to using OAI, which is simpler and more straightforward for this use case.  
     
2. **GitHub Actions and Terragrunt Initialization:** When setting up the CI/CD pipeline with GitHub Actions, I encountered an issue where Terragrunt could not locate the `terragrunt.hcl` file during initialization. The solution was to explicitly specify the configuration file by adding `terragrunt init --terragrunt-config terragrunt.hcl`. The same approach was applied to the `terragrunt apply` command to ensure proper execution.  
     
3. **Version Discrepancies Between Terraform and Terragrunt:** I faced compatibility issues due to version discrepancies between Terraform and Terragrunt. Resolving this required careful review of the supported versions documentation: [Terragrunt Supported Versions](https://terragrunt.gruntwork.io/docs/getting-started/supported-versions/).

4. **Terragrunt Configuration:** There were also challenges with the configuration of my `terragrunt.hcl` file. By consulting the documentation, I was able to correct these issues: [Terragrunt Configuration Guide](https://terragrunt.gruntwork.io/docs/getting-started/configuration/\#terragrunt-configuration-file).  
     
   

**Conclusion**:

While I encountered some minor issues such as typos and missing packages, they were not significant enough to highlight here. This assignment provided a valuable learning experience, especially as it was my first time working with Terragrunt and GitHub Actions. My previous experience with Azure Pipelines and Jenkins was beneficial, but this project allowed me to expand my skills and adapt to new tools and processes.  
