FROM phusion/baseimage:0.9.19
MAINTAINER Slawomir Rozbicki <docker@rozbicki.eu>

RUN apt-get -qq update \
&& apt-get -y install ssmtp build-essential git lm-sensors nodejs python python-mysqldb python-yaml \
autoconf autogen automake uuid-dev zlib1g-dev pkg-config

RUN git clone https://github.com/firehol/netdata.git /netdata.git --depth=1

WORKDIR /netdata.git

RUN ./netdata-installer.sh --dont-wait --dont-start-it

WORKDIR /
RUN rm -rf /netdata.git

RUN apt-get purge -y build-essential git && apt-get clean && apt-get -y autoremove

RUN ln -sf /dev/stdout /var/log/netdata/access.log \
&& ln -sf /dev/stdout /var/log/netdata/debug.log \
&& ln -sf /dev/stderr /var/log/netdata/error.log

ENV NETDATA_PORT=19999

RUN sed -i 's/^exit 0/\/usr\/sbin\/netdata -D -u root -s \/host -p ${NETDATA_PORT}\n\nexit 0/g' /etc/rc.local
RUN chown root:root /usr/share/netdata -R

CMD ["/sbin/my_init"]

