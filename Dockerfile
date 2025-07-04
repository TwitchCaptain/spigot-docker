# Build spigot jar.
FROM alpine:latest AS builder
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing openjdk24-jdk git
ARG VERSION=latest
RUN wget -O BuildTools.jar 'https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar' \
 && java -Xmx2G -jar BuildTools.jar --rev $VERSION --output-dir /tmp --final-name spigot.jar

 # Create final image.
FROM alpine:latest
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing openjdk24-jre
RUN mkdir /mnt/minecraft /home/minecraft
COPY --from=builder /tmp/spigot.jar /home/minecraft/spigot.jar
COPY entrypoint.sh /home/minecraft/entrypoint.sh

# Put your world data here.
VOLUME ["/mnt/minecraft"]
# Default mc port.
EXPOSE 25565:25565/tcp
# Remote console port.
EXPOSE 25575:25575/tcp

WORKDIR /mnt/minecraft
ENV HEAP=2G
ENV EULA=true
ENV JAVA_OPTS=""
ENV PUID=1000
ENTRYPOINT [ "/bin/sh", "/home/minecraft/entrypoint.sh" ]
