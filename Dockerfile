ARG IMAGE=containers.intersystems.com/intersystems/iris-community-arm64:2022.1.0.209.0
ARG IMAGE=containers.intersystems.com/intersystems/iris-community-arm64:2023.1.0.235.1
ARG IMAGE=containers.intersystems.com/intersystems/iris-community-arm64:2023.2.0.227.0
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2022.1.0.209.0
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2023.1.0.235.1
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2023.2.0.227.0
FROM $IMAGE

ARG COMMIT_ID="shopdemo"

USER root   
        
ENV ISC_TEMP_DIR=/intersystems/iris/shop

USER ${ISC_PACKAGE_MGRUSER}

COPY src/shop/Shop $ISC_TEMP_DIR/Shop
COPY src/shop/images $ISC_TEMP_DIR/images
COPY src/shop/CSP/csp/user/ $ISC_PACKAGE_INSTALLDIR/csp/user/
COPY src/shop/images $ISC_PACKAGE_INSTALLDIR/csp/user/images
COPY src/shop/message $ISC_TEMP_DIR/message
COPY src/shop/samples $ISC_TEMP_DIR/samples
COPY iris.script /tmp/iris.script

USER root

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /intersystems/iris/shop
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /intersystems/iris/shop/message/in
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /intersystems/iris/shop/message/work
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /intersystems/iris/shop/message/arc
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /intersystems/iris/shop/samples

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
