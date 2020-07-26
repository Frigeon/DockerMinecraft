####################
# Build Spigot.jar #
####################
FROM openjdk:8-jdk-alpine as buildspigot 
# --------------
# Define version
# --------------
ARG VERSION=1.16.1

# ------------------------------
# Compile Spigot with BuildTools
# ------------------------------
RUN apk add --update --no-cache git wget \
 && cd /tmp \
 && wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
 && java -jar BuildTools.jar --rev $VERSION \
 && mv spigot-*.jar spigot.jar

#####################
# Build Start.class #
#####################
FROM openjdk:8-jdk-alpine as starter

# ------------------
# Compile Start.java
# ------------------
RUN apk add --update --no-cache wget \
 && cd /tmp/ \
 && wget https://raw.githubusercontent.com/marcermarc/DockerMinecraft/master/StartProgram/Start.java \
 && javac Start.java \
 && chmod +x Start.class

#######
# Run #
#######
FROM alpine:latest

LABEL maintainer "docker@marcermarc.de"

# -----------------------------------------------------------------------------------------------------------
# Default extra params from:
#  https://aquifermc.org/threads/optimizing-paper-remove-lag-spikes-fix-tps-improve-performance.101/#post-822
# Set the classpath can start the Start.class
# -----------------------------------------------------------------------------------------------------------
COPY entrypoint.sh /
ENV WORKDIR="/mnt/minecraft" \
COMMAND="/entrypoint.sh" \
CLASSPATH=/opt/start

# --------------------------------
# Copy files from the build images
# --------------------------------
COPY --from=buildspigot /tmp/spigot.jar /opt/minecraft/
COPY --from=starter /tmp/*.class /opt/start/

# ------------------
# Add user minecraft
# ------------------
RUN mkdir -p /mnt/minecraft \ 
 && apk add --no-cache openjdk8-jre-base nss nano \
 && adduser -D minecraft -h /opt \
 && chown -R minecraft /mnt/minecraft /opt \
 && chmod -R 777 /mnt/minecraft /opt

# ------------
# Expose ports
# ------------
EXPOSE 25565:25565/tcp 25565:25565/udp

# -------------
# Define volume
# -------------
VOLUME ["/mnt/minecraft"]
WORKDIR /mnt/minecraft

RUN (crontab -l ; echo "0 0 * * * tar -czf /mnt/minecraft/")

ENV JAVA_XMX = 4G
ENV JAVA_XMS = 1G

# ---------------------
# Start the Start.class
# ---------------------
ENTRYPOINT ["java", "Start"]
