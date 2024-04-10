# Print AWS Instance Public
output "aws_ec2_public_ip" {
  value = aws_instance.ec2_linux.public_ip
}

output "aws_eip_public_ip" {
  value = aws_eip.eip.public_ip
}

#output "aws_vpc_id" {
#  value = aws_vpc.vpc1.id
#}

output "ssh_access" {
  value = "${var.aws_ec2_name} - ${aws_instance.ec2_linux.private_ip} => ssh -i '~/prosimo-lab/assets/terraform/${var.aws_ec2_key_pair_name}.pem' ec2-user@${aws_eip.eip.public_ip}"
}


#Within your module
output "aws_vpc_id" {
  value = aws_vpc.vpc1.id
}


#output "vpc_ids" {
#  value = {for k, v in var.EU_West_FrontEnd : k => aws_vpc.vpc1[k].id}
#  description = "Map of VPC names to their IDs"
#}


output "subnet_ids" {
  value = [aws_subnet.subnet1.id] # Assuming a single subnet; adjust as needed
}

output "security_group_id" {
  value = aws_security_group.sg_allow_access_inbound.id
}