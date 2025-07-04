HEAP=${HEAP:-2G}
EULA=${EULA:-true}
PUID=${PUID:-1000}

deluser minecraft > /dev/null 2>&1
adduser -s /bin/sh -u $PUID -G users -DS minecraft
chown -R minecraft: /mnt/minecraft/

exec su minecraft -c "java -Xmx${HEAP} -Xms${HEAP} $JAVA_OPTS \
    -XX:TargetSurvivorRatio=90 \
    -XX:+UseZGC \
    -XX:+AlwaysPreTouch \
    -Dcom.mojang.eula.agree=true \
    -Dfile.encoding=UTF-8 \
    -Dlog4j2.formatMsgNoLookups=true \
    -jar /home/minecraft/spigot.jar nogui"
