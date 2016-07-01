FROM ubuntu
MAINTAINER Hagai Cohen <hagai.co@gmail.com>

ENV ASTROBOX_VERSION=0.9.1
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN set -xe \
	&& echo "Set Temporary packages for compilation" \
	&& export PKGS='build-essential wget' \
	&& echo "Set Java Repository for installing it" \
	&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
	&& echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main >> /etc/apt/sources.list.d/java-8-debian.list \
	&& echo deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main >> /etc/apt/sources.list.d/java-8-debian.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
	&& echo "Install all required packages (Temporary + Permanent)" \
	&& apt-get update \
	&& apt-get install -y ${PKGS} --no-install-recommends \
	&& apt-get install -y git rubygems python-apt python-pip python-dev git libav-tools avrdude curl --no-install-recommends \
	&& echo "Download and install AstroBox" \
	&& cd /tmp/ \
	&& wget https://github.com/AstroPrint/AstroBox/archive/${ASTROBOX_VERSION}.tar.gz \
	&& tar -zxf ${ASTROBOX_VERSION}.tar.gz \
	&& mv -f AstroBox-${ASTROBOX_VERSION} /astrobox/ \
	&& cd /astrobox/ \
	&& echo "Install Astrobox requirements" \
	&& pip install -U pip setuptools \
	&& gem install sass \
	&& pip install -r requirements.txt \
	&& echo "Cleaning Temporary Packages + Installation leftovers" \
	&& apt-get purge -y --auto-remove ${PKGS} \
	&& echo "Installing Java8" \
	&& apt-get install -y oracle-java8-installer  --no-install-recommends \
	&& echo "Cleaning Java leftovers" \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/* \
	&& rm -rf /var/cache/oracle-jdk8-installer \
	&& rm -rf ${JAVA_HOME}/*src.zip \
	&& rm -rf \
		${JAVA_HOME}/*/javaws \
		${JAVA_HOME}/*/jjs \
		${JAVA_HOME}/*/keytool \
		${JAVA_HOME}/*/orbd \
		${JAVA_HOME}/*/pack200 \
		${JAVA_HOME}/*/policytool \
		${JAVA_HOME}/*/rmid \
		${JAVA_HOME}/*/rmiregistry \
		${JAVA_HOME}/*/servertool \
		${JAVA_HOME}/*/tnameserv \
		${JAVA_HOME}/*/unpack200 \
		${JAVA_HOME}/*/*javafx* \
		${JAVA_HOME}/*/*jfx* \
		${JAVA_HOME}/*/amd64/libdecora_sse.so \
		${JAVA_HOME}/*/amd64/libfxplugins.so \
		${JAVA_HOME}/*/amd64/libglass.so \
		${JAVA_HOME}/*/amd64/libgstreamer-lite.so \
		${JAVA_HOME}/*/amd64/libjavafx*.so \
		${JAVA_HOME}/*/amd64/libjfx*.so \
		${JAVA_HOME}/*/amd64/libprism_*.so \
		${JAVA_HOME}/*/deploy* \
		${JAVA_HOME}/*/desktop \
		${JAVA_HOME}/*/ext/jfxrt.jar \
		${JAVA_HOME}/*/ext/nashorn.jar \
		${JAVA_HOME}/*/javaws.jar \
		${JAVA_HOME}/*/jfr \
		${JAVA_HOME}/*/jfr \
		${JAVA_HOME}/*/jfr.jar \
		${JAVA_HOME}/*/missioncontrol \
		${JAVA_HOME}/*/oblique-fonts \
		${JAVA_HOME}/*/plugin.jar \
		${JAVA_HOME}/*/visualvm \
		${JAVA_HOME}/man \
		${JAVA_HOME}/plugin \
		${JAVA_HOME}/*.txt \
		${JAVA_HOME}/*/*/javaws \
		${JAVA_HOME}/*/*/jjs \
		${JAVA_HOME}/*/*/keytool \
		${JAVA_HOME}/*/*/orbd \
		${JAVA_HOME}/*/*/pack200 \
		${JAVA_HOME}/*/*/policytool \
		${JAVA_HOME}/*/*/rmid \
		${JAVA_HOME}/*/*/rmiregistry \
		${JAVA_HOME}/*/*/servertool \
		${JAVA_HOME}/*/*/tnameserv \
		${JAVA_HOME}/*/*/unpack200 \
		${JAVA_HOME}/*/*/*javafx* \
		${JAVA_HOME}/*/*/*jfx* \
		${JAVA_HOME}/*/*/amd64/libdecora_sse.so \
		${JAVA_HOME}/*/*/amd64/libfxplugins.so \
		${JAVA_HOME}/*/*/amd64/libglass.so \
		${JAVA_HOME}/*/*/amd64/libgstreamer-lite.so \
		${JAVA_HOME}/*/*/amd64/libjavafx*.so \
		${JAVA_HOME}/*/*/amd64/libjfx*.so \
		${JAVA_HOME}/*/*/amd64/libprism_*.so \
		${JAVA_HOME}/*/*/deploy* \
		${JAVA_HOME}/*/*/desktop \
		${JAVA_HOME}/*/*/ext/jfxrt.jar \
		${JAVA_HOME}/*/*/ext/nashorn.jar \
		${JAVA_HOME}/*/*/javaws.jar \
		${JAVA_HOME}/*/*/jfr \
		${JAVA_HOME}/*/*/jfr \
		${JAVA_HOME}/*/*/jfr.jar \
		${JAVA_HOME}/*/*/missioncontrol \
		${JAVA_HOME}/*/*/oblique-fonts \
		${JAVA_HOME}/*/*/plugin.jar \
		${JAVA_HOME}/*/*/visualvm \
		${JAVA_HOME}/*/man \
		${JAVA_HOME}/*/plugin \
		${JAVA_HOME}/*.txt

# Define working directory.
WORKDIR /astrobox/

RUN apt-get update
RUN apt-get install -y --no-install-recommends python-opencv
RUN apt-get install -y --no-install-recommends python-gobject
RUN apt-get install -y --no-install-recommends python-dbus
RUN apt-get install -y --no-install-recommends dbus
RUN mkdir -p /var/run/dbus
VOLUME ["/etc/astrobox"]

EXPOSE 5000
ENTRYPOINT dbus-daemon --system --fork && python /astrobox/run --config /etc/astrobox/config.yaml --host 127.0.0.1
