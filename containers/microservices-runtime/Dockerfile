ARG PRODUCT_IMAGE
ARG BASE_IMAGE

FROM $PRODUCT_IMAGE as product_image
#copy packages1
COPY --chown=sagadmin webmethods-sample-project-layout/assets/IS/Packages/ /opt/softwareag/IntegrationServer/Packages/

RUN ls -la /opt/softwareag/IntegrationServer/
RUN ls -la /opt/softwareag/IntegrationServer/Packages/

FROM $BASE_IMAGE as default
RUN useradd -u 1724 sagadmin
EXPOSE 5555
COPY --from=product_image --chown=1724:1724 /opt/softwareag/ /opt/softwareag/
COPY --chown=sagadmin ./scripts /src/scripts
RUN ls -la /src/scripts
ENV JAVA_HOME=/opt/softwareag/jvm/jvm
ENV PATH=$JAVA_HOME/bin:$PATH

RUN ls -la /opt/softwareag/IntegrationServer/
RUN ls -la /opt/softwareag/IntegrationServer/Packages/

ENTRYPOINT /src/scripts/Entrypoint.sh