output "s3_backend" {
    value = aws_s3_bucket.state_bucket.bucket
}

output "db_backend" {
    value = aws_dynamodb_table.stateLockTable.name
}