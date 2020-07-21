FROM store/intersystems/iris-community:2020.2.0.211.0 

ARG COMMIT_ID="shopdemo"

USER irisowner

ENV ISC_TEMP_DIR=/intersystems/iris/shop
COPY shop/Shop $ISC_TEMP_DIR/Shop
COPY shop/images $ISC_TEMP_DIR/images
COPY shop/CSP/csp/user/ $ISC_PACKAGE_INSTALLDIR/csp/user/
COPY shop/message $ISC_TEMP_DIR/message
COPY shop/samples $ISC_TEMP_DIR/samples

RUN  iris start $ISC_PACKAGE_INSTANCENAME \ 
&& printf 'Do ##class(Config.NLS.Locales).Install("jpuw") \
 Do ##class(%%EnsembleMgr).EnableNamespace("USER") \
 set sec = ##class("Security.Applications").%%OpenId("/csp/user") \
 set sec.DeepSeeEnabled = 1 \
 set sec.iKnowEnabled = 1 \
 set status = sec.%%Save() \
 set sec = ##class("Security.Applications").%%New() \
 set sec.Name = "/shop" \
 set sec.NameSpace = "USER" \
 set sec.DispatchClass ="Shop.Broker" \
 set sec.AutheEnabled = 32 \
 set status = sec.%%Save() \
 set user = ##class(Security.Users).%%OpenId("_system") \
 set user.PasswordExternal = "demosystem" \
 set status = user.%%Save() \
 h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U %SYS \ 
&& printf 'Do $system.OBJ.LoadDir("'$ISC_TEMP_DIR'/","ck",,1) \
 do ##class(Shop.Customer).createTestDataJSON() \
 do ##class(Shop.Product).createTestDataJSON() \
 h\n' | iris session $ISC_PACKAGE_INSTANCENAME -U USER \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly

USER root

RUN  chmod 777 $ISC_TEMP_DIR/samples/* \
&& chmod 777 $ISC_TEMP_DIR/message/*

USER irisowner

RUN rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
 && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log

RUN echo $COMMIT_ID > $HOME/commit.txt