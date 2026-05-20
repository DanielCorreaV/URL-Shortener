# Dynamo
resource "aws_dynamodb_table" "shared_url_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" 
  hash_key     = "short_code"     

  attribute {
    name = "short_code"
    type = "S" 
  }

  tags = {
    Environment = "Parcial"
    Project     = "URL-Shortener"
  }
}

resource "aws_dynamodb_table" "users_table" {
  name           = "url-shortener-users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "username"

  attribute {
    name = "username"
    type = "S"
  }

  tags = {
    Environment = "Shared"
    Project     = "URL-Shortener"
  }
}

# API Gateway
resource "aws_apigatewayv2_api" "shared_api" {
  name          = "shared-url-shortener-api"
  protocol_type = "HTTP"
  
  cors_configuration {
    allow_origins = ["*"] 
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["content-type", "authorization"]
  }
}

resource "aws_apigatewayv2_stage" "shared_stage" {
  api_id      = aws_apigatewayv2_api.shared_api.id
  name        = "$default"
  auto_deploy = true
}