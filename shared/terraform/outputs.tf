output "dynamodb_table_name" {
  value       = aws_dynamodb_table.shared_url_table.name
  description = "Nombre de la tabla de DynamoDB"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.shared_url_table.arn
  description = "ARN de la tabla para los permisos IAM de las Lambdas individuales"
}

output "api_gateway_id" {
  value       = aws_apigatewayv2_api.shared_api.id
  description = "ID del API Gateway"
}

output "api_gateway_execution_arn" {
  value       = aws_apigatewayv2_api.shared_api.execution_arn
  description = "ARN de ejecución para dar permisos a las Lambdas de ser invocadas por el API Gateway"
}

output "api_gateway_url" {
  value       = aws_apigatewayv2_api.shared_api.api_endpoint
  description = "URL Base del API Gateway"
}