FROM jenkins/jenkins:lts-jdk17

# Switch to root user
USER root

# Update packages and install dependencies
RUN apt-get update && apt-get install -y \
    lsb-release \
    python3-pip \
    sudo

# Install Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

# Add Jenkins user to the Docker group
RUN groupadd -g 999 docker && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"
