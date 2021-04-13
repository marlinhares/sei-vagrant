#!/usr/bin/env bash

yum -y  update

# Instalação dos componentes básicos do servidor web apache
yum -y install httpd memcached openssl wget curl unzip gcc java-1.8.0-openjdk libxml2 cabextract xorg-x11-font-utils fontconfig mod_ssl


# Instalação dos componentes básicos do servidor web apache
yum -y install epel-release  yum-utils
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum -y  update
yum -y install epel-release libmcrypt gcc libxml2 crontabs 

# Instalação do PHP e demais extenções necessárias para o projeto
yum -y install php php-common php-cli php-pear php-bcmath php-gd php-gmp php-imap php-intl php-ldap php-mbstring php-mysqli \
    php-odbc php-pdo php-pecl-apcu php-pspell php-zlib php-snmp php-soap php-xml php-xmlrpc php-zts php-devel \
    php-pecl-apcu-devel php-pecl-memcache php-calendar php-shmop php-intl php-mcrypt \
    gearmand libgearman libgearman-devel php-pecl-gearman vixie-cron \
    freetds freetds-devel php-mssql \
    git nc gearmand libgearman-dev libgearman-devel mysql

# Configuração do pacote de línguas pt_BR
localedef pt_BR -i pt_BR -f ISO-8859-1

# Instalação do componentes UploadProgress
# pecl install uploadprogress-1.0.3.1
# echo "extension=uploadprogress.so" >> /etc/php.d/uploadprogress.ini

cd /tmp
tar -zxvf uploadprogress.tgz
cd uploadprogress
phpize
./configure --enable-uploadprogress
make
make install
echo "extension=uploadprogress.so" > /etc/php.d/uploadprogress.ini
cd -

# Instalação de pacote de fontes do windows
rpm -Uvh /tmp/msttcore-fonts-2.0-3.noarch.rpm

# Instalação dos componentes de conexão do Oracle (Oracle Instant Client)
 bash /tmp/install_oracle.sh


# Configuração de permissão do diretório de arquivos
mkdir -p /var/sei/arquivos
chmod -R 777 /var/sei/arquivos

# Configuração dos serviços de background do Cron
mkdir /var/log/sei
sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond
echo "0 * * * * root /usr/bin/php -c /etc/php.ini /opt/sei/scripts/AgendamentoTarefaSEI.php 2>&1 >> /var/log/sei/agendamento_sei.log" > /etc/cron.d/sei
echo "0 * * * * root /usr/bin/php -c /etc/php.ini /opt/sip/scripts/AgendamentoTarefaSip.php 2>&1 >> /var/log/sip/agendamento_sip.log" > /etc/cron.d/sip
echo "00 01 * * * root rm -rf /opt/sei/temp/*" >> /etc/cron.d/sei
echo "00 01 * * * root rm -rf /opt/sip/temp/*" >> /etc/cron.d/sip

# Remover arquivos temporários
rm -rf /tmp/*
yum clean all

# Configuração de permissões de execução no script de inicialização do container
chmod +x /entrypoint.sh
