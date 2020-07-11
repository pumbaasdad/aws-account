resource aws_sns_topic notify_me {
  name = "notify-me"
}

resource aws_cloudwatch_metric_alarm billing_alarm {
  alarm_name          = "billing-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 21600
  statistic           = "Maximum"
  threshold           = var.charge_warning_dollars
  alarm_actions       = [aws_sns_topic.notify_me.arn]
  alarm_description   = "Send an e-mail if estimated charges exceed ${var.charge_warning_dollars} CAD in a month."
  datapoints_to_alarm = 1

  dimensions = {
    Currency = "CAD"
  }
}
