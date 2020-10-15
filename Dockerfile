## -*- docker-image-name: "bitrix" -*-
#escape=`
FROM centos:7
LABEL maintainer="mail@iovchinnikov.ru"

# just because i't fun to have it there))
# RUN yum install -y emacs

# D-Bus connection failure workaround
RUN yum -y update; yum clean all
RUN yum -y install systemd; yum clean all; \
	(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*; \
	rm -f /etc/systemd/system/*.wants/*; \
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*; \
	rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

# birtix specific things
RUN yum install -y wget
RUN mkdir btx && cd btx

VOLUME [ "/btx" ]
VOLUME [ "/root/.my.cnf" ]

RUN wget http://repos.1c-bitrix.ru/yum/bitrix-env.sh
RUN chmod +x bitrix-env.sh

RUN ./bitrix-env.sh

