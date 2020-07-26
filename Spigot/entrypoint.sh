#!/bin/bash

java \
  -Xmx$JAVA_XMX \
  -Xms$JAVA_XMS \
  -XX:+UseG1GC \
  -XX:+UnlockExperimentalVMOptions \
  -XX:MaxGCPauseMillis=100 \
  -XX:+DisableExplicitGC \
  -XX:TargetSurvivorRatio=90 \
  -XX:G1NewSizePercent=50 \
  -XX:G1MaxNewSizePercent=80 \
  -XX:InitiatingHeapOccupancyPercent=10 \
  -XX:G1MixedGCLiveThresholdPercent=50 \
  -XX:+AggressiveOpts \
  -XX:+AlwaysPreTouch \
  -XX:+UseLargePagesInMetaspace \
  -d64 \
  -Dcom.mojang.eula.agree=true \
  -Dfile.encoding=UTF-8 \
  -jar /opt/minecraft/spigot.jar nogui
