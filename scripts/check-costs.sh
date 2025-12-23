#!/bin/bash
# Cost monitoring for AWS Free Tier

echo "🔍 Checking AWS costs for current month..."

START_DATE=$(date -u -d "$(date +%Y-%m-01)" '+%Y-%m-%d')
END_DATE=$(date -u '+%Y-%m-%d')

COST=$(aws ce get-cost-and-usage \
  --time-period Start=$START_DATE,End=$END_DATE \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --query 'ResultsByTime[0].Total.UnblendedCost.Amount' \
  --output text)

echo "💰 Current month cost: \$$COST"

if (( $(echo "$COST > 1.0" | bc -l) )); then
  echo "⚠️  WARNING: Exceeding $1 budget!"
  exit 1
else
  echo "✅ Within budget"
fi
