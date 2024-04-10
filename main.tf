

# Create EC2 and Networking Infrastructure in AWS



module "aws__instances_eu" {
  source = "./modules/aws-resources"
  providers         = {   
  aws = aws.eu-west-2
  }
  EU_West_FrontEnd = var.EU_West_FrontEnd
  for_each              = var.EU_West_FrontEnd
  aws_region            = var.aws_region[0]
  aws_vpc_name          = each.value["aws_vpc_name"]
  aws_subnet_name       = each.value["aws_subnet_name"]
  rt_name               = each.value["rt_name"]
  igw_name              = each.value["igw_name"]
  private_ip            = each.value["private_ip"]
  tgw                   = "false"
  aws_ec2_name          = each.value["aws_ec2_name"]
  aws_ec2_key_pair_name = each.value["aws_ec2_key_pair_name"]

  aws_vpc_cidr    = each.value["aws_vpc_cidr"]
  aws_subnet_cidr = each.value["aws_subnet_cidr"]
 
}

resource "aws_security_group" "http_https_sg" {
  provider      = aws.eu-aws
  vpc_id            = module.aws__instances_eu.vpc_ids["VPC1"]
  name        = "http-https-sg"
  description = "Allow HTTP and HTTPS traffic"

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
module "aws__instances_us" {
  source = "./modules/aws-resources"
  providers         = { 
  aws = aws.us-east-1
  }
  for_each              = var.US_East_FrontEnd
  aws_region            = var.aws_region[1]
  aws_vpc_name          = each.value["aws_vpc_name"]
  aws_subnet_name       = each.value["aws_subnet_name"]
  rt_name               = each.value["rt_name"]
  igw_name              = each.value["igw_name"]
  private_ip            = each.value["private_ip"]
  tgw                   = "false"
  aws_ec2_name          = each.value["aws_ec2_name"]
  aws_ec2_key_pair_name = each.value["aws_ec2_key_pair_name"]

  aws_vpc_cidr    = each.value["aws_vpc_cidr"]
  aws_subnet_cidr = each.value["aws_subnet_cidr"]

}
*/
# Create Linux and Networking Infrastructure in Azure
/*
module "azure_instances_eu" {
  source = "./modules/azure-resources"
  providers = {
  azurerm = azurerm.eun
  }
  for_each             = var.North_EU_AppSvcs_VNets
  azure_resource_group = each.value["azure_resource_group"]
  azure_location       = "North Europe"
  azure_vnet_name      = each.value["azure_vnet_name"]
  azure_subnet_name    = each.value["azure_subnet_name"]
  azure_instance_name  = each.value["azure_instance_name"]
  azure_private_ip     = each.value["azure_private_ip"]
  azure_server_key_pair_name  = each.value["azure_server_key_pair_name"]
  azure_vm_size        = "Standard_DS1_v2"
  azure_admin_username = "linuxuser"
  azure_admin_password = "admin123"

  azure_subnet_cidr    = each.value["azure_subnet_cidr"]
  azure_vnet_cidr      = each.value["azure_vnet_cidr"]
}
*/
# Onboard CSP Account into Prosimo Dashboard

resource "prosimo_cloud_creds" "aws" {
  cloud_type = "AWS"
  nickname   = "Prosimo_AWS"

  aws {
    preferred_auth = "AWSKEY"

    access_keys {
      access_key_id = var.Access_Key_AWS
      secret_key_id = var.Access_Secret_AWS
    }
  }
}
/*
resource "prosimo_cloud_creds" "azure" {
  cloud_type = "AZURE"
  nickname   = "Prosimo_Azure"

  azure {
    subscription_id = var.subscription
    tenant_id       = var.tenantazure
    client_id       = var.client
    secret_id       = var.clientsecret
  }
}
*/
# Create Prosimo Infra resources in AWS

module "prosimo_resource_aws_eu" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  prosimo_cidr       = var.prosimo_cidr[0]
  cloud = "AWS"
  cloud1 = "Prosimo_AWS"
  apply_node_size_settings = "true"
  multipleRegion = var.aws_region[0]
  wait = "false"

}

/*
module "prosimo_resource_aws_us" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  prosimo_cidr       = var.prosimo_cidr[1]
  cloud = "AWS"
  cloud1 = "Prosimo_AWS"
  apply_node_size_settings = "true"
  multipleRegion = var.aws_region[1]
  wait = "false"

}
*/
/*
module "prosimo_resource_aws" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  count      = length(var.prosimo_cidr)
  prosimo_cidr       = var.prosimo_cidr[count.index]
  cloud = "AWS"
  cloud1 = "Prosimo_AWS"
  apply_node_size_settings = "true"
  bandwidth = "<1 Gbps"
  instance_type = "t3.medium"
  multipleRegion = var.aws_region[count.index]
  wait = "false"
  
}
*/
/*
module "prosimo_resource_azure" {
  source     = "./modules/prosimo-resources"
  prosimo_teamName = var.prosimo_teamName
  prosimo_token = var.prosimo_token
  prosimo_cidr       = "10.253.0.0/23"
  cloud = "AZURE"
  apply_node_size_settings = "true"
  cloud1 = "Prosimo_Azure"
  multipleRegion = "northeurope"
  wait = "false"
  
}
*/
resource "aws_ec2_transit_gateway" "dev" {
provider = aws.eu-aws
description = "EU-TGW"
tags = {
    Name = "EU-TGW"
  }
}


/*
resource "prosimo_visual_transit" "eu_west_2" {


  transit_input {
    cloud_type   = "AWS"
    cloud_region = var.aws_region[0]
    transit_deployment {
      tgws {
        name = aws_ec2_transit_gateway.dev.description
        action = "MOD"
        connection {
          type = "EDGE"
          action = "ADD"
        }
        connection {
          type = "VPC"
          action = "ADD"
          name = "WebProd1Eu"
        }
        connection {
          type = "VPC"
          action = "ADD"
          name = "WebProd2Eu"
        }
        connection {
          type = "VPC"
          action = "ADD"
          name = "WebProd3Eu"
        }
      }
    }
  }
  deploy_transit_setup = true
  depends_on = [aws_ec2_transit_gateway.dev]
}
*/

resource "prosimo_visual_transit" "eu_west" {
  transit_input {
    cloud_type   = "AWS"
    cloud_region = var.aws_region[0]

    transit_deployment {
      tgws {
        name   = aws_ec2_transit_gateway.dev.description
        action = "MOD"

        connection {
          type   = "EDGE"
          action = "ADD"
        }

        dynamic "connection" {
          for_each = var.EU_West_FrontEnd

          content {
            type   = "VPC"
            action = "ADD"
            name   = connection.value.aws_vpc_name
          }
        }
      }
    }
  }

  deploy_transit_setup = true
  depends_on = [aws_ec2_transit_gateway.dev]
}
# Create Namespaces and Export Policy

module "namespace" {
  source = "./modules/prosimo-namespaces"
  namespace_tag = "Vodafone_Dev"
}

locals {
  all_vpc_ids = { for k, v in module.aws__instances_eu : k => v.aws_vpc_id }
}

# Onboard Networks to Prosimo Fabric in AWS eu-west-2


module "network_eu_vpc1" {
  source = "./modules/prosimo-network"
  prosimo_teamName    = var.prosimo_teamName
  prosimo_token       = var.prosimo_token
  network_name        = var.EU_West_FrontEnd["VPC1"]["aws_vpc_name"]
  network_namespace   = var.EU_West_FrontEnd["VPC1"]["namespace"]
  region              = var.aws_region[0]
  subnets_config = [
    {
      subnet         = var.EU_West_FrontEnd["VPC1"]["aws_vpc_cidr"]
    }
  ]
  connectivity_type   = "transit-gateway"
  placement           = "Infra VPC"
  cloud               = "AWS"
  cloud_type          = "public"
  connectType         = "private"
  vpc                 = module.aws__instances_eu["VPC1"].aws_vpc_id
  tgw_id              = aws_ec2_transit_gateway.dev.id
  cloudNickname       = "Prosimo_AWS"
  decommission        = "false"
  onboard             = "true"
}


module "network_eu_vpc2" {
  source = "./modules/prosimo-network"
  prosimo_teamName    = var.prosimo_teamName
  prosimo_token       = var.prosimo_token
  network_name        = var.EU_West_FrontEnd["VPC2"]["aws_vpc_name"]
  network_namespace   = var.EU_West_FrontEnd["VPC2"]["namespace"]
  region              = var.aws_region[0]
  subnets_config = [
    {
      subnet         = var.EU_West_FrontEnd["VPC2"]["aws_vpc_cidr"]
    }
  ]
  connectivity_type   = "transit-gateway"
  placement           = "Infra VPC"
  cloud               = "AWS"
  cloud_type          = "public"
  connectType         = "private"
  vpc                 = module.aws__instances_eu["VPC2"].aws_vpc_id
  tgw_id              = aws_ec2_transit_gateway.dev.id
  cloudNickname       = "Prosimo_AWS"
  decommission        = "false"
  onboard             = "true"
}


module "network_eu_vpc3" {
  source = "./modules/prosimo-network"
  prosimo_teamName    = var.prosimo_teamName
  prosimo_token       = var.prosimo_token
  network_name        = var.EU_West_FrontEnd["VPC3"]["aws_vpc_name"]
  network_namespace   = var.EU_West_FrontEnd["VPC3"]["namespace"]
  region              = var.aws_region[0]
  subnets_config = [
    {
      subnet         = var.EU_West_FrontEnd["VPC3"]["aws_vpc_cidr"]
      virtual_subnet = "10.168.0.0/20"  # Example virtual subnet
    }
  ]
  connectivity_type   = "transit-gateway"
  placement           = "Infra VPC"
  cloud               = "AWS"
  cloud_type          = "public"
  connectType         = "private"
  vpc                 = module.aws__instances_eu["VPC3"].aws_vpc_id
  tgw_id              = aws_ec2_transit_gateway.dev.id
  cloudNickname       = "Prosimo_AWS"
  decommission        = "false"
  onboard             = "true"
}






/*
resource "aws_ec2_transit_gateway" "dev" {
provider = aws.eu-aws
description = "DEV"
tags = {
    Name = "DEV"
  }
}


/*
# Create Virtual Instance and Networking Infrastructre in Azure
module "azure_instances_1" {
  source = "./modules/azure-resources"

  azure_resource_group = "demo_IaC_basic"
  azure_location       = "North Europe"
  azure_vnet_name      = "vnet_1"
  azure_subnet_name    = "subnet_1"
  azure_instance_name  = "vm_1"
  azure_vm_size        = "Standard_DS1_v2"
  azure_admin_username = "$test"
  azure_admin_password = "Test2022"

  azure_subnet_cidr = "10.0.0.0/16"
  azure_vnet_cidr   = "10.0.0.0/24"
}
*/

resource "aws_iam_role" "lambda_execution_role" {
  provider = aws.eu-aws
  name     = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_execution_role_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "archive_file" "lambda_one_zip" {
  type        = "zip"
  source_file = "./lambda_function_one.py"
  output_path = "./lambda_function_one.zip"
}

data "archive_file" "lambda_two_zip" {
 type        = "zip"
  source_file = "./lambda_function_two.py"
  output_path = "./lambda_function_two.zip"
}
/*
resource "null_resource" "package_lambda_two" {
  triggers = {
    version = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
    # Navigate to the Terraform root directory where your Lambda function and requirements.txt are located
    cd /home/iracic/Vodafone-Lab/Prosimo-Labs/instruqt-tracks/prosimo-lab-observe-and-troubleshoot/assets/terraform}

    # Create a virtual environment
    python3 -m venv venv

    # Activate the virtual environment
    source venv/bin/activate

    # Install dependencies specified in requirements.txt
    pip install -r requirements.txt

    # Deactivate the virtual environment
    deactivate

    # Navigate to the site-packages directory to zip dependencies
    cd venv/lib/python3.11/site-packages/

    # Zip the dependencies
    zip -r9 /home/iracic/Vodafone-Lab/Prosimo-Labs/instruqt-tracks/prosimo-lab-observe-and-troubleshoot/assets/terraform/lambda_function_two.zip .

    # Add your Lambda function code to the zip file
    cd /home/iracic/Vodafone-Lab/Prosimo-Labs/instruqt-tracks/prosimo-lab-observe-and-troubleshoot/assets/terraform
    zip -g lambda_function_two.zip lambda_function_two.py
    EOT
  }
}
*/
resource "aws_lambda_function" "lambda_one" {
  provider         = aws.eu-aws
  function_name    = "LambdaFunctionOne"
  filename         = data.archive_file.lambda_one_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_one_zip.output_path)
  handler          = "lambda_function_one.handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_execution_role.arn

}

resource "aws_lambda_function" "lambda_two" {
  provider         = aws.eu-aws
  function_name    = "LambdaFunctionTwo"
  filename         = data.archive_file.lambda_two_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_two_zip.output_path)
  handler          = "lambda_function_two.handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_execution_role.arn
  vpc_config {
    subnet_ids         = module.aws__instances_eu["VPC1"].subnet_ids
    security_group_ids = [aws_security_group.http_https_sg.id]
  }
}


/*
resource "aws_lambda_function" "lambda_two" {
  provider         = aws.eu-aws
  function_name    = "LambdaFunctionTwo"
  filename         = "./lambda_function_two.zip"
  source_code_hash = filebase64sha256("./lambda_function_two.zip")
  handler          = "lambda_function_two.handler"
  runtime          = "python3.11" # Make sure this matches your environment
  role             = aws_iam_role.lambda_execution_role.arn

  # Specify VPC configuration if your Lambda needs to access resources in a VPC
  vpc_config {
    subnet_ids         = module.aws__instances_eu["VPC1"].subnet_ids
    security_group_ids = [aws_security_group.http_https_sg.id]
  }
}
*/
resource "aws_api_gateway_rest_api" "example_api" {
  provider    = aws.eu-aws
  name        = "Vodafone-Lab"
  description = "API Gateway with custom domain"
  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

resource "aws_api_gateway_resource" "invoke" {
  provider    = aws.eu-aws
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "invoke"
}

resource "aws_api_gateway_method" "invoke_post" {
  provider    = aws.eu-aws
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.invoke.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "invoke_integration" {
  provider    = aws.eu-aws
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.invoke.id
  http_method = aws_api_gateway_method.invoke_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_one.invoke_arn
}

resource "aws_api_gateway_resource" "image_info" {
  provider    = aws.eu-aws
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_resource.invoke.id
  path_part   = "image-info"
}

resource "aws_api_gateway_method" "image_info_post" {
  provider    = aws.eu-aws
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.image_info.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "image_info_integration" {
  provider    = aws.eu-aws
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.image_info.id
  http_method = aws_api_gateway_method.image_info_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_two.invoke_arn
}

resource "aws_api_gateway_deployment" "example_deployment" {
  provider    = aws.eu-aws
  depends_on  = [
    aws_api_gateway_integration.invoke_integration,
    aws_api_gateway_integration.image_info_integration,
    aws_api_gateway_rest_api_policy.example_api_policy,
  ]
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  stage_name  = "prod"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_domain_name" "custom_domain" {
  provider       = aws.eu-aws
  domain_name    = "api.iracictechguru.com"
  certificate_arn = "arn:aws:acm:us-east-1:688664532084:certificate/0e33400b-97d6-4934-aefe-527c9fa4024f"
}

resource "aws_api_gateway_base_path_mapping" "base_path" {
  provider    = aws.eu-aws
  api_id      = aws_api_gateway_rest_api.example_api.id
  stage_name  = aws_api_gateway_deployment.example_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
}

resource "aws_lambda_permission" "lambda_one_permission" {
  provider      = aws.eu-aws
  statement_id  = "AllowExecutionFromAPIGatewayLambdaOne"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_one.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example_api.execution_arn}/prod/POST/invoke"
}

resource "aws_lambda_permission" "lambda_two_permission" {
  provider      = aws.eu-aws
  statement_id  = "AllowExecutionFromAPIGatewayLambdaTwo"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_two.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example_api.execution_arn}/prod/POST/invoke/image-info"
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "DynamoDBAccess"
  description = "Policy that allows Lambda functions to access DynamoDB tables"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        Resource = "arn:aws:dynamodb:eu-west-2:688664532084:table/CustomerData"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_access" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}



resource "aws_dynamodb_table" "customer_data" {
  provider      = aws.eu-aws
  name           = "CustomerData"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "CustomerID"

  attribute {
    name = "CustomerID"
    type = "S"
  }

  tags = {
    Purpose = "Demo"
  }
}

resource "null_resource" "populate_dynamodb" {
  depends_on = [aws_dynamodb_table.customer_data]

  provisioner "local-exec" {
  command = "./.venv/bin/python3 ./populate_dynamodb.py"
}





  # This is optional: It triggers the script to run each time you apply the Terraform.
  triggers = {
    always_run = "${timestamp()}"
  }
}


resource "aws_vpc_endpoint" "api_gw_endpoint" {
  provider      = aws.eu-aws
  vpc_id            = module.aws__instances_eu["VPC1"].aws_vpc_id
  service_name      = "com.amazonaws.eu-west-2.execute-api"
  subnet_ids = module.aws__instances_eu["VPC1"].subnet_ids
  #security_group_ids = toset([module.aws__instances_eu["VPC1"].security_group_id])
  security_group_ids = [aws_security_group.http_https_sg.id]
  vpc_endpoint_type = "Interface"  # Set to "Interface" for PrivateLink

  private_dns_enabled = true

  # Policy to restrict access to the VPC Endpoint
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = ["execute-api:Invoke"],
      Resource  = ["*"],
      Condition = {}
    }]
  })

  tags = {
    Name = "api-gw-vpc-endpoint"
  }
}


resource "aws_s3_bucket" "example_bucket" {
  provider = aws.eu-aws
  bucket = "vodafone-lab-bucket"
  force_destroy = true

  tags = {
    Name = "vodafone-s3"
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  provider      = aws.eu-aws
  vpc_id            = module.aws__instances_eu["VPC1"].aws_vpc_id
  service_name      = "com.amazonaws.eu-west-2.s3"
  vpc_endpoint_type = "Interface"
  # Enable Private DNS Names
  private_dns_enabled = true
  dns_options {
    private_dns_only_for_inbound_resolver_endpoint = false
  }

  subnet_ids = module.aws__instances_eu["VPC1"].subnet_ids
  security_group_ids = [aws_security_group.http_https_sg.id]

  tags = {
    Name = "vodafone-s3-endpoint"
  }
}

resource "aws_s3_bucket_policy" "example_bucket_policy" {
  provider      = aws.eu-aws
  bucket = aws_s3_bucket.example_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:*",
        Resource  = [aws_s3_bucket.example_bucket.arn],
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.s3_endpoint.id
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_bucket_policy_management" {
  provider      = aws.eu-aws
  name        = "s3_bucket_policy_management"
  description = "Provides management access to S3 bucket policies"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
        ],
        Resource  = aws_s3_bucket.example_bucket.arn,
      }
    ],
  })
}

resource "aws_iam_policy_attachment" "s3_bucket_policy_attachment" {
  provider      = aws.eu-aws
  name       = "s3_bucket_policy_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]  # Reference the IAM role name here
  policy_arn = aws_iam_policy.s3_bucket_policy_management.arn
}




resource "aws_iam_policy" "api_gateway_policy" {
  provider      = aws.eu-aws
  name          = "APIGatewayInvokePolicy"
  description   = "Policy to allow invocation of API Gateway endpoints"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "execute-api:Invoke",
        Resource  = [
          "${aws_api_gateway_rest_api.example_api.execution_arn}/prod/POST/invoke",
          "${aws_api_gateway_rest_api.example_api.execution_arn}/prod/POST/invoke/image-info",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.api_gateway_policy.arn
}

resource "aws_api_gateway_rest_api_policy" "example_api_policy" {
  provider = aws.eu-aws
  rest_api_id = aws_api_gateway_rest_api.example_api.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Principal: "*",
        Action: "execute-api:Invoke",
        Resource: "execute-api:/*/*/*",
        Condition: {
          StringEquals: {
            "aws:sourceVpce": aws_vpc_endpoint.api_gw_endpoint.id
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_access" {
  name        = "lambda_s3_access_policy"
  description = "Allows Lambda function to access specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          // Include any other S3 actions your function needs
        ],
        Resource = [
          "arn:aws:s3:::vodafone-lab-bucket/*",
          // Adjust the bucket name accordingly
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_access.arn
}

