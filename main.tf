resource "aws_security_group" "jenkins-sg" {
  name = "jenkins-sg"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins-instance" {
    ami = "${var.ubuntu-ami}"
    instance_type = "t2.micro"
    key_name = "${var.keyname}"
    vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"]
    user_data = "${file("jenkins-install.sh")}"
}

output jenkins_ip_address {
  value       = "${aws_instance.jenkins-instance.public_dns}"
}
