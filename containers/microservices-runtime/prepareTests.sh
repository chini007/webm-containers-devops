#!/bin/sh
set -x
CONTAINER_ID=`docker ps -q`
docker cp $CONTAINER_ID:/opt/softwareag/common/lib/ext/enttoolkit.jar ../../lib
docker cp $CONTAINER_ID:/opt/softwareag/common/lib/glassfish/gf.jakarta.mail.jar ../../lib
docker cp $CONTAINER_ID:/opt/softwareag/common/lib/wm-isclient.jar ../../lib
docker cp $CONTAINER_ID:/opt/softwareag/IntegrationServer/lib/wm-isserver.jar ../../lib
ls -la ../../lib