import requests
import json
import boto3
from botocore.exceptions import NoCredentialsError

# Step 1: Download JSON from URL
url = "https://dummyjson.com/products"
response = requests.get(url)

if response.status_code == 200:
    data = response.json()
else:
    print(f"Failed to fetch data. Status code: {response.status_code}")
    exit()

# Step 2: Filter Products by Price >= 100
filtered_products = [product for product in data['products'] if product['price'] >= 100]

# Step 3: Save Filtered Results to a New JSON File
filtered_file_name = "filtered_products.json"
with open(filtered_file_name, 'w') as file:
    json.dump(filtered_products, file, indent=4)

# Step 4: Upload the JSON File to an S3 Bucket
s3 = boto3.client('s3')
bucket_name = 'daniels-s3bucket'
s3_key = filtered_file_name

try:
    s3.upload_file(filtered_file_name, bucket_name, s3_key)
    print(f"File {filtered_file_name} uploaded to {bucket_name}/{s3_key}")
except FileNotFoundError:
    print(f"The file {filtered_file_name} was not found.")
except NoCredentialsError:
    print("Credentials not available.")

# Step 5: Download the JSON File via CloudFront
cloudfront_url = "https://d2rz2f1415ar51.cloudfront.net/" + s3_key
cloudfront_response = requests.get(cloudfront_url)

if cloudfront_response.status_code == 200:
    downloaded_data = cloudfront_response.json()
    print("Downloaded JSON from CloudFront:")
    print(json.dumps(downloaded_data, indent=4))
else:
    print(f"Failed to download the file from CloudFront. Status code: {cloudfront_response.status_code}")
