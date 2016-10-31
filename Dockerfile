FROM bytesized/debian-base

# Speed up APT
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
  && echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# This adds ~30MB worth of deps, might want to consider doing the java adding manually
RUN apt-get install -y software-properties-common

# Auto-accept Oracle JDK license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
      echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
      apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update \
    && apt-get install -y oracle-java8-installer

RUN apt-get install -y inotify-tools
RUN mkdir /app/
RUN wget -O /app/filebot.deb 'https://app.filebot.net/download.php?type=deb&arch=amd64&version=4.7.2' && \
    dpkg -i /app/filebot.deb && rm /app/filebot.deb

RUN wget -O /app/monitor.sh \
  'https://raw.githubusercontent.com/coppit/docker-inotify-command/7be05137c367a7bbff6b7980aa14e8af0c24eca6/monitor.sh' && \
  chmod +x /app/monitor.sh

VOLUME /config /host

COPY static /
