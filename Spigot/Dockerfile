####################
# Build Spigot.jar #
####################
FROM openjdk:8-jdk-alpine as buildspigot 
# --------------
# Define version
# --------------
ARG VERSION=1.14.4

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
ENV WORKDIR="/mnt/minecraft" \
  COMMAND="java -Xmx8G -Xms8G -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -XX:+AlwaysPreTouch -XX:+UseLargePagesInMetaspace -d64 -Dcom.mojang.eula.agree=true -Dfile.encoding=UTF-8 -jar /opt/minecraft/spigot.jar nogui" \
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

# ---------------------
# Start the Start.class
# ---------------------
ENTRYPOINT ["java", "Start"]
