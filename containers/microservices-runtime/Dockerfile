ARG PRODUCT_IMAGE

FROM $PRODUCT_IMAGE as default
RUN grep sagadmin /etc/passwd
RUN cat /etc/os-release
#COPY --chown=sagadmin webmethods-sample-project-layout/assets/IS/Packages/* /opt/softwareag/IntegrationServer/Packages/
ADD --chown=sagadmin webmethods-sample-project-layout/assets/IS/Packages /opt/softwareag/IntegrationServer/Packages/

RUN ls -la /opt/softwareag/IntegrationServer/Packages/

EXPOSE 5555

COPY --chown=sagadmin ./scripts /src/scripts
RUN chmod +x /src/scripts/*.sh
RUN ls -la /src/scripts

ENV JAVA_HOME=/opt/softwareag/jvm/jvm
ENV PATH=$JAVA_HOME/bin:$PATH

ENTRYPOINT /src/scripts/Entrypoint.sh