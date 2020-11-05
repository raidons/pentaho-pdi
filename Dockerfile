# Pentaho/Dockerfile
FROM centos:7
RUN yum -y install epel-release \
  && rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm \
  && yum install java-1.8.0-openjdk -y \
  && yum install webkitgtk -y \
  && yum install unzip -y \
  && yum install wget -y \
  && wget https://sourceforge.net/projects/pentaho/files/latest/download \
  && yum install -y xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils \
  && unzip download -d / \
  && rm -rf download
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data-integration
ENV	KETTLE_HOME=/data-integration
WORKDIR $KETTLE_HOME
ADD sample $KETTLE_HOME
RUN \
  wget https://downloads.sourceforge.net/project/jtds/jtds/1.3.1/jtds-1.3.1-dist.zip \
  && unzip jtds-1.3.1-dist.zip -d lib/ \
  && rm jtds-1.3.1-dist.zip \
  && wget https://github.com/FirebirdSQL/jaybird/releases/download/v4.0.0/jaybird-4.0.0.java8.zip \
  && unzip jaybird-4.0.0.java8.zip -d lib \
  && rm -rf lib/docs/ jaybird-4.0.0.java8.zip \
  && rm -rf lib/release_notes.html \
  && rm -rf CONTRIBUTING.md \
  && yum remove unzip -y \
  && yum remove wget -y \
  && yum remove epel-release -y\
  && yum clean all
RUN pan.sh -file ./plugins/platform-utils-plugin/samples/showPlatformVersion.ktr \
	  && kitchen.sh -file samples/transformations/files/test-job.kjb  
RUN mkdir /jobs
RUN mkdir /output
ENV OUTPUT_PATH=/output
ENV jobs=/jobs
ENV START_MEN=2048m
ENV MAX_MEN=4096m
ADD entrypoint.sh .
ADD spoon.sh .
RUN chmod +x entrypoint.sh \
  && chmod +x spoon.sh
ENTRYPOINT ["./entrypoint.sh"]
CMD ["help"]