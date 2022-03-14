ARG IMAGE=intersystemsdc/iris-community:2020.3.0.221.0-zpm
ARG IMAGE=store/intersystems/iris-community-arm64:2020.4.0.547.0
ARG IMAGE=store/intersystems/iris-community-arm64:2021.1.0.215.0
ARG IMAGE=store/intersystems/iris-community-arm64:2021.2.0.649.0
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
ARG IMAGE=store/intersystems/iris-community:2020.4.0.547.0
ARG IMAGE=store/intersystems/iris-community:2021.1.0.215.0
ARG IMAGE=store/intersystems/iris-community:2021.2.0.649.0
FROM $IMAGE

ARG COMMIT_ID="shopdemo"

USER root   
        
ENV ISC_TEMP_DIR=/intersystems/iris/shop

USER ${ISC_PACKAGE_MGRUSER}

COPY src/shop/Shop $ISC_TEMP_DIR/Shop
COPY src/shop/images $ISC_TEMP_DIR/images
COPY src/shop/CSP/csp/user/ $ISC_PACKAGE_INSTALLDIR/csp/user/
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
