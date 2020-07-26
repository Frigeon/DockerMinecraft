#################
# Install Forge #
#################
FROM openjdk:8-jdk-alpine as installforge

# --------------
# Define version
# --------------
ARG VERSION=1.16.1

# ---------------------------------
# Download and install forge server
# ---------------------------------
RUN apk add --update --no-cache jq curl \
 && if [ "$VERSION" = "latest" ]; then export INDEX="index"; else export INDEX="index_${VERSION}"; fi \
 && cd /tmp \
 && mkdir installer \
 && curl -o /tmp/installer/forge-install.jar "https://files.minecraftforge.net/maven/net/minecraftforge/forge/$(curl https://files.minecraftforge.net/maven/net/minecraftforge/forge/${INDEX}.json | jq --raw-output '.md.versions | map(select(.marker == "LATEST"))[0].classifiers.installer.path')" \
 && java -jar /tmp/installer/forge-install.jar --installServer \
 && mv /tmp/forge-*.jar /tmp/forge.jar \
 && ls

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
  COMMAND="java -Xmx4G -Xms2G -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts -XX:+AlwaysPreTouch -XX:+UseLargePagesInMetaspace -d64 -Dfile.encoding=UTF-8 -jar /opt/minecraft/forge.jar nogui" \
  CLASSPATH=/opt/start

# --------------------------------
# Copy files from the build images
# --------------------------------
COPY --from=installforge /tmp/*.jar /opt/minecraft/
COPY --from=installforge /tmp/libraries/ /opt/minecraft/libraries
COPY --from=starter /tmp/*.class /opt/start/

# ------------------
# Add user minecraft
# ------------------
RUN mkdir -p /mnt/minecraft \ 
 && apk add --no-cache openjdk8-jre-base \
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

# ----------------
# Set startup user
# ----------------
USER minecraft

# ---------------------
# Start the Start.class
# ---------------------
ENTRYPOINT ["java", "Start"]
