# Descrizione del progetto di Riuso

3D Informatica vanta oltre trent’anni di esperienza al servizio di Pubbliche Amministrazioni, locali e centrali, complesse e articolate, alle quali viene offerto un supporto totale rispetto a tutti i processi di progettazione, sviluppo, mantenimento e miglioramento di sistemi informativi.

Nel rispetto delle novità introdotte dal piano triennale per l’informatica nella Pubblica Amministrazione e delle linee guida su acquisizione e riuso di software per le Pubbliche Amministrazioni, e grazie al supporto di ADER (Agenzia Delle Entrate/Riscossione) l'azienda ha avviato come incaricata il progetto di riuso di alcuni moduli software, sviluppati per conto di ADER ed imperniati attorno al sistema di gestione documentale e protocollo informatico DocWay.

Il **progetto di riuso** si articola dunque attraverso la liberazione del sorgente di questi moduli software ed il rilascio dell'applicazione DocWay in formato eseguibile, per abilitare qualsiasi utilizzatore ad avere con pochi click ed una procedura di installazione semplificata, un sistema documentale di protocollo completo e ricco di funzionalità, compliant con la normativa e basato su standard archivistici.

Allo stesso tempo i moduli dei quali viene liberato il codice sorgente, possono essere utilizzati sia in combinazione con l'applicazione documentale scaricata e rilasciata in questo repository come dipendenza al fine di estenderne le funzionalità e le capacità, sia come progetti software a se stanti, ciascuno dei quali in grado di operare ad uno strato più "generico" con specifiche finalità.

La licenza di distribuzione open source scelta dall'Amministrazione è la **Affero General Public License (AGPL) v3.** 

Per ciascun modulo descritto di seguito, vengono indicate le funzionalità principali e l'architettura del modulo stesso, il flusso di esecuzione, le dipendenze, le modalità di installazione e di utilizzo così come suggerimenti per gli sviluppatori che dovessero usare il codice liberato per implementarlo in proprie applicazioni.

|Repository Moduli| 
|--|
|[Modulo FCA](https://github.com/3dinformatica/docway-fca)| 
|[Modulo FCS](https://github.com/3dinformatica/docway-fcs)| 
|[Modulo Console AUDIT](https://github.com/3dinformatica/auditConsole)| 
|[Modulo MSA](https://github.com/3dinformatica/docway-msa)| 
||
|[**Istruzioni per le dipendenze eXtraWay e DocWay**](https://github.com/3dinformatica/riuso/blob/master/README.md#istruzioni-per-le-dipendenze-extraway-e-docway)| 
||

## [FCA](https://github.com/3dinformatica/docway-fca)/[FCS](https://github.com/3dinformatica/docway-fcs) 

###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso)

FCA (File Conversion Agent) e FCS (File Conversion Service) consistono in due processi che permettono l'**estrazione del testo da files** e la **conversione di files in un differente formato** (es. da DOC a PDF). 

Lo scenario di utilizzo può variare a seconda del carico di lavoro:
- In ambienti di ridotte dimensioni (carico di lavoro non elevato) entrambi i processi possono essere installati (e configurati) sullo stesso server;
- In ambienti con un elevato carico di lavoro (in termini di numero di richieste) è possibile scalare l'attività di estrazione testo e conversione su più server. In questo scenario verrà installato **una e una sola istanza di FCA** (che si occuperà di recuperari i lavori da portare a termine) e **N istanze di FCS** (su differenti server) che si occuperanno di elaborare i file e registrare il risultato dell'attività richiesta.

### Flusso di esecuzione

La logica secondo la quale viene svolta tale attività è descritta di seguito:
- FCA si occupa di recuperare tutti i lavori pendenti (richieste di estrazione e/o conversione) e di gestire la coda di lavori pendenti e la comunicazione con il pool di FCS. All'avvio della comunicazione con ogni istanza di FCS viene inviato un set di informazioni inerenti la configurazione dell'ambiente (timeout da applicare all'elaborazione, eventuali estensioni di file da ignorare, etc.);
- Ogni FCS riceve un lavoro da eseguire da parte di FCA, esegue l'attività richiesta e registra il risultato (caricamento dei file prodotti dalla conversione e/o del testo estratto);
- Al termine dell'elaborazione FCS comunica a FCA l'esito dell'attività in modo da poter ricevere il lavoro successivo.

### Descrizione dei progetti

I progetti di FCA e FCS (progetti _JAVA_) sono stati suddivisi in 2 librerie che corrispondo a:
- Logiche generiche utilizzatibili in differenti ambiti (progetti abstract);
- Implementazioni specifiche per uno scenario (nel nostro caso DocWay).

In base alla struttura appena descritta, è quindi possibile utilizzare le librerie abstract per poter gestire scenari differenti da quello DocWay (è sufficiente realizzare le implementazioni richieste dai progetti abstract). Per maggiori dettagli sull'attività si rimanda alla documentazione specifica dei progetti.

#### FCA

**it.tredi.abstract-fca**: Configurazione del POOL di FCS con gestione del recupero e assegnazione dei lavori ai differenti processi di FCS (su server distinti).

**it.tredi.docway-fca**: Implementazione per DocWay di FCA, ovvero recupero dei documenti di DocWay da processare (documenti contenenti allegati per i quali è richiesta la conversione e/o estrazione del testo).


#### FCS


**it.tredi.abstract-fcs**: Elaborazione vera e propria dei files. Logiche di conversione e estrazione testo dai file (integrazione con le varie dipendenze software).

**it.tredi.docway-fcs**: Implementazione per DocWay di FCS (aggiornamento dell'esito dei lavori, registrazione dei file convertiti, indicizzazione del testo contenuto negli allegati del documento, etc.).


### Requisiti

Requisiti per l'esecuzione di conversioni e estrazione di testo da parte di FCS:
- OpenOffice
- ImageMagick
- Tesseract


## [Console Audit](https://github.com/3dinformatica/auditConsole)

###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso)

Web Application grazie alla quale è possibile consultare i dati di audit registrati per uno o più applicativi. L'interfaccia web realizzata permette (previa autenticazione e autorizzazione) diversi filtri di ricerca sui risultati registrati tramite AUDIT:
- Filtro su archivio (nome del database)
- Filtro su tipologia di operazione (modifica, login, etc.) - Non ci sono vincoli sulle tipologie di operazioni utilizzabili
- Filtro su utente (operatore esecutore dell'attività)
- Filtro su data e ora
- Filtro su tipologia di record
- Filtro su identificativo del record

Esempi classici di ricerche che possono essere svolte agevolmente tramite console sono le seguenti:
- Elenco di tutte le attività svolte su uno specifico record;
- Elenco di tutte le attività svolte da un utente in un determinato periodo di tempo;
- Elenco di tutte le attività di una specifica tipologia;
- etc.

I dati di AUDIT sul database mongodb vengono registrati attraverso un'apposita librieria realizzata per DocWay. È comunque possibile implementare una propria versione della registrazione del record di AUDIT (per un qualsiasi applicativo) e utilizzare la console di AUDIT per la consultazione dei dati.

Altri attività previste altre alla classica ricerca sono:
- Esportazione CSV dei dati di AUDIT;
- Validazione del record di AUDIT tramite specifico checksum (record di audit non alterato su archivio MongoDB).

### Prerequisiti

- JAVA
- Application Server (es. Tomcat)
- MongoDB

### Formato del Record

Di seguito è descritto il formato del record di AUDIT registrato su archivio MongoDB. Per utilzzare la console su una qualsiasi altra applicazione è sufficiente registrare sull'archivio MongoDB le attività degli utenti secondo il formato indicato.

```json
{
    "_id" : ObjectId("5b18e187f41b7e14cd037603"),
    "archivio" : "xdocwaydoc",
    "nrecord" : "00239115",
    "tipoRecord" : "doc",
    "user" : {
        "username" : "sstagni",
        "codUser" : "PI000008",
        "ipAddress" : "127.0.0.1"
    },
    "tipoAzione" : "MODIFICA_RECORD",
    "data" : ISODate("2018-06-07T07:40:55.728Z"),
    "changes" : [ 
        {
            "field" : "doc.extra.raccIndice.@stato",
            "before" : "lavorazione",
            "after" : "completato"
        }
    ]
}
```

| Campo | Descrizione |
|--|--|
| _id |  Identificaivo del record su MongoDB (record di Audit) |
| archivio | Nome del database utilizzato dall'applicazione sottoposta a AUDIT (supporto ad applicazioni multi-database) |
| nrecord | Identificato del record dell'applicativo |
| tipoRecord | Identifica la tipologia di record al quale l'audit fa riferimento |
| user | Informazioni relative all'utente che ha svolto l'attività (username, identificativo, etc.) |
| tipoAzione | Tipologia di azione svolta (tipicamente dipendente dall'applicazione sottoposta a AUDIT) |
| data | Data e Ora di svolgimento dell'azione da parte dell'utente |
| changes | Elenco di modifiche apportate al record (per ogni campo viene indicato il valore precedente alla modifica e quello successivo) |

## [MSA](https://github.com/3dinformatica/docway-msa)

###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso)

MSA (Mail Storage Agent) è un servizio Java multi-processo che si occupa delle seguenti operazioni:
* archiviazione delle email PEC e non (le mail vengono trasformate e salvate in documenti in DocWay XML);
* scambio di documenti tra sistemi DocWay XML differenti mediante la posta elettronica certificata (interoperabilità);
* Completa gestione del processo di interfacciamento con lo SdI per le fatture elettroniche.
MSA lavora esaminando periodicamente delle caselle di posta (certificate o meno) e dispone di una sua specifica console di amministrazione e controllo.

Sebbene il presente modulo sia rilasciato nella modalità open source, è possibile estendere questo servizio unicamente nello scenario DocWay e eXtraWay. 

Di seguito le funzionalità offerte:
- Architettura software, modulare, espandibile e facilmente personalizzabile tramite l'implementazione di apposite interfacce per:
    + personalizzare il comportamento di archiviazione di caselle di posta elettronica;
    + leggere le configurazioni delle caselle di posta (e eventualmente estenderle) su sistemi differenti da ACL;
    + archiviare le email su sistemi differenti da DocWay.
- Worker concorrenti in grado di effettuare l'archiviazione in parallelo di più caselle di posta abbattendo i tempi di archiviazione (in particolare nel caso di numerose caselle di posta elettronica da gestire).
- Produzione su MongoDB di rapporti di Audit per ogni sessione di archiviazione di ogni singola casella di posta elettronica. In caso di errore verrà memorizzato l'intero EML per agevolare le operazioni di monitoraggio, controllo errori e eventuale risoluzione di problemi.
- Console WEB di monitoraggio per individuare agevolmente le email che sono andate in errore e per effettuare nuovamente l'elaborazione.

### Prerequisiti:
1. _Java8_
2. MongoDB (vers. 3.6.3)

## Istruzioni per le dipendenze eXtraWay e DocWay

###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso)

eXtraWay e DocWay, applicazioni rilasciate in formato eseguibile come dipendenze dei moduli liberati nei diversi repository pubblicati, possono essere installati in due differenti modalità.

* creazione di una VM gestita da Vagrant, che consente l'installazione completa delle dipendenze (eXtraWay e DocWay) e di tutti i moduli presenti (FCA/FCS, MSA, AUDIT, BRIDGE).

* installazione dei singoli pacchetti di eXtraWay e DocWay.

|Istruzioni per le dipendenze eXtraWay e DocWay| 
|--| 
|[**Istruzioni installazione eXtraWay come platform**](https://github.com/3dinformatica/riuso/blob/master/README.md#istruzioni-installazione-extraway-come-platform)| 
|[- Installazione su piattaforma Windows di Extraway Platform](https://github.com/3dinformatica/riuso/blob/master/README.md#--installazione-su-piattaforma-windows-di-extraway-platform)|
|[ -- Uso di Antivirus nelle installazioni eXtraWay](https://github.com/3dinformatica/riuso/blob/master/README.md#uso-di-antivirus-nelle-installazioni-extraway)
|[- Installazione su piattaforma Linux di ExtraWay Platform](https://github.com/3dinformatica/riuso/blob/master/README.md#--installazione-su-piattaforma-linux-di-extraway-platform)| 
|[**Istruzioni installazione DocWay**](https://github.com/3dinformatica/riuso/blob/master/README.md#istruzioni-installazione-docway)| 
|[- Installazione su piattaforma Windows di DocWay4](https://github.com/3dinformatica/riuso/blob/master/README.md#--installazione-su-piattaforma-windows-di-docway-4)|
|[- Installazione su piattaforma Linux di DocWay4](https://github.com/3dinformatica/riuso/blob/master/README.md#--installazione-su-piattaforma-linux-di-docway-4)|

### 1. VM gestita da vagrant
___
Installazione VirtualBox       https://www.virtualbox.org/

Installazione Vagrant          https://www.vagrantup.com/


1) Dopo aver installato le due applicazioni installare il plugin che permette a Vagrant di comunicare con virtualbox


    - Da una shell lanciare: vagrant plugin install vagrant-vbguest


2) Posizionarsi dentro la cartella appena scaricata e lanciare il comando: vagrant up


Dopo aver testato il funzionamento fare pulizia con il comando: vagrant destroy --force


### 2. Installazione singoli pacchetti
___
#### Istruzioni installazione eXtraWay come platform

###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso) - [[Torna a *Istruzioni per le dipendenze eXtraWay e DocWay*]](https://github.com/3dinformatica/riuso/blob/master/README.md#istruzioni-per-le-dipendenze-extraway-e-docway)

#### - Installazione su piattaforma Windows di eXtraWay Platform
___
##### Requisiti Hardware

Le specifiche della macchina server dipendono principalmente dal numero di utenti che utilizzerà l'applicativo e dal tipo di utilizzo. In linea di massima le prestazioni di eXtraWay dipendono dalla velocità dei dispositivi di memorizzazione, dalla velocità della rete e, per la gestione di allegati non testuali, dalla memoria RAM.

###### Requisiti Minimi

* Processore Intel Xeon 2.00 Ghz o compatibile
* 2 GB di RAM
* Disco rigido dedicato con almeno 100 GB (per un archivio medio con allegati)

###### Consigliati

Per un utilizzo medio: circa 30 utenti collegati contemporaneamente, un milione di documenti.

  * Processore Intel Xeon multicore o compatibile
  * 4 GB di RAM
  * Almeno 3 dischi SATA in RAID 5 o un sistema alternativo di memorizzazione
  * Almeno 300 GB sul sitema di memorizzazione scelto
  * Scheda di rete Gigabit o superiore
  * Alimentazione tramite gruppo di continuità

##### Requisiti software

**Server**

* Windows server 2003 sp2

* Windows server 2008 r2 64bit

* Windows server 2012 64bit

* Antivirus che possa essere configurato con eccezioni per quanto riguarda il controllo dei processi (ad esempio panda non funziona)

###### Installazione

**Pacchetto eXtraWay Platform**

Il pacchetto ExtraWay Platform è suddiviso in cartelle, di seguito la funzione di ogni componente:

* **jre:** Contiene il Java Runtime Environment (jre-1_6_0_20).
* **LibreOffice:** contiene l'eseguibile per l'installazione di LibreOffice, utilizzato per la conversione degli allegati.
* **tomcat:** contiene l'applicativo Apache Tomcat che ospita l'applicazione java.
* **3di.it\console\xway:** contiene la console java e il suo file di contesto xway.xml da utilizzare con tomcat.
* **3di.it\platform:** contiene i due servizi che compongono il sistema di conversione/indicizzazione dei file, FCA e FCS.
* **3di.it\webservices:** al suo interno sono presenti, il client e il servizio SOAP, che pubblicano I metodi di accesso diretto a Extraway, e danno la possibilità di interfacciare applicativi esterni sulla base documentale.
* **3di.it\extraway\xw:** cartella contenente il server per il database eXtraWay.
* **3di.it\extraway\xw\db:** Contiene un archivio di esempio con alcuni record di esempio, utilizzabile con i webservices.
* **xw3rdparts:** contiene librerie di terze parti per la manipolazione degli xml e la compressione di files con le rispettive licenze d'uso.
* **fcs_utils:** contiene contiene le utility di terze parti per la conversione degli allegati.
___
**Java**

Eseguire il setup di java dalla cartella Jre del pacchetto.

Non è necessario cambiare alcuna configurazione durante l'esecuzione del setup. Di base il Java Runtime Environment ha come destinazione **C:\Programmi\Java\jre6\**.
___
**Tomcat**

Eseguire il setup di tomcat dalla cartella del pacchetto. Anche qui non è necessario modificare alcuna impostazione durante l'esecuzione del setup and eccezione della cartella di destinazione: **e:\Programmi\Apache Software Foundation\Tomcat 6.0**

* Cambiare la directory di installazione di Tomcat in **e:\Programmi\Apache Software Foundation\Tomcat 6.0**

Una volta terminata l'installazione apparirà un icona con il logo di Apache Tomcat nel System Tray.

* Col tasto destro del mouse accedere al menu **"Configure..."**

Nella prima pagina **"General"** l'avvio di Tomcat è impostato su **manuale**:

* Cambiare l'impostazione **"Startup Type"** in **"Automatic"**.

Nella pagina **"Java"**:

* Indicare il percorso: **C:\Programmi\Java\jre6\bin\client\jvm.dll in "Java Virtual Machine"**.
* Indicare "1024" in "Maximum Memory Pool". (La quantità di memoria massima che Tomcat può utilizzare non dovrebbe mai essere impostata a meno di 1GB, per evitare che, durante lo scaricamento o l'inserimento di file molto grandi, si esaurisca la memoria disponibile. Tuttavia questo valore può essere aumentato se c'è disponibilità sul sistema.)

Per poter utilizzare l'utente base di Tomcat (solitamente admin) per accedere alla console è necessario inserire il valore "admin" al file **tomcat-users.xml**:

    <user username="admin" password="xxxxxx" roles="admin,manager"/>

* Inserire nel valore **role** dell'utente admin nel file **e:\Programmi\Apache Software Foundation\Tomcat 6.0\conf\tomcat-users.xml** il valore **admin**.

###### Cifratura delle password nel tomcat-users.xml

Di base le password all'interno del file tomcat-users.xml sono in chiaro, per abilitare la cifratura è necessario inserire il parametro "digest=MD5" nel server.xml di Tomcat:

    <!-- This Realm uses the UserDatabase configured in the global JNDI resources under the key "UserDatabase".  
    Any edits that are performed against this UserDatabase are immediately available for use by the Realm.  -->  
    <Realm className="org.apache.catalina.realm.UserDatabaseRealm" resourceName="UserDatabase" digest="MD5"/>

* Inserire il parametro **"digest=MD5"** all'interno dell'attributo **"Realm"** (UserDatabase)" nel file **e:\Programmi\Apache Software Foundation\Tomcat 6.0\conf\server.xml**

###### Abilitare permessi di scrittura sul tomcat-users.xml

Di base il file tomcat-users.xml è aperto in sola lettura, per abilitare il permesso di scrittura è necessario inserire il parametro **"readonly=false"** nel server.xml di Tomcat:

    <GlobalNamingResources>  
    <!-- Editable user database that can also be used by  
    UserDatabaseRealm to authenticate users  
    -->  
    <Resource name="UserDatabase" auth="Container"  
    type="org.apache.catalina.UserDatabase"  
    description="User database that can be updated and saved"  
    factory="org.apache.catalina.users.MemoryUserDatabaseFactory"  
    pathname="conf/tomcat-users.xml" readonly="false" />  
    </GlobalNamingResources>

* Inserire il parametro **"readonly=false"** all'interno dell'attributo **"Realm"** (UserDatabase) nel file **e:\Programmi\Apache Software Foundation\Tomcat 6.0\conf\server.xml**
___
**Console**

Di base l'applicativo viene installato nel disco dedicato che per comodità indicheremo come e:

* Copiare la cartella 3di.it dal cd in e:\

Per fare in modo che tomcat visualizzi l'applicazione è necessario copiare il file di configurazione **xway.xml** all'interno della cartella di configurazione di tomcat:

questo file è utilizzato per localizzare l'applicativo sul disco, al suo interno sono presenti dei percorsi che vanno valorizzati in relazione alla posizione della applicazione. Ad esempio:

    <Context path="/xway" docBase="e:/3di.it/console/xway" debug="0" privileged="true">  
    <ResourceLink name="xway" global="UserDatabase" type="org.apache.catalina.UserDatabase"/>  
    <!--  
    Uncomment this Valve to limit access to this app to localhost for security reasons.  
    Allow may be a comma-separated list on hosts (or even regular expressions).  
    -->  
    <!--  
    <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127.0.0.1,localhost"/>  
    -->  
    </Context>

* Copiare dalla cartella e:\3di.it\console\xway il file xway.xml nella cartella e:\programmi\Apache Software Foundation\Tomcat 6.0\conf\Catalina\localhost\
___
**Microsoft Visual C++ 2008 Redistributable**

Prima dell'installazione del servizio extraxay sarà necessario installare dal pacchetto Microsoft Visual C++ 2008 Redistributable, eseguendo **vcredist_x86.exe dalla cartella msvc9**
___
**Extraway**

Il server per il database solitamente risiede nella cartella **e:/3di.it/extraway/**.

L'eXtraWay server richiede alcune librerie di sistema per funzionare. Per installarle è sufficiente lanciare l'eseguibile xw3dp-setup.exe e seguire le instruzioni.

* Eseguire **e:\3di.it\extraway\xw\bin\xw.exe**

Per poter installare il servizio eXtraWay è necessario eseguire il setup dal percorso **e:\3di.it\extraway\xw\bin**:

* Eseguire **e:\3di.it\extraway\xw\bin\HISETUP.exe**
* Premere il tasto **"Installa / Avvia"** e chiudere il setup


###### Installazione Versione maggiore di 25.8.0

Scaricato il pacchetto eXtraWay della versione desiderata, copiare il contenuto della cartella 3di.it nel disco locale della macchina e lanciare l'installazione delle librerie microsoft (2008 e 2010 x86 e x64) presenti nella cartella **'vcredist'**.

    WRAP center round info 800%>  
    NB: Effettuare le installazione sempre come Amministratore!  
    </WRAP>

Successivamente installare le librerie presenti nella cartella **'xw3dparts'** necessarie al server eXtraway lanciando l'eseguibile **'xw3rdp-setup-2012.exe'**

Dopo aver registrato l'applicazione procedere con l'installazione del servizio:

Aprire un prompt dei comandi (cmd.exe) e digitare il percorso della cartella contenente l'eseguibile xw.exe (es. 'e:\3di.it\extraway\xw\bin\xw.exe') , 

Lanciare il comando per l'installazione del servizio: 'xw.exe -service_install'
___
**Servizi di Conversione dei file (FCA, FCS, LibreOffice)**

###### Installazione di LibreOffice
Il [pacchetto LibreOffice 3.3.1](ftp://ftp.3di.it/extra/libreoffice/LibO_3.3.1_Win_x86_install_multi.exe) è disponibile per l'installazione dal [sito ftp 3DI](ftp://ftp.3di.it/).

* Eseguire il setup di LibreOffice
* Scegliere l'installazione personalizzata e inserire come percorso e:\LibreO~1.org

>ATTENZIONE: per il funzonamento di fcs è necessario che LibreOffice sia installato in un percorso corto (Questo problema è causato dalle limitazioni della shell di windows)

Non sono necessarie altre modifiche alle impostazioni del setup di LibreOffice.

    <WRAP center round info 90%>  
    Su Windows 10 è stato necessario aggiungere il file install_custom.cmd richiamato dall'install.bat settando le variabili JAVA_HOME e JVMDLL  
    </WRAP>


###### File Conversion Agent (FCA)

    <WRAP center round info 70%>
    Per installare come servizi l'fca e fcs lanciare l'install.bat da console di amministrazione.
    </WRAP>

Il modulo FCA risiede nella cartella **e:\3di.it\platform\fca**, come nel caso dell'MSA, nel percorso **e:\3di.it\platform\fca\bin** è presente il file **install.bat**:

    @echo off  
    set _W=e:\3di.it\platform\fca  
    set xwbin=e:\3di.it\extraway\xw\bin
    
    @rem set JAVA_HOME =  
    @rem impostarla come variabile di sistema, altrimenti scrivere il percorso esplicito nella variabile sottostante  
    set _J=C:\Programmi\Java\jre6\bin\client\jvm.dll  
    call fca.bat

* Inserire per la variabile "_J" il valore "C:\Programmi\Java\jre6\bin\client\jvm.dll"
* Inserire per la variabile "_W" il valore "e:\3di.it\platform\fca"
* Inserire per la variabile "xwbin" il valore "e:\3di.it\extraway\xw\bin"
* Eseguire lo script per installare il modulo

###### File Conversion Service (FCS)

Il modulo FCS risiede nella cartella **e:\3di.it\platform\fcs**, come nei casi precedenti, nel percorso **e:\3di.it\platform\fcs\bin** è presente il solito file **install.bat** (si riporta solo la dichiarazione delle variabili da configurare della versione distribuita a partire dalla release //3.6.1.0// di FCS):

    ...

    set _W=E:\3di.it\platform\fcs  
    set _O=E:\LibreO~1.org  
    
    
    rem set JAVA_HOME =
    rem impostarla come variabile di sistema, altrimenti scrivere il percorso esplicito nella variabile sottostante  
    set _J=%JAVA_HOME%\jre\bin\server\jvm.dll  
    
    
    rem CLASSPATH per OO 2  
    rem set _L=..........  

    rem CLASSPATH per OO 3  
    rem set _L=..........

    ...

* Inserire per la variabile "_J" il valore "C:\Programmi\Java\jre6\bin\client\jvm.dll"
* Inserire per la variabile "_W" il valore "E:\3di.it\platform\fcs"
* Inserire per la variabile "_O" il valore "E:\LibreO~1.org" (come da installazione LibreOffice)

Per poter utilizzare l'FCS inoltre è necessario installare alcune librerie nel sistema:

* Copiare il contenuto della cartella e:\3di.it\platform\fcs\bin\system32 dal CD nella cartella di sistema di windows c:\windows\system32

###### Imagemagick e Tesseract

Per poter utilizzare alcune delle funzionalità di conversione degli allegati sono necessari questi componenti che si trovano all'interno della cartella **fcs_utils** del pacchetto eXtraWay. Si consiglia di installare queste utility in e:\programmi. Tesseract dalle ultime versioni è integrato all'interno della cartella platform mentre per imagemagick esiste un setup.exe. Nel caso si vogliano modificare i percorsi di installazione sarà necessario modificare di conseguenza il file **e:\3di.it\platform\fcs\classes\it.extrawaytech.fcs.properties**.

* Installare Imagemagick in e:\programmi

###### Webservices

Solitamente i webservice si trovano nel percorso **E:\3di.it\webservices\/**.

Per installarli è necessario inserire nella cartella di configurazione di Tomcat i due file **xJwsClient.xml** e **3diws.xml**. Come il file xway.xml per docway, contengono nell'intestazione il percorso da modificare.

* Copiare il file xJwsClient.xml dalla cartella E:\3di.it\webservices\
* Modificare il file xJwsClient.xml e inserire il percorso E:\3di.it\webservices\xJwsClient
* Copiare il file 3diws.xml dalla cartella E:\3di.it\webservices\
* Modificare il file 3diws.xml e inserire il percorso E:\3di.it\webservices\3diws
___
**Registrazione del servizio eXtraWay**

Per poter utilizzare il modulo xw è necessario effettuare la registrazione:

* Eseguire e:\3di.it\extraway\xw\bin\xw.exe

Nel System tray apparirà un icona con il logo di eXtraWay.

Cliccando con il tasto sinistro del mouse sopra l'icona si aprirà una schermata:

* Premere il pulsante "Registration" (Il pulsante nelle versioni precedenti è "Aggiorna licenza")

    - Si aprirà un altra finestra col nome "eXtraWay Server Installation" che richiede "Insert the number of workstations to activate". Il numero di postazioni indica il numero di istanze massime che possono essere attive in contemporanea sul server (Per convenzione di solito questo numero è il numero massimo degli utenti contemporanei che utilizzeranno il server diviso 15 e può dipendere anche dalle prestazioni della macchina).

* Inserire il numero di postazioni massime
* Inserire il numero di serie (se presente)
* Inserire il nome del responsabile e l'organizzazione

Una volta completata la registrazione compare una finestra "registrazione completata" al di sotto della prima finestra, premere ok per chiudere la procedura.

#### - Installazione su piattaforma Linux di ExtraWay Platform
___
##### Requisiti Hardware

Le specifiche della macchina server dipendono principalmente dal numero di utenti che utilizzerà l'applicativo e dal tipo di utilizzo.
In linea di massima le prestazioni di eXtraWay Platform dipendono dalla velocità dei dispositivi di memorizzazione, dalla velocità della rete e, per la gestione di allegati non testuali, dalla memoria RAM.

###### Requisiti Minimi

* Processore Intel Pentium 4 o compatibile
* 1 GB di RAM
* Disco rigido dedicato con almeno 100 GB (per un archivio medio con allegati)

###### Consigliati

Per un utilizzo medio: circa 30 utenti collegati contemporaneamente, un milione documenti.

* Processore Intel Xeon multicore o compatibile;
* 4 GB di RAM;
* Dispositivo di storage ad alta affidabilità (Raid) o moduli esterni (Nas, Sas);
* Almeno 300 GB dedicati alla gestione dell'archivio;
* Scheda di rete Gigabit o superiore;
* Alimentazione tramite gruppo di continuità;

##### Requisiti software

**Server**

###### Distribuzioni Linux Supportate

eXtraway Platform è stato testato ed è utilizzato con diverse distribuzioni:

* [Redhat Enterprise](http://www.redhat.com/rhel/) (dalla versione 3)
* [Fedora](http://fedoraproject.org/)
* [Ubuntu Server Edition](http://www.ubuntu.com/products/WhatIsUbuntu/serveredition)
* [Debian](http://www.debian.org)
* [Centos](http://www.centos.org/)
* [Gentoo](http://www.gentoo.org)

Sono consigliati ad ora dal servizio assistenza 3di:
* Redhat Enterprise 5 64bit
* Centos 6.4 64bit
* Ubuntu Server 12.04 LTS 64bit
* Gentoo 64bit

###### Librerie di sistema richieste

Le librerie di sistema necessarie al corretto funzionamento dei componenti che compongono ExtraWay. Solitamente collocate in /lib e /usr/lib:

* libdl.so.2
* libz.so.1
* libstdc++.so.6
* libm.so.6
* libgcc_s.so.1
* libpthread.so.0
* libc.so.6 (minimo glibc 2.5)
* libxml2.so.2
* libxslt.so.1
* libzip.so.1 o libzip.so.2
* libcurl.so.4

>ATTENZIONE: Gli eseguibili del motore eXtraWay non hanno ancora una versione dispobibile a 64bit. È necessario pertanto installare le librerie di compatibilita ia32 sulle macchine a 64 bit della maggior parte delle distribuzioni. Inoltre esistono alcuni casi riportati ((Al momento RHEL 5.6)) sul quale è necessario installare manualmente le librerie elencate in versione 32bit. Se non è possibile effettuare questi passaggi o le librerie indicate non sono presenti, la specifica distribuzione non è supportata.

**Per installare le librerie su sistemi Ubuntu usare il seguente comando:**

    sudo apt-get install libgcc1:i386 libzip2:i386 libc6:i386 libxml2:i386 libxslt1.1:i386 libcurl3:i386 libncurses5:i386 libreadline6:i386 libstdc++6:i386

**Per installare le librerie su sistemi Debian recenti (Debian 9) usare il seguente comando da root:**

    <code bash>  
    dpkg --add-architecture i386
    
    
    apt-get update
    
    apt-get install libgcc1:i386 libzip4:i386 libc6:i386 libxml2:i386 libxslt1.1:i386 libcurl4:i386 libncurses5:i386 libreadline7:i386 libstdc++6:i386 libxslt1.1:i386 libzip4:i386
    </code>

**Per installare le librerie su sistemi RedHat/CentOS usare il seguente comando:**

    yum install libgcc.i686 libzip.i686 glibc.i686 libxml2.i686 libxslt.i686 libcurl.i686 ncurses-libs.i686 readline.i686 libstdc++.i686


###### Pdftotext

Per l'indicizzazione degli allegati in formato pdf è necessario installare l'utilità pdftotext.

In molte distribuzioni non è compresa nell'installazione di base: in alcune distribuzioni è presente all'interno del pacchetto //xpdf// (centos 4, redhat enterprise) o nel pacchetto //poppler-utils// (gentoo, ubuntu, debian, centos 5).

###### Imagemagick

Per l'indicizzazione e la conversione degli allegati in formato grafico è necessario installare l'utilità imagemagick.

In alcune distribuzioni non è compresa nell'installazione di base: tuttavia il pacchetto omonimo solitamente è presente tra quelli installabili.


**Per installare le librerie su sistemi Debian usare il seguente comando:**

    <code bash>apt-get install poppler-utils imagemagick</code>

#### Installazione e configurazione

##### Preparazione dell'installazione

**Componenti che verranno installati**

* Apache Tomcat 6.0.20
* Sun Java Runtime Environment 1.6.0_20
* LibreOffice 3.3.1
* ExtraWay Platform
 
**Preparazione della macchina server**

È consigliato mantenere l'installazione dell'applicativo in un dispositivo di memorizzazione separato rispetto a quello che ospita il sistema operativo.

Il pacchetto di installazione fornito da 3DI è già configurato per essere installato sotto il direttorio /opt

Montare il dispositivo di memorizzazione scelto sotto /opt e inserire un riga apposita in /etc/fstab

__Creare un utente con nome "extraway". Questo sarà l'utente con cui verranno eseguiti tutti i processi relativi ad eXtraWay Platform__

    <code>
    useradd -m extraway
    </code>

**Copia dei files**

Copiare il pacchetto di installazione di Extraway nella cartella /opt.
Nel caso non sia possibile utilizzare il sistema di pacchetti integrato per l'installazione di libreoffice. È possibile dal [sito libreoffice](http://www.libreoffice.org) ottenere l'elenco dei repository personalizzati oppure scaricare il pacchetto generico. È possibile anche scaricare una [versione generica](ftp://ftp.3di.it/extra/libreoffice/LibO_3.3.1_Linux_x86_install-rpm_en-US.tar.gz) dal nostro sito ftp.

**Abilitare permessi di scrittura sul tomcat-users.xml**

Di base il file tomcat-users.xml è aperto in sola lettura, per abilitare il permesso di scrittura è necessario inserire il parametro "readonly=false" nel server.xml di Tomcat:

    <GlobalNamingResources>  
    <!-- Editable user database that can also be used by  
    UserDatabaseRealm to authenticate users  
    -->


    <Resource name="UserDatabase" auth="Container"  
    type="org.apache.catalina.UserDatabase"  
    description="User database that can be updated and saved"  
    factory="org.apache.catalina.users.MemoryUserDatabaseFactory"  
    pathname="conf/tomcat-users.xml" readonly="false" />  
    </GlobalNamingResources>

* Inserire il parametro "readonly=false" all'interno dell'attributo "Realm" (UserDatabase)" nel file /opt/apache-tomcat-6.0.26/conf/server.xml

**Impostazione parametri del kernel per eXtraWay in /etc/sysctl.conf**

Dalla release 24, eXtraWay necessita di ulteriore memoria condivisa a disposizione, rifiutandosi di partire nel caso questa non sia a disposizione.

Per impostare correttamente il kernel, aggiungere al file /etc/sysctl.conf (se non esiste, crearlo) le seguenti righe:

    <code>  
    # Impostazioni per eXtraWay  
    #kernel.core_pattern=/opt/cores/core.%e.%p.%h.%t  
    kernel.shmmax=268435456  
    </code>

ed eseguire

    sysctl -p

per applicare la modifica al sistema.

#### Installazione dei pacchetti

##### ExtraWay Platform

Estrarre il pacchetto extraway nella cartella /opt.

Es.
    /opt# tar xvjf extraway_platform_*.tar.bz2

Per garantire il funzionamento della piattaforma senza che ci sia necessità di credenziali amministrative (root) è necessario assegnare la cartella /opt all'utente extraway.

Es.
    /opt# chown -R extraway:extraway /opt

In alternativa è possibile assegnare ad extraway le singole cartelle in opt, tuttavia ciò potrebbe richiedere accesso amministrativo per effettuare aggiornamenti futuri.

##### LibreOffice

Nel caso si sia scelta la procedura di installazione manuale estrarre il pacchetto LibreOffice.

Es.
    /opt# tar xzf LibO_3.3.1_Linux_x86_install-rpm_en-US.tar.gz

Eseguire il comando di installazione di LibreOffice (install.sh) dalla cartella estratta e seguire le indicazioni. Solitamente non è necessario cambiare nessun parametro dall'installazione di default.

Nel caso invece si pensi di utilizzare la versione della propria distribuzione è necessario controllare che i percorsi della cartella base di libreoffice e dei componenti basis e URE siano corretti nel file /opt/it-3di/platform/fcs/conf/extraway-fcs.conf

##### Accorgimenti per sistemi con versione di glibc antecedente alla 2.7

In alcuni sistemi è necessario installare la versione compatibile degli eseguibili eXtraWay. Questa versione è compilata con glibc 2.5.

Per installarli copiare i file contenuti in /opt/it-3di/extraway/xw/platform-dependent/bin-Linux/i586 in /opt/it-3di/extraway/xw/bin

##### Registrazione del motore del database (eXtraWay)

Per poter utilizzare eXtraWay è necessario effettuare la registrazione.

Eseguire il seguente comando dalla cartella /opt:

    /opt~$ ./demo.sh registration
  
Nel caso si riceva il messaggio:

>No TCP/IP interface found,  
Server can't be set up  
End of Procedure.

è necessario aggiungere una entry al file /etc/hosts nella quale si associa l'indirizzo dell'interfaccia di rete sulla quale ascolterà il server xw con il suo hostname, ricavabile da /etc/hostname.

Durante la registrazione vengono chiesti i seguenti dati:

* Numero di postazioni da abilitare
* Numero di serie (se fornito)
* Nome del responsabile
* Nome dell'organizzazione

Il primo numero è il numero massimo di istanze di xw che possono partire in contemporanea sul server (Per convenzione si solito questo numero è il numero massimo di utenti che utilizzeranno il server in contemporanea diviso 15 e dipende anche dalle prestazioni della macchina)

**Automatismi**

Per ultima cosa bisogna procedere a configurare il sistema operativo per interagire con i componenti in modo automatico.

##### Script di avvio

Gli script per caricare automaticamente l'applicativo all'avvio della macchina (e per riavviare l'applicativo in caso di necessità) si trovano sotto il percorso **/opt/it-3di/extra/init-files** e sono i seguenti:

* tomcat6
* extraway (motore database)
* extraway-fca (File Conversion Agent)
* extraway-fcs (File Conversion Service)

Tutti accettano i comandi start, stop e restart.

>NOTA: gli script all'interno di questa sezione sono tutti configurabili nel caso ci sia necessità di cambiare i percorsi di installazione.
___
**Installazione automatica con script 3di**

Sono disponibili già per alcune distribuzioni degli script per inserirli automaticamente all'interno del sistema rc.d:

* [Debian, Ubuntu](ftp://ftp.3di.it/extra/init-scripts/init.d_setup_debian.sh) (utilizza update-rc.d)
* [Redhat, Fedora e Centos](ftp://ftp.3di.it/extra/init-scripts/chkconfig_initd.tar.bz2) (da copiare in /etc/init.d e attivare con chkconfig)
* [Gentoo](ftp://ftp.3di.it/extra/init-scripts/gentoo_initd.tar.bz2) (da copiare in /etc/init.d e attivare con rc-update)
* [script generico](ftp://ftp.3di.it/extra/init-scripts/init.d_setup_generic.sh) (crea direttamente i link in rc.d)

>ATTENZIONE: l'esecuzione di alcuni di questi script richiede diritti amministrativi
___
**Installazione Manuale**

È possibile anche installare questi file manualmente. È necessario creare dei link ai file in /opt/it-3di/extra/init-files/ in /etc/init.d e creare successivamente creare da questi dei link nei diversi runlevel:

Es.
    ~# ln -s /opt/it-3di/extra/init-files/extraway /etc/init.d/  
    ~# ln -s /etc/init.d/extraway /etc/rc0.d/K20extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc1.d/K20extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc6.d/K20extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc2.d/S79extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc3.d/K79extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc4.d/K79extraway

Si consiglia di spegnere tomcat leggermente prima, di seguito l'ordine di partenza e di spegnimento di tutti i servizi:

  * tomcat6: start 80 | stop 19
  * extraway: start  79 | stop 20
  * extraway-fca: start 79 | stop 20
  * extraway-fcs: start 79 | stop 20

##### Backup

È altamente consigliato mantenere un backup dell'intera cartella it-3di (anche incrementale volendo).

Per fare ciò è necessario fermare i servizi extraway e tomcat6 prima di eseguire lo script di backup vero e proprio.

Es. script backup da inserire nel crontab di root:

    /etc/init.d/tomcat6 stop  
    /etc/init.d/extraway-fcs stop  
    /etc/init.d/extraway.fca stop  
    /etc/init.d/extraway stop  
    <comando backup>  
    /etc/init.d/extraway start  
    /etc/init.d/extraway.fca start  
    /etc/init.d/extraway-fcs start  
    /etc/init.d/tomcat6 start

#### Uso di Antivirus nelle installazioni eXtraWay

La presenza di un antivirus nelle installazioni della piattaforma eXtraWay può comportare due distinti ordini di problemi: di natura prestazionale e di natura funzionale.

**Aspetto Prestazionale**
I software antivirus più diffusi eseguono scansioni "Real-time" sul sistema operativo e sui processi. Può accadere quindi che scansioni e blocchi troppo invasivi rallentino o fermino del tutto i componenti Tomcat (applicativo) o eXtraWay (motore del database).

**Aspetto Funzionale**
È prassi comune che gli antivirus riconoscano come comportamento rischioso, potenzialmente maligno, uno dei comportamenti del server eXtraWay. Per ovviare a quest'inconveniente è necessario agire sulle impostazioni dell'antivirus.

**Esclusioni**
Per poter utilizzare comunque il software antivirus è necessario impostare una o più liste di esclusione: esistono principalmente 2 tipi di lista a seconda del software utilizzato. Esse si riferiscono ai files/cartelle delle quali non si richiede che venga compiuta verifica e l'elenco degli eseguibili che possono essere considerati affidabili.

##### Interventi di tipo prestazionale
È evidente come l'attività di un antivirus non possa essere priva di impatti sulle prestazioni dell'intero sistema. In particolare, gran parte degli antivirus operano in tempo reale ed intercettano, per così dire, tutte le operazioni di lettura e scrittura che hanno luogo sui dischi. Ciò comporta un naturale rallentamento di tali processi.

Per non incorrere in limitazioni prestazionali, ed in generale considerando la natura dei dati scritti da eXtraWay, gli antivirus possono (e dovrebbero) essere configurati per ignorare l'attività afferente alle cartelle che ospitano i dati, gli indici e le registrazioni di servizio((Quali, ad esempio, le cartelle dei logs etc. etc.))

###### Lista esclusioni per cartelle

È necessario impostare come esclusione la cartella del database, la cartella degli eseguibili e le cartelle dei file temporanei:

|Cartella|Contenuto|
|--|--|
|\3di.it\extraway\xw\db  |Cartella database eXtraWay  |
|\3di.it\extraway\xw\bin  |Cartella eseguibili eXtraWay  |
|\3di.it\extraway\xw\logs  |Cartella logs eXtraWay  |
|\3di.it\extraway\xw\xreg  |Dove presente, cartella di servizio per il registro di  eXtraWay  |
|\3di.it\extraway\xw\lazy  |Dove presente, cartella di servizio per le attività *near on line* di  eXtraWay  |
|\Programmi\Apache Software Foundation\Tomcat 6.0\bin  |Cartella eseguibili Apache Tomcat  |
|\Programmi\Apache Software Foundation\Tomcat 6.0\work  |Cartella cache Tomcat  |
|*%temp*%\hwtemp  |Cartella file temporanei di eXtraWay  |

La cartella *%temp%* solitamente corrisponde a \windows\temp ma dipende direttamente dall'impostazione della variabile di sistema Windows.

##### Interventi di tipo Funzionale
Come precedentemente annunciato un comportamento del modulo eXtraWay Server viene considerato malevolo dalla maggioranza degli antivirus.
 
L'architettura di eXtraWay Server prevede che esista un'istanza del modulo in ascolto per nuove connessioni. Quando un'applicazione client richiede una nuova connessione il server in ascolto, detto *Master*, duplica se stesso producendo una copia figlia, detta *Slave*, che di fatto instaura la connessione con l'applicazione client e ne esegue le richieste.

 Il processo così generato eredita dal processo principale alcune risorse condivise.
 
Un simile comportamento viene considerato pericoloso in quanto rappresenta uno dei più comuni sistemi che hanno i virus per avviare processi in grado di produrre danni e/o appropriarsi di importanti informazioni presenti nel sistema.
 
Per ovviare a questo bisogna necessariamente istruire il sistema antivirus perché consideri eXtraWay Server come processo affidabile, quindi *trusted*, e non ne impedisca il corretto comportamento.

###### Lista esclusioni per eseguibili

È necessario impostare come esclusione l'eseguibile di eXtraWay e l'eseguibile di Tomcat

|Modulo|
|--|
|\3di.it\extraway\xw\bin\xw.exe|
|\Programmi\Apache Software Foundation\Tomcat 6.0\bin\tomcat6.exe|

I percorsi in entrambe le liste possono variare a seconda delle installazioni, tuttavia è possibile recuperare l'esatta posizione controllando nelle proprietà dei servizi di Windows.//

##### Configurazioni antivirus già testate con eXtraWay

Nel corso del tempo sono state verificate diverse installazioni nelle quali è stato possibile compiere con successo gli interventi descritti nei capitoli precedenti.

Dal momento che ogni software antivirus ha propria configurazione e che essi evolvono naturalmente nel tempo, non viene descritto in questa sede il procedimento da seguire rimandando il dettaglio alla documentazione degli stessi.

**Antivirus efficacemente verificati:**

  * Norton Antivirus
  * NOD32 (Versione esistente al 2010)
  * Kaspersky Anti-Virus

Va altresì detto che qualora un antivirus imponga limiti funzionali ma senza dare la possibilità di compilare liste di esclusione, esso risulta di fatto incompatibile con le installazioni eXtraWay.

Allo stato attuale risultano

**Antivirus incompatibili:**

  * Panda Antivirus Titanum 2004

-------

>**N.B.:** Gli elenchi riportati sono da considerarsi __meramente indicativi e non esaustivi__. 3D Informatica __non può considerarsi responsabile__ qualora nuove versioni di antivirus verificati risultassero incompatibili ne può garantire che nuove versioni degli antivirus noti come incompatibili risultino di fatto utilizzabili. Chi fosse intenzionato ad acquisire un software antivirus per proteggere le proprie installazioni eXtraWay dovrà, __sotto la propria responsabilità__, raccogliere informazioni sufficienti per garantirsi la possibilità di sottoporre a tale software liste di esclusioni quanto meno per gli aspetti funzionali.

#### Istruzioni installazione DocWay

###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso) - [[Torna a *Istruzioni per le dipendenze eXtraWay e DocWay*]](https://github.com/3dinformatica/riuso/blob/master/README.md#istruzioni-per-le-dipendenze-extraway-e-docway)
___
#### - Installazione su piattaforma Windows di DocWay 4
###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso) - [[Torna a *Istruzioni per le dipendenze eXtraWay e DocWay*]](https://github.com/3dinformatica/riuso/blob/master/README.md#istruzioni-per-le-dipendenze-extraway-e-docway)
___
##### Requisiti Hardware

Le specifiche della macchina server dipendono principalmente dal numero di utenti che utilizzerà l'applicativo e dal tipo di utilizzo. In linea di massima le prestazioni di DocWay 4 dipendono dalla velocità dei dispositivi di memorizzazione, dalla velocità della rete e, per la gestione di allegati non testuali, dalla memoria RAM.

###### Requisiti Minimi

* Processore Intel Xeon 2.00 Ghz o compatibile
* 4 GB di RAM
* Disco rigido dedicato con almeno 150 GB (per un archivio medio con allegati)

###### Consigliati

Per un utilizzo medio: circa 30 utenti collegati contemporaneamente, un milione documenti.

* Processore Intel Xeon Quad Core o compatibile
* 8 GB di RAM
* Almeno 3 dischi SATA in RAID 5 o un sistema alternativo di memorizzazione
* Almeno 300 GB sul sistema di memorizzazione scelto
* Scheda di rete Gigabit o superiore
* Alimentazione tramite gruppo di continuità

##### Requisiti software

**Server**

* Windows server 2003 sp2 con Internet Information Server 6.0
* Windows server 2008 r2 64bit con Internet Information Server 7.5
* Windows server 2012 64bit con Internet Information Server 8
* Antivirus che possa essere configurato con eccezioni per quanto riguarda il controllo dei processi (Panda sembra essere problematico da questo punto di vista)
* Accesso tramite remote desktop o vnc((Nel caso si voglia usufruire dell'assistenza da remoto da parte di 3DI))
* DBMS a scelta tra Mysql, PostGreSQL, Oracle (per il supporto ai workflow)

**Client**

Macchina client con collegamento di rete diretto al server, si sconsiglia l'utilizzo di indirizzi mappati con tecnologia NAT.

**Browser supportati**

* Internet Explorer 9
* Internet Explorer 10
* Internet Explorer 11
* Mozilla Firefox ((per un funzionamento ottimale potrebbe essere richiesto un aggiornamento alla versione attuale))
* Chrome/Chromium ((per un funzionamento ottimale potrebbe essere richiesto un aggiornamento alla versione attuale))

Per maggiori dettagli relativi al supporto browser, consultare la [seguente pagina](documentazione_3di:docway4:browser_compat).

**Plugin Java**

Per usufruire di alcune funzionalità (firma digitale dei file, per esempio) è necessario installare un [Java Runtime Environment](http://java.com) col relativo plugin per i vari browser.

**Plugin IWX**

Per poter utilizzare appieno le funzionalità dell'applicativo, è possibile installare il plugin IWX, che integra, tra le altre, funzionalità di stampa e scansione diretta di documenti in DocWay 4.
Per installarlo è necessario scaricare il pacchetto di installazione MSI dall'interfaccia di DocWay 4 ((Il link di scaricamento diventa visibile nella schermata di creazione/modifica di un documento o all'apertura di un documento contenente allegati)) e disporre di diritti amministrativi sulla macchina.

##### Installazione

**Anatomia del pacchetto di installazione**

Il pacchetto di installazione contiene i moduli di DocWay4 suddivisi in cartelle, di seguito la funzione di ogni componente:

* Contiene il Java Runtime Environment.
* contiene un modulo microsoft per la trasformazione degli xml con fogli di stile (formato .msi).
* contiene l'eseguibile per l'installazione di LibreOffice, utilizzato per la conversione degli allegati.
* contiene le indicazioni su come avviare un flusso documentale di prova.
* contiene l'applicativo Apache Tomcat che ospita l'applicazione java.
* contiene i pacchetto Microsoft Visual C++ 2008/2010 Redistributable, che devono essere installati (se non già presenti) per il corretto funzionamento dei componenti.
* contiene le applicazione java per DocWay4 e i loro file di contesto DocWay4.xml e DocWay4-service.xml da utilizzare con tomcat.
* contiene i due servizi che compongono il sistema di conversione/indicizzazione dei file, FCA e FCS.
* contiene le utility di terze parti per la conversione degli allegati.
* contiene il modulo per l'archiviazione delle mail (MailStorage)
* contiene il modulo per l'esportazione del registro di protocollo (RIP)
* cartella dove è possibile installare il modulo aggiuntivo dei webservice
* cartella contenente il server per il database eXtraWay.
* Contiene l'archivio utilizzato dall'applicativo.
* contiene librerie di terze parti per la manipolazione degli xml e la compressione di files con le rispettive licenze d'uso.
* Contiene i componenti aggiuntivi utilizzati da IIS per comunicare direttamente con tomcat. Al suo interno è presente una directory [bin] dove sono contenute le estensioni per IIS.

###### Root di installazione

Consigliamo di installare i nostri applicativi in un disco separato rispetto a quello di sistema (C:) per motivi di performance. Nel seguito, si assumerà che l'installazione venga posizionata nel disco **E:**.

###### Java

Eseguire il setup di java dalla cartella jre del cd.


Non è necessario cambiare alcuna configurazione durante l'esecuzione del setup. 
Di base il Java Runtime Environment ha come destinazione 

    C:\Programmi\Java\jre7  


###### Tomcat

Eseguire il setup di Tomcat dalla cartella del cd. Durante l'installazione sarà necessario:

* modificare il tipo di installazione selezionando come componenti aggiuntivi "Service", che permette l'avvio automatico come servizio di Tomcat e "Native" che installa le librerie APR native per ottenere maggiori performance e scalabilità.
* Lasciare invariate le porte di default e gli altri parametri, a meno di particolari esigenze.
* Selezionare il percorso di un Java Runtime Environment già installato nel sistema per avviare Tomcat (ovvero, quello installato al punto precedente della guida).
* Modificare la directory di destinazione: nonostante questo non sia necessario, consigliamo di installare Tomcat all'interno dalla root di installazione prescelta (i.e. E:), nel percorso E:\programmi\Apache Software Foundation\Tomcat 7.0.


Una volta terminata l'installazione si dovranno impostare altre opzioni tramite "Configure Tomcat" dal menù delle Applicazioni: 

* nella prima pagina "General" verificare che l'avvio di Tomcat sia impostato su automatico;

* nella pagina "Java":
  - Indicare "1024" in "Maximum Memory Pool".((La quantità di memoria massima che Tomcat può utilizzare in sistemi Windows a 32 bit non dovrebbe mai essere impostata a più di 1GB. Tuttavia è consigliabile non impostare un valore troppo basso, per evitare che durante lo scaricamento o l'inserimento di allegati, si esaurisca la memoria disponibile. Questo valore può essere aumentato tranquillamente su sistemi a 64 bit con java a 64 bit.))
  - (Consigliato) aumentare l'initial memory pool da 128MB ad un valore compreso tra 512MB e il Maximum Memory Pool precedentemente impostato. In questo modo, Tomcat allocherà subito questo quantitativo di memoria ad ogni suo avvio, evitando di dover riallocare varie volte la memoria per arrivare alla dimensione specificata in Maximum Memory Pool.

Per poter utilizzare l'utente base di Tomcat (solitamente admin) come utente amministratore di DocWay4 è necessario inserire i valori "jspuser" e "admjspuser" al file E:\Programmi\Apache Software Foundation\Tomcat 7.0\conf\tomcat-users.xml:

    <user username="admin" password="xxxxxx" roles="admin,manager-gui,jspuser,admjspuser"/>

**Cifratura delle password nel tomcat-users.xml**

Di base le password all'interno del file tomcat-users.xml sono in chiaro, per abilitare la cifratura è necessario inserire il parametro "digest=MD5" nel server.xml di Tomcat:

    <!-- This Realm uses the UserDatabase configured in the global JNDI resources under the key "UserDatabase".  
    Any edits that are performed against this UserDatabase are immediately available for use by the Realm.  -->  
    <Realm className="org.apache.catalina.realm.UserDatabaseRealm" resourceName="UserDatabase" digest="MD5"/>

* Inserire il parametro "digest=MD5" all'interno dell'attributo "Realm" (UserDatabase)" nel file e:\Programmi\Apache Software Foundation\Tomcat 6.0\conf\server.xml

Qualora si abilitasse la cifratura bisognerà quindi scrivere la corrispondente password cifrata con l'algoritmo MD5 nel campo password di  **tomcat-users.xml**

**Abilitare permessi di scrittura sul tomcat-users.xml**

Di base il file tomcat-users.xml è aperto in sola lettura, per abilitare il permesso di scrittura è necessario inserire il parametro "readonly=false" nel server.xml di Tomcat:

    <GlobalNamingResources>  
    <!-- Editable user database that can also be used by  
    UserDatabaseRealm to authenticate users  
    -->  
    
    <Resource name="UserDatabase" auth="Container"  
    type="org.apache.catalina.UserDatabase"  
    description="User database that can be updated and saved"  factory="org.apache.catalina.users.MemoryUserDatabaseFactory"  pathname="conf/tomcat-users.xml" readonly="false" />  
    </GlobalNamingResources>

* Inserire il parametro "readonly=false" all'interno dell'attributo "Realm" (UserDatabase)" nel file e:\Programmi\Apache Software Foundation\Tomcat 6.0\conf\server.xml

**Docway**

Di base l'applicativo viene installato nel disco dedicato che per comodità indicheremo come e:

* Copiare la cartella 3di.it dal cd in e:\

Per fare in modo che tomcat visualizzi l'applicazione è necessario copiare il file di configurazione **xway.xml** all'interno della cartella di configurazione di tomcat:

* questo file è utilizzato per localizzare l'applicativo sul disco, al suo interno sono presenti dei percorsi che vanno valorizzati in relazione alla posizione della applicazione. Ad esempio:

    <Context path="/xway" docBase="e:/3di.it/DocWay4/xway" debug="0" privileged="true">  
    <ResourceLink name="xway" global="UserDatabase" type="org.apache.catalina.UserDatabase"/>  
    <!--  
    Uncomment this Valve to limit access to this app to localhost for security reasons.  
    Allow may be a comma-separated list on hosts (or even regular expressions).  
    -->  
    <!--  
    <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127.0.0.1,localhost"/>  
    -->  
    </Context>

* Copiare dalla cartella e:\3di.it\DocWay4\xway il file xway.xml nella cartella e:\programmi\Apache Software Foundation\Tomcat 6.0\conf\Catalina\localhost\ (da creare)

**Mail Archiver**

Il modulo Mail Storage Agent (MSA) consente di inserire delle mail all'interno del protocollo, semplicemente spedendole ad un indirizzo creato ad hoc.

All'interno della cartella **e:\3di.it\docway_extra\MailStorage\bin\/** si trova lo script **install.bat** per l'installazione automatica del modulo MSA:

    @echo off  
    @rem TODO:  
    @rem impostare INSTDIR  
    @rem verificare la variabile d'ambiente JAVA_HOME, se assente inserirlo nel presente file  
    @rem verificare percorso del file di log in classes/log4j.properties  
    set JVMDLL=C:\Progra~1\Java\jre6\bin\client\jvm.dll  
    set INSTDIR=e:/3di.it/DocWay4/MailStorage  set MY_JAVA_HOME=%INSTDIR%/lib

* Inserire per la variabile "JVMDLL" il valore "C:\Progra~1\Java\jre6\bin\client\jvm.dll"
* Inserire per la variabile "INSTDIR" il valore "e:/3di.it/DocWay4/MailStorage"
* Eseguire lo script per installare il modulo

**Registro di Protocollo**

Il modulo per esportare il registro di protocollo (RIP) risiede solitamente nel percorso **e:\3di.it\DocWay4\rip**.

Nella cartella **E:\3di.it\docway_extra\rip\bin\/** si trova il file **rip.bat**. Come nel caso dell'MSA è necessario impostare i percorsi in modo corretto:

    @echo off  
    @rem TODO:  
    @rem impostare INSTDIR  
    @rem verificare la variabile d'ambiente JAVA_HOME, se assente inserirlo nel presente file  
    @rem verificare percorso del file di log in classes/log4j.properties  
    @rem impostare eventuali parametri nella variabile PARAMETERS  
    set JAVA_HOME=C:\Programmi\Java\jre6  
    set INSTDIR=E:/3di.it/DocWay4/rip  
    set MY_JAVA_HOME=%INSTDIR%/lib

* Impostare alla variabile "JAVA_HOME" il valore "C:\Programmi\Java\jre6"
* Impostare alla variabile "INSTDIR" il valore "E:/3di.it/DocWay4/rip"

__Per poter usufruire di questo servizio, è necessario inserirlo nelle operazioni pianificate di windows__:

* Inserire il file e:\3di.it\DocWay4\rip\bin\rip nelle operazioni pianificate di Windows, in modo che sia eseguito ciclicamente (si consiglia un esportazione giornaliera)

**Microsoft Visual C++ 2008 Redistributable**

Prima dell'installazione del servizio extraxay sarà necessario installare dal CD Microsoft Visual C++ 2008 Redistributable, eseguendo vcredist_x86.exe dalla cartella msvc9

**Extraway**

Il server per il database solitamente risiede nella cartella **e:/3di.it/extraway/**.

L'Extraway server richiede alcune librerie di sistema per funzionare. Per installarle è sufficiente lanciare l'eseguibile xw3dp-setup.exe e seguire le instruzioni.

* Eseguire e:\3di.it\extraway\xw\bin\xw.exe

Per poter installare il servizio extraway è necessario eseguire il setup dal percorso **e:\3di.it\extraway\xw\bin**:

* Eseguire e:\3di.it\extraway\xw\bin\HISETUP.exe
* Premere il tasto "Installa / Avvia" e chiudere il setup

##### Servizi di Conversione dei file (FCA, FCS, LibreOffice)

**Installazione di LibreOffice**

Il [pacchetto LibreOffice 3.3.1](ftp://ftp.3di.it/extra/libreoffice/LibO_3.3.1_Win_x86_install_multi.exe) è disponibile per l'installazione dal [sito ftp 3DI](ftp://ftp.3di.it/).

* Eseguire il setup di LibreOffice
* Scegliere l'installazione personalizzata e inserire come percorso e:\LibreO~1.org

>ATTENZIONE: per il funzonamento di fcs è necessario che LibreOffice sia installato in un percorso corto (Questo problema è causato dalle limitazioni della shell di windows)

**Inoltre il percorso non deve assolutamente contenere spazi in quanto non possono essere usare le virgolette nel file install.bat per definire il path di libreoffice/openoffice**

Non sono necessarie altre modifiche alle impostazioni del setup di LibreOffice.

**File Conversion Agent (FCA)**

Il modulo FCA risiede nella cartella **e:\3di.it\platform\fca**, come nel caso dell'MSA, nel percorso **e:\3di.it\platform\fca\bin** è presente il file **install.bat**:

    @echo off
    set _W=e:\3di.it\platform\fca
    set xwbin=e:\3di.it\extraway\xw\bin

    @rem set JAVA_HOME =
    @rem impostarla come variabile di sistema, altrimenti scrivere il percorso esplicito nella variabile sottostante
    set _J=C:\Progra~1\Java\jre6\bin\client\jvm.dll
    call fca.bat

* Inserire per la variabile "_J" il valore "C:\Progra~1\Java\jre6\bin\client\jvm.dll"
* Inserire per la variabile "_W" il valore "e:\3di.it\platform\fca"
* Inserire per la variabile "xwbin" il valore "e:\3di.it\extraway\xw\bin"
* Eseguire lo script per installare il modulo

**File Conversion Service (FCS)**

Il modulo FCS risiede nella cartella **e:\3di.it\platform\fcs**, come nei casi precedenti, nel percorso **e:\3di.it\platform\fcs\bin** è presente il solito file **install.bat** (si riporta solo la dichiarazione delle variabili da configurare della versione distribuita a partire dalla release //3.6.1.0// di FCS):

    ...
    set _W=E:\3di.it\platform\fcs
    set _O=E:\LibreO~1.org

    rem set JAVA_HOME =
    rem impostarla come variabile di sistema, altrimenti scrivere il percorso esplicito nella variabile sottostante
    set _J=%JAVA_HOME%\jre\bin\server\jvm.dll

    rem CLASSPATH per OO 2
    rem set _L=..........

    rem CLASSPATH per OO 3
    rem set _L=..........

    ...

* Inserire per la variabile "_J" il valore "C:\Progra~1\Java\jre6\bin\client\jvm.dll"
* Inserire per la variabile "_W" il valore "E:\3di.it\platform\fcs"
* Inserire per la variabile "_O" il valore "E:\LibreO~1.org" (come da installazione LibreOffice)
* Eseguire lo script per installare il modulo

Per poter utilizzare l'FCS inoltre è necessario installare alcune librerie nel sistema:

* Copiare il contenuto della cartella e:\3di.it\platform\fcs\bin\system32 dal CD nella cartella di sistema di windows c:\windows\system32

**Imagemagick e Tesseract**

Per poter utilizzare alcune delle funzionalità di conversione degli allegati sono necessari questi componenti che si trovano all'interno della cartella **fcs_utils** del cd. Si consiglia di installare queste utility in **e:\programmi**. Tesseract dalle ultime versioni è integrato all'interno della cartella platform mentre per imagemagick esiste un setup.exe. Nel caso si vogliano modificare i percorsi di installazione sarà necessario modificare di conseguenza il file **e:\3di.it\platform\fcs\classes\it.extrawaytech.fcs.properties**.

* Installare Imagemagick in e:\programmi

**Msxml**

La libreria msxml è necessaria per la trasformazione dell'xml a livello server. Eseguire il setup dalla cartella omonima del cd, non è necessario modificare nulla nelle impostazioni del setup.
* Installare Msxml utilizzando il setup nella cartella msxml del CD

**Registrazione del servizio eXtraWay**

Per poter utilizzare il modulo xw è necessario effettuare la registrazione:

* Eseguire e:\3di.it\extraway\xw\bin\xw.exe

Nel System tray apparirà un icona con il logo di eXtraWay, con il tasto sinistro del mouse sopra l'icona si aprirà una schermata

* Premere il pulsante "Registration" (Il pulsante nelle versioni precedenti è "Aggiorna licenza").

Si aprirà un altra finestra col nome "eXtraWay Server Installation" che richiede "Insert the number of workstations to activate". Il numero di postazioni indica il numero di istanze massime che possono essere attive in contemporanea sul server((Per convenzione di solito questo numero è il numero massimo degli utenti contemporanei  che utilizzeranno il server diviso 15 e può dipendere anche dalle prestazioni della macchina)).

* Inserire il numero di postazioni massime
* Inserire il numero di serie (se presente)
* Inserire il nome del responsabile e l'organizzazione

Una volta completata la registrazione compare una finestra "registrazione completata" al di sotto della prima finestra, premere ok per chiudere la procedura.

##### Ordine di avvio dei servizi

L'ordine per effettuare l'avvio dei servizi tramite l'utility **services.msc** è il seguente:

* eXtraWay server
* eXtraWay FCS
* eXtraWay FCA
* eXtraWay Mail Archiver
* Tomcat

#### - Installazione su piattaforma Linux di DocWay 4
###### [[Torna su]](https://github.com/3dinformatica/riuso/blob/master/README.md#descrizione-del-progetto-di-riuso) - [[Torna a *Istruzioni per le dipendenze eXtraWay e DocWay*]](https://github.com/3dinformatica/riuso/blob/master/README.md#istruzioni-per-le-dipendenze-extraway-e-docway)
___
##### Prerequisiti software

**Server**

###### Distribuzioni Linux Supportate

Docway4 è stato testato ed è utilizzato con diverse distribuzioni:

* [Redhat Enterprise](http://www.redhat.com/rhel/) (dalla versione 7)
* [Ubuntu Server Edition 14.04](http://www.ubuntu.com/products/WhatIsUbuntu/serveredition)
* [Centos](http://www.centos.org/) (dalla versione 7)

Sono consigliati ad ora dal servizio assistenza 3di:

* Centos 7 64bit
* Ubuntu Server 14.04 LTS 64bit

###### Librerie di sistema richieste

Le librerie di sistema necessarie al corretto funzionamento dei componenti che compongono ExtraWay. Solitamente collocate in /lib e /usr/lib:

* libdl.so.2
* libz.so.1
* libstdc++.so.6
* libm.so.6
* libgcc_s.so.1
* libpthread.so.0
* libc.so.6 (minimo glibc 2.5)
* libxml2.so.2
* libxslt.so.1
* libzip.so.1

>ATTENZIONE: Gli eseguibili del motore eXtraWay non hanno ancora una versione dispobibile a 64bit. E' necessario pertanto installare le librerie di compatibilita ia32 sulle macchine a 64 bit della maggior parte delle distribuzioni. Inoltre esistono alcuni casi riportati ((Al momento RHEL 5.6)) sul quale è necessario installare manualmente le librerie elencate in versione 32bit. Se non è possibile effettuare questi passaggi o le librerie indicate non sono presenti, la specifica distribuzione non è supportata da Docway 3.10.2.

**Per installare le librerie su sistemi Ubuntu usare il seguente comando:**

    sudo apt-get install libgcc1:i386 libzip2:i386 libc6:i386 libxml2:i386 libxslt1.1:i386 libcurl3:i386 libncurses5:i386 libreadline6:i386 libstdc++6:i386

**Per installare le librerie su sistemi RedHat/CentOS usare il seguente comando:**

    yum install libgcc.i686 libzip.i686 glibc.i686 libxml2.i686 libxslt.i686 libcurl.i686 ncurses-libs.i686 readline.i686 libstdc++.i686

###### Pdftotext

Per l'indicizzazione degli allegati in formato pdf è necessario installare l'utilità pdftotext.

In molte distribuzioni non è compresa nell'installazione di base: in alcune distribuzioni è presente all'interno del pacchetto **xpdf** (centos 4, redhat enterprise) o nel pacchetto **poppler-utils** (gentoo, ubuntu, debian, centos 5).

###### Imagemagick

Per l'indicizzazione e la conversione degli allegati in formato grafico è necessario installare l'utilità imagemagick.

In alcune distribuzioni non è compresa nell'installazione di base: tuttavia il pacchetto omonimo solitamente è presente tra quelli installabili.

###### CLASSPATH per Libreoffice > 5.1

Nel caso in cui si installi la versione di Libreoffice più recente e quindi da 5.1 in poi, bisognerà modificare il CLASSPATH all'interno del file extraway-fcs.conf in questa maniera:

**CLASSPATH=/usr/lib/libreoffice/program:$java_classes_home/../classes:$openoffice_ure/share/java/'*':$openoffice_basis/program/classes/'*':$java_classes_home/'*'**

**Client**

Macchina client con collegamento di rete diretto al server, si sconsiglia l'utilizzo di indirizzi mappati con tecnologia NAT.

###### Browser supportati

L'elenco completo è disponibile [qui](http://wiki.3di.it/doku.php?id=documentazione_3di:docway4:browser_compat&#compatibilita_browser_per_il_plugin_iwx)

#### Installazione e configurazione

##### Preparazione dell'installazione

###### Componenti che verranno installati

* Apache Tomcat 7
* Sun Java Runtime Environment 1.7.0
* LibreOffice 4/5
* Docway4

##### Preparazione della macchina server

È consigliato mantenere l'installazione dell'applicativo in un dispositivo di memorizzazione separato rispetto a quello che ospita il sistema operativo.

Il pacchetto di installazione fornito da 3DI è già configurato per essere installato sotto il direttorio /opt

Montare il dispositivo di memorizzazione scelto sotto /opt e inserire un riga apposita in /etc/fstab

__Creare un utente con nome "extraway". Questo sarà l'utente con cui verranno eseguiti tutti i processi relativi ad Docway4__

    <code bash>adduser extraway</code>

###### Copia dei files

Copiare il pacchetto di installazione di Docway4 nella cartella /opt.

Nel caso non sia possibile utilizzare il sistema di pacchetti integrato per l'installazione di libreoffice, è possibile dal [sito libreoffice](http://www.libreoffice.org) ottenere l'elenco dei repository personalizzati oppure scaricare il pacchetto generico. È possibile anche scaricare una [versione generica](ftp://ftp.3di.it/extra/libreoffice/LibO_3.3.1_Linux_x86_install-rpm_en-US.tar.gz) dal nostro sito ftp.

NB: per alcune distribuzioni (per es. CentOS) è necessario installare anche il pacchetto libreoffice-headless per poter utilizzare libreoffice anche in assenza di un'istanza del server X.

NB: Creare un link simbolico di 3di.it in it-3di

**Abilitare permessi di scrittura sul tomcat-users.xml**

Di base il file tomcat-users.xml è aperto in sola lettura, per abilitare il permesso di scrittura è necessario inserire il parametro "readonly=false" nel server.xml di Tomcat

    <GlobalNamingResources>  
    <!-- Editable user database that can also be used by  
    UserDatabaseRealm to authenticate users  
    -->  
    <Resource name="UserDatabase" auth="Container"  
    type="org.apache.catalina.UserDatabase"  
    description="User database that can be updated and saved"  
    factory="org.apache.catalina.users.MemoryUserDatabaseFactory"  
    pathname="conf/tomcat-users.xml" readonly="false" />  
    </GlobalNamingResources>

* Inserire il parametro "readonly=false" all'interno dell'attributo "Realm" (UserDatabase)" nel file /opt/apache-tomcat-7.../conf/server.xml

**Eccezioni su file jar**

Se si utilizzano i 3diws modificare come segue la riga nel catalina.properties

    <code>org.apache.catalina.startup.ContextConfig.jarsToSkip=bc*.jar,cryptix*.jar</code>

**Installazione dei pacchetti**

**Docway**

Estrarre il pacchetto docway nella cartella /opt.

Es.
    /opt# tar xvjf docway_3.8.12*.tar.bz2

Per garantire il funzionamento dell'applicativo e poter effettuare operazioni di assistenza diretta da parte dei tecnici 3DI senza necessità di utilizzare credenziali amministrative (root) è necessario assegnare la cartella /opt all'utente extraway.

Es.
    /opt# chown -R extraway:extraway /opt

**In alternativa è possibile assegnare ad extraway le singole cartelle in opt, tuttavia ciò potrebbe richiedere accesso amministrativo per effettuare aggiornamenti futuri.**

**LibreOffice**
Nel caso si sia scelta la procedura di installazione manuale estrarre il pacchetto LibreOffice.

Es.

    /opt# tar xzf LibO_3.3.1_Linux_x86_install-rpm_en-US.tar.gz

Eseguire il comando di installazione di LibreOffice (install.sh) dalla cartella estratta e seguire le indicazioni. Solitamente non è necessario cambiare nessun parametro dall'installazione di default.

Nel caso invece si pensi di utilizzare la versione della propria distribuzione è necessario controllare che i percorsi della cartella base di libreoffice e dei componenti basis e URE siano corretti nel file /opt/it-3di/platform/fcs/conf/extraway-fcs.conf

##### Accorgimenti per sistemi con versione di glibc antecedente alla 2.7

In alcuni sistemi è necessario installare la versione compatibile degli eseguibili eXtraWay. Questa versione è compilata con glibc 2.5.

Per installarli copiare i file contenuti in /opt/it-3di/extraway/xw/platform-dependent/bin-Linux/i586 in /opt/it-3di/extraway/xw/bin

##### Registrazione del motore del database (Extraway)

Per poter utilizzare Docway3 è necessario ottenere le licenze dal nostro settore commerciale.

Una volta ottenute le licenze eseguire il seguente comando dalla cartella /opt:
  
    /opt~$ ./demo.sh registration

Dopo aver inserito il numero di licenze attivate, apparirà un numero.

Es. (per 10 licenze)

    Entrato  
    Inizializzato  
    Analisi Parametri  
    Impostare il numero di postazioni da Abilitare  
    (-1=annulla, Invio=100):10  
    Inserire la chiave di abilitazione per 10-76469290

Comunicare all'assistenza 3di il numero ottenuto e inserire la chiave di abilitazione e il numero seriale che verranno forniti in cambio.

Successivamente inserire anche il nome e la società relativo al contratto di licenza.

**Automatismi**

Per utima cosa bisogna procedere a configurare il sistema operativo per interagire con i componenti in modo automatico.

##### Script di avvio

Gli script per caricare automaticamente l'applicativo all'avvio della macchina (e per riavviare l'applicativo in caso di necessità) si trovano sotto il percorso /opt/3di.it/extra/init-files e sono i seguenti:

* tomcat7
* extraway (motore database)
* extraway-fca (File Conversion Agent)
* extraway-fcs (File Conversion Service)
* extraway-msa (Mail Storage Agent)

Tutti accettano i comandi start, stop e restart.

>NOTA: gli script all'interno di questa sezione sono tutti configurabili nel caso ci sia necessità di cambiare i percorsi di installazione.
___
**Installazione automatica con script 3di**

Sono disponibili già per alcune distribuzioni degli script per inserirli automaticamente all'interno del sistema rc.d:

  * [Debian, Ubuntu](ftp://ftp.3di.it/extra/init-scripts/init.d_setup_debian.sh) (utilizza update-rc.d)
  * [Redhat, Fedora e Centos](ftp://ftp.3di.it/extra/init-scripts/chkconfig_initd.tar.bz2) (da copiare in /etc/init.d e attivare con chkconfig)
  * [Gentoo](ftp://ftp.3di.it/extra/init-scripts/gentoo_initd.tar.bz2) (da copiare in /etc/init.d e attivare con rc-update)
  * [script generico](ftp://ftp.3di.it/extra/init-scripts/init.d_setup_generic.sh) (crea direttamente i link in rc.d)

>ATTENZIONE: l'esecuzione di alcuni di questi script richiede diritti amministrativi
___
**Installazione Manuale**

È possibile anche installare questi file manualmente. È necessario creare dei link ai file in /opt/3di.it/extra/init-files/ in /etc/init.d e successivamente creare da questi dei link nei diversi runlevel:

Es.

    ~# ln -s /opt/it-3di/extra/init-files/extraway /etc/init.d/  
    ~# ln -s /etc/init.d/extraway /etc/rc0.d/K20extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc1.d/K20extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc6.d/K20extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc2.d/S79extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc3.d/K79extraway  
    ~# ln -s /etc/init.d/extraway /etc/rc4.d/K79extraway

Si consiglia di spegnere tomcat leggermente prima, di seguito l'ordine di partenza e di spegnimento di tutti i servizi:

* tomcat7: start 80 | stop 19
* extraway: start  79 | stop 20
* extraway-fca: start 79 | stop 20
* extraway-fcs: start 79 | stop 20
* extraway-msa: start 79 | stop 20

**Registro di Protocollo**

L'esportazione del RIP può essere attivata aggiungendo al crontab dell'utente extraway il comando /opt/3di.it/docway3/rip/bin/rip

Es.
    ~$ crontab -e  
    35 22 * * * /opt/it-3di/docway3/rip/bin/rip </dev/null
  
**Backup**

È altamente consigliato mantenere un backup dell'intera cartella it-3di (anche incrementale volendo).

Per fare ciò è necessario fermare i servizi extraway e tomcat6 prima di eseguire lo script di backup vero e proprio.

Es. script backup da inserire nel crontab di root:

    /etc/init.d/tomcat7 stop  
    /etc/init.d/extraway-msa stop  
    /etc/init.d/extraway-fcs stop  
    /etc/init.d/extraway-fca stop  
    /etc/init.d/extraway stop  
    <comando backup>
    /etc/init.d/extraway start  
    /etc/init.d/extraway-fca start  
    /etc/init.d/extraway-fcs start  
    /etc/init.d/extraway-msa start  
    /etc/init.d/tomcat7 start
  
**Controlli finali**

Dopo aver verificato che le applicazioni si avviino correttamente controllare in prima battuta i log di:

* Tomcat
* DocWay4
* DocWay4-service
* 3DWS (Se presenti)
* ExtraWayWorkFlowOS (Se presenti)

Se non sono presenti errori tentare un login su DocWay e verificare la presenza di eventuali errori nei log:

* DocWay4
* DocWay4-service

È buona norma comunicare al referente del progetto l'avvenuta installazione o aggiornamento degli applicativi.

  
**Patch installate**

Per Docway4 vengono rilasciate della patch e seguono una numerazione a se stante. Per individuare la versione di patch installata leggere il file Patch_level.txt presente nella root dell'applicativo.
