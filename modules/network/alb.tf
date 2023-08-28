resource "aws_lb" "cf_alb" {
  count              = 1
  name               = "CF-Alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.cf_private_subnet[0].id, aws_subnet.cf_private_subnet[1].id]
}

resource "aws_lb_target_group" "cf_target_grp" {
  name     = "CF-target-group"
  port     = 80
  protocol = "HTTP"

  target_type = "instance"
  vpc_id      = aws_vpc.cf_vpc.id
}

resource "aws_lb_target_group_attachment" "cf_target_grp_attachment" {
  count            = 1
  target_group_arn = aws_lb_target_group.cf_target_grp.arn
  target_id        = aws_instance.ec2_instance[count.index].id # Instance in sub2
}

# Attach ASG instances in sub3 and sub4 to the target group
resource "aws_autoscaling_attachment" "cf_asg_attachment" {
  count                  = 1
  autoscaling_group_name = aws_autoscaling_group.cf_asg[count.index].name
  lb_target_group_arn    = aws_lb_target_group.cf_target_grp.arn
}

resource "aws_lb_listener" "cf_alb_listener" {
  count             = 1
  load_balancer_arn = aws_lb.cf_alb[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cf_target_grp.arn
  }
}

