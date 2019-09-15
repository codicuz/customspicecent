FROM centos:latest as base

LABEL maintainer="Codicus" description="Centos Spice"

ENV JAVA_HOME=/usr/java/latest
ENV LANG en_US.UTF-8
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib:/usr/lib/oracle/12.2/client/lib
ENV TNS_ADMIN=/opt
ENV NLS_LANG=RUSSIAN_RUSSIA.AL32UTF8
ARG USER1=user

COPY ["rootfs", "/"]

RUN yum -y install epel-release; \
  yum -y update; \
  yum -y install mc nmon iproute telnet vim zip unzip sudo i3* rxvt-unicode xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-drv-evdev xorg-x11-drv-mouse xorg-x11-drv-libinput xorg-x11-server-Xspice openssh-server openssh-clients xorg-x11-xauth dejavu-lgc-sans-fonts libXrender libXtst libaio glibc.i686 libaio.i686 java; \
  yum clean all; \
  useradd $USER1; \
  localedef -i ru_RU -f UTF-8 ru_RU.UTF-8; \
  localedef -i ru_RU -f CP1251 ru_RU.CP1251; \
  yum -y install /distr/*; \
  unzip /distr/visualvm_143.zip -d /opt; \
  alternatives --install /usr/bin/visualvm visualvm /opt/visualvm_143/bin/visualvm 1; \
  chown -R $USER1:$USER1 /opt/*; \
  rm -rfv /distr

HEALTHCHECK --interval=60s --timeout=15s \
 CMD ss -lntp | grep -q ':5900'

USER user

CMD ["xinit", "/usr/bin/i3", "--", "/usr/bin/X", "-config", "/etc/X11/spice-xorg.conf", ":0"]
