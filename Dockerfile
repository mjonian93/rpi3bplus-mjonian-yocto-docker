# Use Ubuntu 18.04 LTS as the basis for the Docker image.
FROM ubuntu:18.04

# Install all the Linux packages required for Yocto builds. Note that the packages python3,
# tar, locales and cpio are not listed in the official Yocto documentation. The build, however,
# without them.
RUN apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales sudo nano vim \
libusb-1.0-0-dev liblog4c-dev

# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.
RUN rm /bin/sh && ln -s bash /bin/sh

# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV USER_NAME mjonian

# The running container writes all the build artefacts to a host directory (outside the container).
# The container can only write files to host directories, if it uses the same user ID and
# group ID owning the host directories. The host_uid and group_uid are passed to the docker build
# command with the --build-arg option. By default, they are both 1001. The docker image creates
# a group with host_gid and a user with host_uid and adds the user to the group. The symbolic
# name of the group and user is mjonian.
ARG host_uid=1001
ARG host_gid=1001
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME
RUN addgroup $USER_NAME dialout
RUN usermod -a -G sudo $USER_NAME

# Añadimos la contraseña al user root por si necesitamos lanzar algo como root
RUN echo "root:root" | chpasswd
RUN echo "mjonian:mjonian" | chpasswd

# Perform the Yocto build as user mjonian (not as root).
# NOTE: The USER command does not set the environment variable HOME.

#Create ssh key dirs to mount host volume
RUN mkdir -p /home/$USER_NAME/.ssh
RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
RUN echo "Host *.trabe.io\n\tStrictHostKeyChecking no\n" >> /home/$USER_NAME/.ssh/config

# By default, docker runs as root. However, Yocto builds should not be run as root, but as a 
# normal user. Hence, we switch to the newly created user mjonian.
USER $USER_NAME