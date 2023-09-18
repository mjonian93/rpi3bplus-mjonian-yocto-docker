# Docker Compilación mjonian-rpi

## Repositorio
Estructura de ficheros del repositorio 

	./
	├── Dockerfile
	├── README.md
	└── docker_mount/
	    ├── repo-init.sh
	    └── new-build.sh


## Comandos Docker

### Build Container
Para crear el contenedor docker se debe acceder al directorio base de descarga de este repositorio para usar el fichero **Dockerfile** con las instrucciones necesarias para la configuración del contenedor.

	$ cd [path to rpi3bplus-mjonian-yocto-docker dir]/
	$ docker build --no-cache --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag "rpi3bplus-yocto-image:latest" .

### Run Container
Una vez creada la imagen del contenedor es necesario ejecutar una instancia definiendo los directorios de entrada y salida para cargar los ficheros de configuración de entorno correspondientes.

	$ docker run -d -it --name [RPI CONTAINER ID] -v "[path-to-docker_mount]:/home/mjonian/docker_mount" -v "[path-to-host-sshkey-dir]:/home/mjonian/.ssh:ro" rpi3bplus-yocto-image:latest /bin/bash

Para acceder a un contenedor en segundo plano es necesario ejecutar el comando:

	$ docker exec -ti [RPI CONTAINER ID] /bin/bash

Para ver los contenedores creados y sus IDs:

	$ docker container ls


## Configuración Contenedor Docker
Para configurar el entorno de compilación se debe ejecutar los siguiente comandos desde dentro del contenedor ya en ejecución.

	$ cd /home/mjonian/docker_mount/
	$ ./repo-init.sh

### Nueva compilacion

	$ cd /home/mjonian/docker_mount/
	$ ./new-build.sh

### Configurar entorno para compilacion existente

	$ cd /home/mjonian/docker_mount/
	$ source setup-environment [nombre build]
