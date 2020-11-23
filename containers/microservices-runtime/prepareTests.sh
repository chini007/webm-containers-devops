#!/bin/sh
CONTAINER_ID=`docker ps -q`
docker cp $CONTAINER_ID:/opt/softwareag/common/lib/ext/enttoolkit.jar .
docker cp $CONTAINER_ID:/opt/softwareag/common/lib/glassfish/gf.jakarta.mail.jar .
docker cp $CONTAINER_ID:/opt/softwareag/common/lib/wm-isclient.jar .
docker cp $CONTAINER_ID:/opt/softwareag/IntegrationServer/lib/wm-isserver.jar .