FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-jammy

WORKDIR /home/runner

ARG TARGETOS=linux
ARG TARGETARCH=x64
ARG RUNNER_VERSION=2.329.0
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.7.0
ARG RUNNER_ARCH="x64"
ARG DOCKER_ARCH=x86_64
ARG DOCKER_VERSION=28.5.1
ARG BUILDX_VERSION=0.29.1
ARG BUILDKIT_VERSION=0.23.2

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

RUN apt update -y && apt install curl unzip wget vim telnet -y

RUN export RUNNER_ARCH=${TARGETARCH} \
    && curl -fLo docker.tgz https://download.docker.com/${TARGETOS}/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz \
    && tar zxvf docker.tgz \
    && rm -rf docker.tgz \
    && mkdir -p /usr/local/lib/docker/cli-plugins \
    && curl -fLo /usr/local/lib/docker/cli-plugins/docker-buildx \
        "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64" \
    && chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx

RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

RUN groupadd --gid 1000 buildkit \
    && useradd --uid 1000 --gid 1000 --create-home buildkit \
    && mkdir -p /home/buildkit/.local/tmp \
    && mkdir -p /home/buildkit/.local/share/buildkit \
    && chown -R 1000:1000 /home/buildkit \
    && usermod -aG buildkit runner \
    && usermod -aG sudo runner \
    && echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers

RUN curl -f -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm runner.tar.gz

RUN curl -f -L -o runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm runner-container-hooks.zip

RUN wget -q -O buildkit.tar.gz https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.${TARGETOS}-amd64.tar.gz \
    && tar xzf buildkit.tar.gz \
    && rm -rf buildkit.tar.gz \
    && mv bin/buildctl /usr/local/bin/ 
# Download latest git-lfs version
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -y --no-install-recommends git-lfs
 
## This RUN install gh cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y
 
## This RUN install az cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
 
 
## Install cron and setup crontab
RUN apt-get install cron -y
 
COPY github-runner-cron.txt github-runner.sh ${HOME}
 
## Download ArgoCD CLI
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
RUN install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
RUN rm argocd-linux-amd64
 
RUN install -o root -g root -m 755 docker/* /usr/bin/ && rm -rf docker 

 user runner