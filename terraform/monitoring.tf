# -----------------------------
# CloudWatch Log Group
# -----------------------------
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ec2/devsecops-app"
  retention_in_days = 7

  tags = {
    Name       = "devsecops-app-logs"
    CostCenter = "Learning"
  }
}

# -----------------------------
# SNS Topic for Alerts
# -----------------------------
resource "aws_sns_topic" "alerts" {
  name = "devsecops-alerts"

  tags = {
    Name       = "devsecops-alerts"
    CostCenter = "Learning"
  }
}

# Email subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# -----------------------------
# CloudWatch Alarm - High CPU
# -----------------------------
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "devsecops-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alert when CPU exceeds 80%"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

# -----------------------------
# CloudWatch Dashboard
# -----------------------------
resource "aws_cloudwatch_dashboard" "app" {
  dashboard_name = "DevSecOps-Application-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.app.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type = "log"
        properties = {
          query  = "SOURCE '/aws/ec2/devsecops-app' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region = var.aws_region
          title  = "Recent Application Logs"
        }
      }
    ]
  })
}

# -----------------------------
# Cost Anomaly Detection
# -----------------------------
resource "aws_ce_anomaly_monitor" "cost" {
  name              = "DevSecOpsProjectMonitor"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "cost_alert" {
  name      = "DevSecOpsCostAlert"
  frequency = "DAILY"

  monitor_arn_list = [
    aws_ce_anomaly_monitor.cost.arn
  ]

  subscriber {
    type    = "EMAIL"
    address = var.alert_email
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      values        = ["1"]
        match_options = ["GREATER_THAN_OR_EQUAL"]
    }
  }
}
