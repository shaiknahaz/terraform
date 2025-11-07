provider "aws" {
  region = "ap-south-1"   # change region if needed
}

# ✅ IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

# ✅ Basic Lambda Execution Policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ✅ Lambda Function
resource "aws_lambda_function" "example" {
  function_name = "example-scheduled-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"   # must match inside .py file
  runtime       = "python3.9"
  filename      = "${path.module}/lambda_function.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")
}

# ✅ EventBridge Rule (trigger every 5 minutes)
resource "aws_cloudwatch_event_rule" "example" {
  name                = "every-5-minutes"
  schedule_expression = "rate(5 minutes)"
}

# ✅ EventBridge Target (connect rule to Lambda)
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.example.name
  target_id = "lambda"
  arn       = aws_lambda_function.example.arn
}

# ✅ Allow EventBridge to invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.example.arn
}
