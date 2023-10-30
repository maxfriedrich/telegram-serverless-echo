provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "telegram_token" {
  type = string
}


resource "aws_lambda_function" "serverless_echo_bot" {
  function_name = "serverless-echo-bot"
  handler       = "echo.bot.lambda_handler"
  runtime       = "python3.11"

  role             = aws_iam_role.lambda_execution_role.arn
  filename         = "../lambda.zip"
  source_code_hash = filebase64sha256("../lambda.zip")

  environment {
    variables = {
      TELEGRAM_BOT_TOKEN = var.telegram_token
    }
  }
}

resource "aws_cloudwatch_log_group" "serverless_echo_bot_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.serverless_echo_bot.function_name}"
  retention_in_days = 1
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda_basic_execution_attachment" {
  name       = "lambda_basic_execution_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function_url" "serverless_echo_bot_function_url" {
  function_name      = aws_lambda_function.serverless_echo_bot.function_name
  authorization_type = "NONE"
}

output "serverless_echo_bot_function_url" {
  value = aws_lambda_function_url.serverless_echo_bot_function_url.function_url
}