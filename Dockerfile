FROM debian

ENV USERNAME lovebug
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

WORKDIR /tmp

RUN apt-get update && apt-get install -qqy \
      sudo \
      curl \
      vim \
      tmux \
      locales \
      git \
      sshfs \
      openssh-client \
      dnsutils \
      nmap netcat \
      whois \
      wget \
      build-essential \
      python-pip \
      xterm \
      default-jre \
      gcc \
      ruby \
      ruby-dev \
      libcurl4-openssl-dev \
      make \
      cpanminus \
      procps \
      tcpdump \
      ftp \
      zlib1g-dev

RUN useradd -m $USERNAME && \
      echo "$USERNAME:$USERNAME" | chpasswd && \
      usermod --shell /bin/bash $USERNAME && \
      usermod -aG sudo $USERNAME && \
      echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
      chmod 0440 /etc/sudoers.d/$USERNAME && \
      usermod  --uid 1000 $USERNAME && \
      groupmod --gid 1000 $USERNAME

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
      && locale-gen

RUN mkdir /opt/tools

# Searchsploit
RUN echo "\e[1;34mSEARCHSPLOIT\e[0;39m" \
      && git clone https://github.com/offensive-security/exploit-database.git /opt/tools/exploit-database \
      && ln -s /opt/tools/exploit-database/searchsploit /usr/local/bin/searchsploit \
      && cp -n /opt/tools/exploit-database/.searchsploit_rc /home/$USERNAME/

# SQLMap
RUN echo "\e[1;34mSQLMAP\e[0;39m" \
      && git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/tools/sqlmap-dev \
      && ln -s /opt/tools/sqlmap-dev/sqlmap.py /usr/local/bin/sqlmap

# OWASP ZAP
RUN echo "\e[1;34mOWASP ZAP\e[0;39m" \
        && mkdir /opt/tools/zap \
        && wget https://github.com/zaproxy/zaproxy/releases/download/2.7.0/ZAP_2.7.0_Linux.tar.gz \
        && tar zxvf ZAP_2.7.0_Linux.tar.gz -C /opt/tools/zap/ \
        && ln -s /opt/tools/zap/ZAP_2.7.0/zap.sh /usr/local/bin/zap

# WPScan
RUN echo "\e[1;34mWPSCAN\e[0;39m" \
        && git clone https://github.com/wpscanteam/wpscan.git /opt/tools/wpscan \
        && cd /opt/tools/wpscan \
        && gem install bundler \
        && bundle install --without test \
        && ln -s /opt/tools/wpscan/wpscan.rb /usr/local/bin/wpscan

# Gobuster
RUN echo "\e[1;34mGOBUSTER\e[0;39m" \
        && wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz \
        && tar zxvf go1.10.2.linux-amd64.tar.gz -C /usr/local \
        && export PATH=$PATH:/usr/local/go/bin

RUN git clone https://github.com/OJ/gobuster.git /opt/tools/gobuster/ \
        && cd /opt/tools/gobuster/ \
        && sh -c '/usr/local/go/bin/go get; :' \
        && /usr/local/go/bin/go build \
        && ln -s /opt/tools/gobuster/gobuster /usr/local/bin/gobuster

# Hydra
RUN echo "\e[1;34mHYDRA\e[0;39m" \
        && git clone https://github.com/vanhauser-thc/thc-hydra /opt/tools/hydra \
        && cd /opt/tools/hydra \
        && ./configure \
        && make \
        && make install

# John The Ripper
RUN echo "\e[1;34mJOHN THE RIPPER\e[0;39m" \
        && mkdir /opt/tools/john \
        && wget http://www.openwall.com/john/j/john-1.8.0.tar.gz \
        && tar zxvf john-1.8.0.tar.gz -C /opt/tools/john/ \
        && cd /opt/tools/john/john-1.8.0/src \
        && make clean linux-x86-64 \
        && chown -R root:lovebug /opt/tools/john/ \
        && chmod -R 750 /opt/tools/john/

# Dnsenum
RUN echo "\e[1;34mDNSENUM\e[0;39m" \
        && git clone https://github.com/fwaeytens/dnsenum.git /opt/tools/dnsenum \
        && cpanm Net::IP \
        && cpanm Net::DNS \
        && cpanm Net::Netmask \
        && cpanm XML::Writer \
        && cpanm String::Random

RUN chmod +x /opt/tools/dnsenum/dnsenum.pl \
        && ln -s /opt/tools/dnsenum/dnsenum.pl /usr/local/bin/dnsenum \
        && echo "john()\n{\n    /opt/tools/john/john-1.8.0/run/john $@\n}" >> /home/$USERNAME/.bashrc \
        && echo "john()\n{\n    /opt/tools/john/john-1.8.0/run/john $@\n}" >> /root/.bashrc


# The Harvester
RUN echo "\e[1;34mTHE HARVESTER\e[0;39m" \
        && pip install requests \
        && git clone https://github.com/laramies/theHarvester.git /opt/tools/theHarvester \
        && chmod +x /opt/tools/theHarvester/theHarvester.py \
        && ln -s /opt/tools/theHarvester/theHarvester.py /usr/local/bin/theHarvester

# Metaspoit
RUN echo "\e[1;34mTHE HARVESTER\e[0;39m" \
        && mkdir /opt/tools/metaspoit && cd /opt/tools/metaspoit/ \
        && curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall \
        && chmod 755 msfinstall \
        && ./msfinstall

WORKDIR /home/$USERNAME

RUN echo "PS1='\[\e[1;90m\][\[\e[1;91m\]$?\[\e[1;90m\]]-\[\e[1;92m\]\u\[\e[1;90m\]@\[\e[1;92m\]\h\[\e[1;90m\]:\[\e[1;94m\]\w\[\e[1;95m\]\\$\[\e[0;39m\] '" >> /home/$USERNAME/.bashrc
RUN echo "PS1='\[\e[1;90m\][\[\e[1;91m\]$?\[\e[1;90m\]]-\[\e[1;92m\]\u\[\e[1;90m\]@\[\e[1;92m\]\h\[\e[1;90m\]:\[\e[1;94m\]\w\[\e[1;95m\]\\$\[\e[0;39m\] '" >> /root/.bashrc
