.PHONY: build-containers build-vm install-vm clean

VERSAO_CONTAINERS='1.0'

build: build-containers build-vm

clean:
	docker rmi --force sei4_solr-8.2 || true
	docker rmi --force sei4_jod-2.2.2 || true
	docker rmi --force sei4_mysql-5.7 || true
	docker rmi --force sei4_oracle-11g || true
	docker rmi --force sei4_httpd-2.4 || true
	docker rmi --force sei4_mailcatcher || true
	docker rmi --force sei4_sqlserver-2017 || true


build-containers: clean
	docker build -t sei4_solr-8.2 solr/
	docker tag sei4_solr-8.2 processoeletronico/vagrant-sei4_solr:latest
	docker tag sei4_solr-8.2 processoeletronico/vagrant-sei4_solr:$(VERSAO_CONTAINERS)

	docker build -t sei4_jod-2.2.2 jod/
	docker tag  sei4_jod-2.2.2 processoeletronico/vagrant-sei4_jod:latest
	docker tag  sei4_jod-2.2.2 processoeletronico/vagrant-sei4_jod:$(VERSAO_CONTAINERS)

	docker build -t sei4_mysql-5.7 mysql/
	docker tag sei4_mysql-5.7 processoeletronico/vagrant-sei4_mysql5.7:latest
	docker tag sei4_mysql-5.7 processoeletronico/vagrant-sei4_mysql5.7:$(VERSAO_CONTAINERS)

	docker build -t sei4_oracle-11g oracle/
	docker tag  sei4_oracle-11g processoeletronico/vagrant-sei4_oracle:latest
	docker tag  sei4_oracle-11g processoeletronico/vagrant-sei4_oracle:$(VERSAO_CONTAINERS)

	docker build -t sei4_httpd-2.4 httpd/
	docker tag sei4_httpd-2.4 processoeletronico/vagrant-sei4_httpd:latest
	docker tag sei4_httpd-2.4 processoeletronico/vagrant-sei4_httpd:$(VERSAO_CONTAINERS)

	docker build -t sei4_mailcatcher mailcatcher
	docker tag sei4_mailcatcher processoeletronico/vagrant-sei4_mailcatcher:latest
	docker tag sei4_mailcatcher processoeletronico/vagrant-sei4_mailcatcher:$(VERSAO_CONTAINERS)

	docker build -t sei4_memcached memcached
	docker tag sei4_memcached  processoeletronico/vagrant-sei4_memcached:latest
	docker tag sei4_memcached  processoeletronico/vagrant-sei4_memcached:$(VERSAO_CONTAINERS)

	docker build -t sei4_sqlserver-2017 sqlserver
	docker tag sei4_sqlserver-2017 processoeletronico/vagrant-sei4_sqlserver:latest
	docker tag sei4_sqlserver-2017 processoeletronico/vagrant-sei4_sqlserver:$(VERSAO_CONTAINERS)

	docker push processoeletronico/vagrant-sei4_solr:$(VERSAO_CONTAINERS)
	docker push processoeletronico/vagrant-sei4_jod:$(VERSAO_CONTAINERS)
	docker push processoeletronico/vagrant-sei4_mysql5.7:$(VERSAO_CONTAINERS)
	docker push processoeletronico/vagrant-sei4_oracle:$(VERSAO_CONTAINERS)
	docker push processoeletronico/vagrant-sei4_httpd:$(VERSAO_CONTAINERS)
	docker push processoeletronico/vagrant-sei4_mailcatcher:$(VERSAO_CONTAINERS)
	docker push processoeletronico/vagrant-sei4_memcached:$(VERSAO_CONTAINERS)
	docker push processoeletronico/vagrant-sei4_sqlserver:$(VERSAO_CONTAINERS)

	docker push processoeletronico/vagrant-sei4_solr:latest
	docker push processoeletronico/vagrant-sei4_jod:latest
	docker push processoeletronico/vagrant-sei4_mysql5.7:latest
	docker push processoeletronico/vagrant-sei4_oracle:latest
	docker push processoeletronico/vagrant-sei4_httpd:latest
	docker push processoeletronico/vagrant-sei4_mailcatcher:latest
	docker push processoeletronico/vagrant-sei4_memcached:latest
	docker push processoeletronico/vagrant-sei4_sqlserver:latest


build-vm:
	rm -rf dist/* || true
	packer build -force sei-vagrant.json


install-vm:
	vagrant box remove sei-vagrant || true
	vagrant box add sei-vagrant ./dist/package.box

