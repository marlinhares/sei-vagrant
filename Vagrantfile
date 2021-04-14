# -*- mode: ruby -*-
# vi: set ft=ruby :

# Alerta para instalação e configuração do plugin vbguest para atualização do
# VirtualBox Guest Additions
unless Vagrant.has_plugin?("vagrant-vbguest")
  warn "\n\n**********************************************************\n\n"+
       "                          ATENÇAO !!!                        \n\n"+
       "Não foi localizado o plugin vagrant-vbguest na máquina host. \n\n"+
       "Recomendamos seu uso para evitar incompatibilidades de versões \n"+
       "entre o Virtualbox e VBGuest Addition, impactando o          \n"+
       "compartilhamento de pastas. \n\n"+
       "Para solucionar o problema, execute o seguinte comando no \n"+
       "diretório raiz do projeto. \n\n"+
       "> vagrant plugin install vagrant-vbguest                     \n"+
       "\n********************************************************** \n\n"+
       " Pressione ENTER para continuar ou (Ctrl + C) para finalizar ... \n\n"

  $stdin.gets; puts "\n"
end

Vagrant.configure(2) do |config|
  ## Instalação de plugin para configuração automática do disco
  required_plugins = %w( vagrant-vbguest vagrant-disksize )
  _retry = false
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      system "vagrant plugin install #{plugin}"
      _retry=true
    end
  end

  if (_retry)
    exec "vagrant " + ARGV.join(' ')
  end
  
  # Box do vagrant contendo o ambiente de desenvolvimento do SEI
  config.vm.box = "sei-vagrant"
  config.disksize.size = "100GB"
  config.vbguest.auto_update = true
  config.vbguest.no_remote = false
  config.vbguest.iso_mount_point = "/media"
  config.vbguest.installer_options = { allow_kernel_upgrade: true }

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096", "--usb", "off", "--audio", "none"]
  end
  
  # Configuração do diretório local onde deverá estar disponibilizado os códigos-fontes do SEI (sei, sip, infra_php, infra_css, infra_js)
  config.vm.synced_folder ".", "/mnt/sei/src", mount_options: ["dmode=777", "fmode=777"]


  # Configuração do redirecionamento entre Máquina Virtual e Host
  config.vm.network :forwarded_port, guest: 8000,   host: 8000   # SIP e SEI (Apache)
  config.vm.network :forwarded_port, guest: 1521, host: 1521 # Banco de Dados (Oracle)
  config.vm.network :forwarded_port, guest: 1433, host: 1433 # Banco de Dados (SQL Server)
  config.vm.network :forwarded_port, guest: 3306, host: 3306 # Banco de Dados (Mysql)
  config.vm.network :forwarded_port, guest: 8983, host: 8983 # Solr Indexer (Jetty)
  config.vm.network :forwarded_port, guest: 8080, host: 8080 # Jod Converter
  config.vm.network :forwarded_port, guest: 1080, host: 1080 # MailCatcher

  config.vm.provision "docker-start", type: "shell", run: "always" do |s|
    s.inline = <<-EOF
      /bin/systemctl start docker.service
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env down
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env up -d
    EOF
  end

  config.vm.provision "mysql", type: "shell", run: "never" do |s|
    s.inline = <<-EOF      
      /bin/systemctl start docker.service
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env down
      sudo ln -s --force /env-mysql /.env
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env up -d
    EOF
  end

  config.vm.provision "sqlserver", type: "shell", run: "never" do |s|
    s.inline = <<-EOF
      /bin/systemctl start docker.service
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env down
      sudo ln -s --force /env-sqlserver /.env
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env up -d
    EOF
  end

  config.vm.provision "oracle", type: "shell", run: "never" do |s|
    s.inline = <<-EOF
      /bin/systemctl start docker.service
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env down
      sudo ln -s --force /env-oracle /.env
      /usr/local/bin/docker-compose -f /docker-compose.yml --env-file /.env up -d
    EOF
  end

  config.vm.post_up_message = <<-EOF

=========================================================================
  INICIALIZAÇÃO DO AMBIENTE DE DESENVOLVIMENTO FINALIZADA COM SUCESSO ! 
=========================================================================

= Endereços de Acesso à Aplicação ========================================
SEI ............................... http://localhost:8000/sei
SIP ............................... http://localhost:8000/sip

= Outros Serviços ========================================================
Solr .............................. http://localhost:8983/solr
MailCatcher ....................... http://localhost:1080
Mysql ............................. localhost:3306
Oracle ............................ localhost:1521
SQLServer ......................... localhost:1433

= Comandos Úteis =========================================================
vagrant up                        - Inicializar ambiente do SEI
vagrant halt                      - Desligar ambiente
vagrant destroy                   - Destruir ambiente e base de testes
vagrant ssh                       - Acessar máquina virtual
vagrant status                    - Verificar situação atual do ambiente

Utilize o parâmetro '--provision-with' para alterar o banco de dados padrão:

vagrant up --provision-with [mysql|oracle|sqlserver]
-- ou --
vagrant provision --provision-with [mysql|oracle|sqlserver]

EOF
end
