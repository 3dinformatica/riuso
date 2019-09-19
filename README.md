# Descrizione del progetto di Riuso

3D Informatica vanta oltre trent’anni di esperienza al servizio di Pubbliche Amministrazioni, locali e centrali, complesse e articolate, alle quali viene offerto un supporto totale rispetto a tutti i processi di progettazione, sviluppo, mantenimento e miglioramento di sistemi informativi.

Nel rispetto delle novità introdotte dal piano triennale per l’informatica nella Pubblica Amministrazione e delle linee guida su acquisizione e riuso di software per le Pubbliche Amministrazioni, e grazie al supporto di ADER (Agenzia Delle Entrate/Riscossione) l'azienda ha avviato come incaricata il progetto di riuso di alcuni moduli software, sviluppati per conto di ADER ed imperniati attorno al sistema di gestione documentale e protocollo informatico DocWay.

Il **progetto di riuso** si articola dunque attraverso la liberazione del sorgente di questi moduli software ed il rilascio dell'applicazione DocWay in formato eseguibile, per abilitare qualsiasi utilizzatore ad avere con pochi click ed una procedura di installazione semplificata, un sistema documentale di protocollo completo e ricco di funzionalità, compliant con la normativa e basato su standard archivistici.

Allo stesso tempo i moduli dei quali viene liberato il codice sorgente, possono essere utilizzati sia in combinazione con l'applicazione documentale scaricata e rilasciata in questo repository come dipendenza al fine di estenderne le funzionalità e le capacità, sia come progetti software a se stanti, ciascuno dei quali in grado di operare ad uno strato più "generico" con specifiche finalità.

La licenza di distribuzione open source scelta dall'Amministrazione è la **Affero General Public License (AGPL) v3.** 

Per ciascun modulo descritto di seguito, vengono indicate le funzionalità principali e l'architettura del modulo stesso, il flusso di esecuzione, le dipendenze, le modalità di installazione e di utilizzo così come suggerimenti per gli sviluppatori che dovessero usare il codice liberato per implementarlo in proprie applicazioni.

## [FCA](https://github.com/3dinformatica/docway-fca/blob/master/README.md)/[FCS](https://github.com/3dinformatica/docway-fcs/blob/master/README.md)

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


## [Console Audit](https://github.com/3dinformatica/auditConsole/blob/master/README.md)

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

## [MSA](https://github.com/3dinformatica/docway-msa/blob/master/README.md)

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

eXtraWay e DocWay, applicazioni rilasciate in formato eseguibile come dipendenze dei moduli liberati nei diversi repository pubblicati, possono essere installati in due differenti modalità.

* creazione di una VM gestita da Vagrant, che consente l'installazione completa delle dipendenze (eXtraWay e DocWay) e di tutti i moduli presenti (FCA/FCS, MSA, AUDIT, BRIDGE).

* installazione dei singoli pacchetti di eXtraWay e DocWay.

### 1. VM gestita da vagrant

Installazione VirtualBox       https://www.virtualbox.org/

Installazione Vagrant          https://www.vagrantup.com/


1) Dopo aver installato le due applicazioni installare il plugin che permette a Vagrant di comunicare con virtualbox


    - Da una shell lanciare: vagrant plugin install vagrant-vbguest


2) Posizionarsi dentro la cartella appena scaricata e lanciare il comando: vagrant up


Dopo aver testato il funzionamento fare pulizia con il comando: vagrant destroy --force


### 2. Installazione singoli pacchetti

#### Istruzioni installazione eXtraWay come platform

##### Installazione su piattaforma Windows di Extraway Platform

###### Requisiti Hardware

Le specifiche della macchina server dipendono principalmente dal numero di utenti che utilizzerà l'applicativo e dal tipo di utilizzo. In linea di massima le prestazioni di Extraway dipendono dalla velocità dei dispositivi di memorizzazione, dalla velocità della rete e, per la gestione di allegati non testuali, dalla memoria RAM.

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

###### Requisiti software

**Server**

* Windows server 2003 sp2

* Windows server 2008 r2 64bit

* Windows server 2012 64bit

* Antivirus che possa essere configurato con eccezioni per quanto riguarda il controllo dei processi (ad esempio panda non funziona)

* Accesso tramite remote desktop o vnc((Nel caso si voglia usufruire dell'assistenza da remoto da parte di 3DI))

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

Non è necessario cambiare alcuna configurazione durante l'esecuzione del setup. Di base il Java Runtime Environment ha come destinazione <color #004000>C:\Programmi\Java\jre6\</color>.
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

L'Extraway server richiede alcune librerie di sistema per funzionare. Per installarle è sufficiente lanciare l'eseguibile xw3dp-setup.exe e seguire le instruzioni.

* Eseguire **e:\3di.it\extraway\xw\bin\xw.exe**

Per poter installare il servizio extraway è necessario eseguire il setup dal percorso **e:\3di.it\extraway\xw\bin**:

* Eseguire **e:\3di.it\extraway\xw\bin\HISETUP.exe**
* Premere il tasto **"Installa / Avvia"** e chiudere il setup


###### Installazione Versione maggiore di 25.8.0

Scaricato il pacchetto eXtraway della versione desiderata, copiare il contenuto della cartella 3di.it nel disco locale della macchina e lanciare l'installazione delle librerie microsoft (2008 e 2010 x86 e x64) presenti nella cartella **'vcredist'**.

    WRAP center round info 800%>  
    NB: Effettuare le installazione sempre come Amministratore!  
    </WRAP>

Successivamente installare le librerie presenti nella cartella **'xw3dparts'** necessarie al server eXtraway lanciando l'eseguibile **'xw3rdp-setup-2012.exe'**

Dopo aver registrato l'applicazione procedere con l'installazione del servizio:

Aprire un prompt dei comandi (cmd.exe) e digitare il percorso della cartella contenente l'eseguibile xw.exe (es. 'e:\3di.it\extraway\xw\bin\xw.exe') , 

Lanciare il comando per l'installazione del servizio: 'xw.exe -service_install'


###### Servizi di Conversione dei file (FCA, FCS, LibreOffice)

=== Installazione di LibreOffice ===
Il [[ftp://ftp.3di.it/extra/libreoffice/LibO_3.3.1_Win_x86_install_multi.exe | pacchetto LibreOffice 3.3.1]] è disponibile per l'installazione dal [[ftp://ftp.3di.it/ | sito ftp 3DI]].
  * <color darkblue>Eseguire il setup di LibreOffice</color>
  * <color darkblue>Scegliere l'installazione personalizzata e inserire come percorso e:\LibreO~1.org</color>
<color #505050>//ATTENZIONE: per il funzonamento di fcs è necessario che LibreOffice sia installato in un percorso corto((Questo problema è causato dalle limitazioni della shell di windows))//</color>
\\
Non sono necessarie altre modifiche alle impostazioni del setup di LibreOffice.
\\
\\
<WRAP center round info 90%>
Su Windows 10 è stato necessario aggiungere il file install_custom.cmd richiamato dall'install.bat settando le variabili JAVA_HOME e JVMDLL
</WRAP>


=== File Conversion Agent (FCA) ===
<WRAP center round info 70%>
Per installare come servizi l'fca e fcs lanciare l'install.bat da console di amministrazione.
</WRAP>

Il modulo FCA risiede nella cartella <color #004000>e:\3di.it\platform\fca</color>, come nel caso dell'MSA, nel percorso <color #004000>e:\3di.it\platform\fca\bin</color> è presente il file <color #004000>install.bat</color>:
  @echo off
  
  set _W=e:\3di.it\platform\fca
  set xwbin=e:\3di.it\extraway\xw\bin
  
  @rem set JAVA_HOME =
  @rem impostarla come variabile di sistema, altrimenti scrivere il percorso esplicito nella variabile sottostante
  set _J=C:\Programmi\Java\jre6\bin\client\jvm.dll
  call fca.bat

  * <color darkblue>Inserire per la variabile "_J" il valore "C:\Programmi\Java\jre6\bin\client\jvm.dll"</color>
  * <color darkblue>Inserire per la variabile "_W" il valore "e:\3di.it\platform\fca"</color>
  * <color darkblue>Inserire per la variabile "xwbin" il valore "e:\3di.it\extraway\xw\bin"</color>
  * <color darkblue>Eseguire lo script per installare il modulo</color>
=== File Conversion Service (FCS) ===
Il modulo FCS risiede nella cartella <color #004000>e:\3di.it\platform\fcs</color>, come nei casi precedenti, nel percorso <color #004000>e:\3di.it\platform\fcs\bin</color> è presente il solito file <color #004000>install.bat</color> (si riporta solo la dichiarazione delle variabili da configurare della versione distribuita a partire dalla release //3.6.1.0// di FCS):
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

  * <color darkblue>Inserire per la variabile "_J" il valore "C:\Programmi\Java\jre6\bin\client\jvm.dll"</color>
  * <color darkblue>Inserire per la variabile "_W" il valore "E:\3di.it\platform\fcs"</color>
  * <color darkblue>Inserire per la variabile "_O" il valore "E:\LibreO~1.org" (come da installazione LibreOffice)</color>
  * <color darkblue>Eseguire lo script per installare il modulo</color>
\\
Per poter utilizzare l'FCS inoltre è necessario installare alcune librerie nel sistema:
  * <color darkblue>Copiare il contenuto della cartella e:\3di.it\platform\fcs\bin\system32 dal CD nella cartella di sistema di windows c:\windows\system32</color>

=== Imagemagick e Tesseract ===
Per poter utilizzare alcune delle funzionalità di conversione degli allegati sono necessari questi componenti che si trovano all'interno della cartella <color #004000>fcs_utils</color> del cd. Si consiglia di installare queste utility in <color #004000>e:\programmi</color>. Tesseract dalle ultime versioni è integrato all'interno della cartella platform mentre per imagemagick esiste un setup.exe. Nel caso si vogliano modificare i percorsi di installazione sarà necessario modificare di conseguenza il file <color #004000>e:\3di.it\platform\fcs\classes\it.extrawaytech.fcs.properties</color>.

* <color darkblue>Installare Imagemagick in e:\programmi</color>


==== Webservices ====
Solitamente i webservice si trovano nel percorso <color #004000>E:\3di.it\webservices\</color>.
\\
Per installarli è necessario inserire nella cartella di configurazione di Tomcat i due file <color #004000>xJwsClient.xml</color> e <color #004000>3diws.xml</color>. Come il file xway.xml per docway, contengono nell'intestazione il percorso da modificare.

  * <color darkblue>Copiare il file xJwsClient.xml dalla cartella E:\3di.it\webservices\</color>
  * <color darkblue>Modificare il file xJwsClient.xml e inserire il percorso E:\3di.it\webservices\xJwsClient</color>
  * <color darkblue>Copiare il file 3diws.xml dalla cartella E:\3di.it\webservices\</color>
  * <color darkblue>Modificare il file 3diws.xml e inserire il percorso E:\3di.it\webservices\3diws</color>

===== Registrazione del servizio eXtraWay =====
Per poter utilizzare il modulo xw è necessario effettuare la registrazione:
  * <color darkblue>Eseguire e:\3di.it\extraway\xw\bin\xw.exe</color>
Nel System tray apparirà un icona con il logo di eXtraWay:
\\
{{:documentazione_3di:extraway_os:taskbar.jpg|Icona nella Tray Bar}}
\\
\\
Con il tasto sinistro del mouse sopra l'icona si aprirà la seguente schermata:
\\
{{:documentazione_3di:extraway_os:xw_reg_main.jpg}}
\\
  * <color darkblue>Premere il pulsante "Registration"((Il pulsante nelle versioni precedenti era "Aggiorna licenza"))</color>
Si aprirà un altra finestra col nome "eXtraWay Server Installation" che richiede "Insert the number of workstations to activate". Il numero di postazioni indica il numero di istanze massime che possono essere attive in contemporanea sul server((Per convenzione di solito questo numero è il numero massimo degli utenti contemporanei  che utilizzeranno il server diviso 15 e può dipendere anche dalle prestazioni della macchina)).
  * <color darkblue>Inserire il numero di postazioni massime</color>
  * <color darkblue>Inserire il numero di serie (se presente)</color>
  * <color darkblue>Inserire il nome del responsabile e l'organizzazione</color>
Una volta completata la registrazione compare una finestra "registrazione completata" al di sotto della prima finestra, premere ok per chiudere la procedura.

#### Istruzioni installazione DocWay
