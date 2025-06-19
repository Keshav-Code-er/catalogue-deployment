module "catalogue_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = data.aws_ami.devOps_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = element(split(",", data.aws_ssm_parameter.private-subnet-ids.value), 0)
  //user_data = file("catalogue.sh")
  tags = merge(
    {
      Name = "Catalogue-DEV-AMI"
    },
    var.common_tags
  )

}

resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue_instance.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  #connection establishment
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = module.catalogue_instance.private_ip
  }

  #copy the file
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"

  }


  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh ${var.app_version}"
    ]
  }
}

#stop instance to take AMI
 resource "aws_ec2_instance_state" "catalogue_instance" {
  instance_id = module.catalogue_instance.id
  state       = "stopped"
  depends_on = [ null_resource.cluster ]

}

resource "aws_ami_from_instance" "catalogue_ami" {
  name = "${var.common_tags.component}-${local.current_time}"
  source_instance_id = module.catalogue_instance.id
  depends_on = [ aws_ec2_instance_state.catalogue_instance ]
  
}

resource "null_resource" "delete_instance" {
  triggers = {
    ami_id = aws_ami_from_instance.catalogue_ami.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.catalogue_instance.id}"    
  }
  depends_on = [ aws_ami_from_instance.catalogue_ami ]
  
}

resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project-name}-${var.common_tags.component}-${var.env}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  health_check {
    enabled             = true
    healthy_threshold   = 2 #consider as healthy checks are success
    interval            = 15
    matcher             = "200-299"
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3

  }

}

resource "aws_launch_template" "catalogue" {
  name = "${var.project-name}-${var.common_tags.component}-${var.env}"

  # Here AMI ID should be the one we just created
  image_id = aws_ami_from_instance.catalogue_ami.id
  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"


  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "catalogue"
    }
  }

  user_data = filebase64("${path.module}/catalogue.sh")
}


output "app_version" {
  value = var.app_version

}