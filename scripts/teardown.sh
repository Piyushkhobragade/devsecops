#!/bin/bash
set -e

# WARNING:
# Demo / learning account only.
# Destroys infrastructure created by this project.

echo "Starting teardown..."

echo "Destroying Terraform-managed resources"
cd terraform
terraform destroy -auto-approve
cd ..

echo "Cleaning CloudWatch log groups (project-scoped)"
for lg in $(aws logs describe-log-groups \
  --query "logGroups[?contains(logGroupName, 'devsecops')].logGroupName" \
  --output text); do
  aws logs delete-log-group --log-group-name "$lg"
done

echo "Cleaning SNS topics (project-scoped)"
for arn in $(aws sns list-topics \
  --query "Topics[?contains(TopicArn, 'devsecops')].TopicArn" \
  --output text); do
  aws sns delete-topic --topic-arn "$arn"
done

echo "Teardown complete"
