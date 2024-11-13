resource "aws_instance" "test-server" {
  ami = "ami-08bf489a05e916bbd"
  instance_type = "t2.micro"
  key_name = "mumbai"
  vpc_security_group_ids = ["sg-091e2ec8a2b032d4a"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./mumbai.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"
     }
  }
