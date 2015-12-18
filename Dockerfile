######################################################
#
# Slurm Server

FROM runefriborg/docker-c6-supervisord

MAINTAINER Rune Friborg <runef@birc.au.dk>

# Add munge user
#RUN adduser slurm && \
#    echo "slurm:slurm" | chpasswd
#USER slurm
#RUN mkdir /home/slurm/.ssh
#ADD ssh/id_rsa.pub /home/slurm/.ssh/authorized_keys
#USER root

# Install slurm
RUN yum -y install openssh-server gcc gcc-g++ make munge munge-devel httpd bzip2 vim-minimal tar perl git mysql-server mysql-devel lua lua-devel

# Configure munge
RUN create-munge-key && \
  chown -R root:root /var/log/munge && \
  chown -R root:root /var/lib/munge && \
  mkdir /var/run/munge && \
  chown -R root:root /var/run/munge && \
  chown -R root:root /etc/munge 

# Install slurm
WORKDIR /usr/local
RUN git clone https://github.com/SchedMD/slurm.git
WORKDIR /usr/local/slurm
RUN git checkout tags/slurm-15-08-4-1

RUN ./configure --prefix=/opt/slurm --sysconfdir=/opt/slurm/etc --silent --with-mysql_config=/usr/bin/ CFLAGS=-Os && \
  make && \
  make install && \
  cd contribs/lua && \
  make install



#RUN mkdir -p /etc/sysconfig/slurm

#RUN \
#  cp etc/init.d.slurm /etc/init.d/slurmd  && \
#  chmod +x /etc/init.d/slurmd && \
#  cp -rf doc/html /var/www/html/slurm && \
#  chown -R apache:apache /var/www/html/slurm && \
#  mkdir /var/log/slurm && \
#  touch /var/log/slurm/job_completions && \
#  touch /var/log/slurm/accounting && \
#  touch /var/log/slurm/slurmdbd.log && \
#  chown -R slurm:slurm /var/log/slurm && \
#  touch /var/spool/last_config_lite && \
#  touch /var/spool/last_config_lite.new && \
#  chown slurm:slurm /var/spool/last_config_lite* && \
#  chown root:slurm /var/spool && \
#  chmod g+w /var/spool
#

RUN adduser testuser && \
    echo "testuser:testuser" | chpasswd && \
    echo "export PATH=/opt/slurm/bin:\$PATH" >> /home/testuser/.bashrc

ADD root /

RUN chown testuser:testuser /home/testuser/slurm.submit

RUN \
  /etc/init.d/mysqld start && \
  mysqladmin -u root password 'seCret' && \
  /usr/sbin/munged && \
  /opt/slurm/sbin/slurmdbd && \
  /opt/slurm/bin/sacctmgr -i add cluster cluster0 && \
  /opt/slurm/bin/sacctmgr -i add account basic cluster=cluster0 Description="The One node cluster" Organization="Big O" && \
  /opt/slurm/bin/sacctmgr -i add user testuser DefaultAccount=basic Account=basic && \
  rm -f var/run/munge/munge.socket.* && \
  /etc/init.d/mysqld stop

EXPOSE 10389 22 6817 6818
