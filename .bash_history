ls 
ls -al
clear
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre
java -version
which java
sudo apt install -y openjdk-21-jdk
javac -version
sudo apt update
sudo apt install -y git
git --version
git config --global user.name "Guruprasad"
git config --global user.email "guruprasad29198@gmail.com"
git config --list
docker run hello-world
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
sudo apt update
sudo apt install -y maven
mvn -version
sudo apt remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
sudo apt update
sudo apt install -y ca-certificates curl
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker --version
sudo systemctl status docker
sudo systemctl start docker
sudo systemctl enable docker
sudo docker run hello-world
sudo usermod -aG docker $USER
newgrp docker
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
http://<EC2-PUBLIC-IP>:8080
java -version
javac -version
git --version
mvn -version
docker --version
docker compose version
sudo systemctl status docker
docker compose version
sudo systemctl status jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo systemctl status jenkins
groups jenkins
jenkins docker
