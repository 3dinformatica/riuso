# Debian 10 - DocWay Full Stack

#### Prerequisiti
- VirtualBox (https://www.virtualbox.org/) ![VirtualBox][logoVB]
[logoVB]: https://www.smeup.com/wp-content/uploads/2017/07/virtualbox-logo.png "VirtualBox Logo"
- Vagrant (https://www.vagrantup.com/) ![Vagrant][logoVa]
[logoVa]: https://raw.githubusercontent.com/github/explore/80688e429a7d4ef2fca1e82350fe8e3517d3494d/topics/vagrant/vagrant.png "Vagrant  Logo"

Installare il plugin necessario
```vagrant plugin install vagrant-vbguest```

Crea una VM Debian 10 con installato e avviato:

- eXtraWay SE 25.9.x
- MongoDb 3.6.x
- docway-fca 6.0.9
- docway-fcs 6.0.16
- docway-msa 3.0.15
- DocWay4 4.13.2
- DocWay4-service 4.13.2
- 3diws 3.8.10
- ExtraCDBridge 2.24.2
- auditConsole 1.0.1


#### Avvio
Dopo aver scaricato il pacchetto [platform](ftp://ftp.3di.it/extra/platform/eXtraWay-platform-latest-linux.tar.gz) per linux
posizionarsi dentro la cartella del progetto e lanciare ```vagrant up```

#### Accesso alle applicazioni

Per accedere a DocWay4 : http://localhost:18080:/DocWay4/

Per accedere a ExtraCDBridge : http://localhost:18080:/ExtraCDBridge/Login


#### Pulizia
Per eliminare la vm da VirtualBox lanciare ```vagrant destroy --force```
