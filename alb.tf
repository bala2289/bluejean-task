#define ALB
resource "aws_alb" "alb_front" {
  name                       = "front-alb"
  internal                   = false
  security_groups            = ["${aws_security_group.sg-webALB.id}"]
  subnets                    = ["${aws_subnet.public-subnet.id}", "${aws_subnet.public-subnet-2.id}"]
  enable_deletion_protection = false
}

#Target group
resource "aws_alb_target_group" "alb_front_http" {
  name     = "alb-front-http"
  vpc_id   = "${aws_vpc.default.id}"
  port     = "5000"
  protocol = "HTTP"

  health_check {
    path                = "/healthcheck"
    port                = "5000"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

#backend instance
resource "aws_alb_target_group_attachment" "alb_backend-01_http" {
  target_group_arn = "${aws_alb_target_group.alb_front_http.arn}"
  target_id        = "${aws_instance.webserver.id}"
  port             = 5000
}

#Listener
resource "aws_alb_listener" "alb_front_http" {
  load_balancer_arn = "${aws_alb.alb_front.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_front_http.arn}"
    type             = "forward"
  }
}
