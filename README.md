# Descrizione dei progetti in Riuso

## FCA/FCS

FCA (File Conversion Agent) e FCS (File Conversion Service) consistono in 2 processi che permettono l'**estrazione del testo da files** e la **conversione di files in un differente formato** (es. da DOC a PDF). 

Lo scenario di utilizzo può variare a seconda del carico di lavoro:
- In ambienti di ridotte dimensioni (carico di lavoro non elevato) entrambi i processi possono essere installati (e configurati) sullo stesso server;
- In ambienti con un elevato carico di lavoro (in termini di numero di richieste) è possibile scalare l'attività di estrazione testo e conversione su più server. In questo scenario verrà installato **una ed una sola istanza di FCA** (che si occuperà di recuperari i lavori da portare a termine) e **N istanze di FCS** (su differenti server) che si occuperanno di elaborare i file e registrare il risultato dell'attività richiesta.

### Flusso di esecuzione

La logica secondo la quale viene svolta tale attività è descritta di seguito:
- FCA si occupa di recuperare tutti i lavori pendenti (richieste di estrazione e/o conversione) e di gestire la coda di lavori pendenti e la comunicazione con il pool di FCS. All'avvio della comunicazione con ogni istanza di FCS viene inviato un set di informazioni inerenti la configurazione dell'ambiente (timeout da applicare all'elaborazione, eventuali estensioni di file da ignorare, etc.);
- Ogni FCS riceve un lavoro da eseguire da parte di FCA, esegue l'attività richiesta e registra il risultato (caricamento dei file prodotti dalla conversione e/o del testo estratto);
- Al termine dell'elaborazione FCS comunica a FCA l'esito dell'attività in modo da poter ricevere il lavoro successivo.

### Descrizione dei progetti

I progetti di FCA ed FCS (progetti _JAVA_) sono stati suddivisi in 2 librerie che corrispondo a:
- Logiche generiche utilizzatibili in differenti ambiti (progetti abstract);
- Implementazioni specifiche per uno scenario (nel nostro caso DocWay).

In base alla struttura appena descritta, è quindi possibile utilizzare le librerie abstract per poter gestire scenari differenti da quello DocWay (è sufficiente realizzare le implementazioni richieste dai progetti abstract). Per maggiori dettagli sull'attività si rimanda alla documentazione specifica dei progetti.

#### FCA

**it.tredi.abstract-fca**: Configurazione del POOL di FCS con gestione del recupero e assegnazione dei lavori ai differenti processi di FCS (su server distinti).

**it.tredi.docway-fca**: Implementazione per DocWay di FCA, ovvero recupero dei documenti di DocWay da processare (documenti contenenti allegati per i quali è richiesta la conversione e/o estrazione del testo).


#### FCS

**it.tredi.abstract-fcs**: Elaborazione vera e propria dei files. Logiche di conversione ed estrazione testo dai file (integrazione con le varie dipendenze software).

**it.tredi.docway-fcs**: Implementazione per DocWay di FCS (aggiornamento dell'esito dei lavori, registrazione dei file convertiti, indicizzazione del testo contenuto negli allegati del documento, etc.).


### Requisiti

Requisiti per l'esecuzione di conversioni ed estrazione di testo da parte di FCS:
- OpenOffice
- ImageMagick
- Tesseract


## Console Audit

Web Application grazie alla quale è possibile consultare i dati di audit registrati per uno o più applicativi. L'interfaccia web realizzata permette (previa autenticazione ed autorizzazione) diversi filtri di ricerca sui risultati registrati tramite AUDIT:
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

I dati di AUDTI sul database mongodb vengono registrati attraverso un'apposita librieria realizzata per DocWay. E' comunque possibile implementare una propria versione della registrazione del record di AUDIT (per un qualsiasi applicativo) ed utilizzare la console di AUDIT per la consultazione dei dati.

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



## Gestione documentale e protocollo informatico

#### Soluzione, configurabile e integrabile tramite appositi moduli, per la gestione dell'intero ciclo di vita di un documento, nel rispetto della normativa archivistica e delle best practices di settore.

DocWay è stato pensato e sviluppato per consentire agli utenti:
* l'acquisizione, la registrazione, la ricerca e la consultazione delle diverse tipologie di documenti sia interni sia di scambio con l'esterno
* l'organizzazione dei documenti secondo un piano di classificazione e archiviazione in fascicoli, secondo le necessità di ordinamento e di ricerca più coerenti e congrue rispetto alla gestione materiale (fisica) degli stessi
* il trattamento (organizzazione e sedimentazione) dei documenti nell'ambito dei processi amministrativi e/o aziendali

![Home Page DocWay](images\homeDW.jpg)

Nello specifico DocWay garantisce:

* la gestione del Protocollo in Arrivo, Protocollo in Partenza, Protocollo Interno, Protocollo Riservato, di documenti non protocollati, di Repertori Archivistici (protocollati e non), di e-mail, PEC, etc., anche con registrazione a protocollo automatica di file ricevuti tramite procedura di interoperabilità definita dalla Circolare Agid n. 60 del 23/01/2013;
* la protocollazione differita per i documenti in arrivo e uno specifico scadenziario con possibilità di impostare la notifica di allarme; è possibile la registrazione in “bozza” di ogni documento;
* il controllo su documenti già registrati: prima di procedere a una nuova registrazione di protocollo, viene verificato se lo stesso documento è già registrato da un altro utente e visualizzato su nuova finestra il duplicato con possibilità di confermare o annullare l'operazione in corso;
* la segnatura del documento protocollato, personalizzabile, con possibilità di scegliere quali dati stampare tra quelli di protocollazione / fascicolazione, anche sotto forma di codice a barre; applicazione automatica del WATERMARK di segnatura sui file PDF/A;
* la gestione a norma della interoperabilità tra i sistemi di protocollo informatico tramite spedizione con posta certificata del documento firmato e della relativa segnatura in formato XML, con gestione e archiviazione automatica delle ricevute di ritorno, unitamente alla protocollazione automatica e/o semi-automatica di documenti ricevuti telematicamente da sistemi di protocollo informatico di altre amministrazioni pubbliche; invio multiplo delle mail e pec: tutti i TO e i CC vengono inseriti nella stessa mail/pec (rispettando le modalità di invio [TO e CC] con specifica creazione del file di segnatura XML);
* la registrazione dei metadati per i documenti assoggettati alla protocollazione con assoluta aderenza alle normative tecniche in tema di modalità di attribuzione univoca del protocollo per AOO, insieme dei metadati richiesti, i metadati obbligatori e immodificabilità degli stessi e calcolo dell'impronta;
* la protocollazione massiva di una selezione di documenti;
* il tracciamento continuo delle lavorazioni, effettuate sul documento, dalla registrazione e assegnazione alle modificazioni e annotazioni e la gestione degli stati di un documento;
* la gestione del cestino per evitare cancellazioni accindentali di documenti (valido solo per documenti su cui è possibile la cancellazione) e con possibilità di ripristino del documento;
* la creazione e repertoriazione automatica del registro giornaliero del protocollo, con predisposizione per l'invio in conservazione a norma;
* l'utilizzo del registro di protocollo di emergenza informatico: viene fornito un file già strutturato con i campi dei dati di protocollo obbligatori, che verrà importato automaticamente nel sistema una volta ripristinato;
* diverse modalità di assegnazione dei documenti: al Responsabile di un Ufficio, a tutti gli utenti di un Ufficio, alla singola persona, a un gruppo di utenti e a un Ruolo; le assegnazioni vengono effettuate per Responsabilità (RPA o proprietario), in Copia Conoscenza (anche attribuendo il diritto di intervento), per Incarico (Operatore Incaricato) e per Conferenza di Servizi;
* la notifica automatica (anche in modalità differita) via e-mail agli assegnatari di un documento durante tutte le fasi di lavorazione effettuate sul documento e/o fascicolo;
* la gestione della presa in carico di documenti consente di richiedere, al momento dell'assegnazione di un documento (RPA, CC, Operatore incaricato, CDS) la presa in carico da parte dell'assegnatario che può essere una singola persona o un ruolo.
* l'assegnazione massiva di documenti a partire da una selezione di documenti;
* l'accesso in delega che consente a un utente di accedere con i diritti e le credenziali di un'altra persona interna (che lo ha designato opportunamente) e di tenere traccia di tutte le operazioni che vengono eseguite.

![Funzionalità DocWay](images\cruscottoDW.jpg)

* la personalizzazione delle tipologie documentali standard ARRIVO, PARTENZA, INTERNO, NON PROTOCOLLATO con aggiunta di metadati personalizzati e possibilità di semplificazione dei metadati di default; utilizzo di etichette personalizzate a integrazione delle informazioni di classificazione;
* la personalizzazione di nuove tipologie di documenti con aggiunta di metadati personalizzati e possibilità di semplificazione dei metadati di default; rendering automatico delle maschere di inserimento, ricerca, visualizzazione per i documenti personalizzati;
* la personalizzazione dei fascicoli standard con aggiunta di metadati personalizzati e possibilità di semplificazione dei metadati di default; rendering automatico delle maschere di inserimento, ricerca, visualizzazione per fascicoli e personalizzati;
* la personalizzazione di nuove tipologie di Fascicoli e Raccoglitori con aggiunta di metadati personalizzati e possibilità di semplificazione dei metadati di default; rendering automatico delle maschere di inserimento, ricerca, visualizzazione per i documenti personalizzati;
* la gestione del Fascicolo del Personale;
* la gestione del lavoro di gruppo grazie al tracciamento della redazione delle diverse versioni di un documento e ai meccanismi per la gestione dell'accesso ai documenti in modifica da parte di più utenti (check-in/check-out), e rappresenta un valido supporto alla formazione condivisa dei documenti.
Il sistema garantisce, per ogni nuova versione del file, il relativo aggiornamento dell'impronta. In ogni momento è possibile, per chi ne ha i diritti, vedere le versioni precedenti dei file di contenuto;
* la definizione dei repertori d'archivio con configurazione della modalità di numerazione (per anno, continua, per intervallo temporale), della tipologia dei documenti associati al repertorio, delle modalità di fascicolazione e della possibilità o meno di cancellazione di un reportorio (solo per repertori non associati al protocollo); la repertoriazione di un documento, a partire da un documento esistente;
* la classificazione e l'assegnazione automatica mediante la funzione “Voci di Indice”; le Voci di Indice sono lo strumento attraverso il quale è possibile definire uno o più lemmi a cui associare e definire: un oggettario per una puntuale e corretta descrizione archivistica, la classe e il titolo per la corretta classificazione e sedimentazione del documento in archivio, lo scarto, le assegnazioni automatiche ai destinatari interni, l'individuazione dell'eventuale procedimento (avvio automatico di un workflow BPM). Le “Voci di Indice” sono utilizzate in fase di registrazione di un documento (soggetto alla registrazione a protocollo o meno) e non solo rappresentano lo strumento per un mini “workflow predefinito” (assegnazioni), ma estendendo e garantiscono, in automatico, una completa registrazione “archivistica” del documento.
* l'ordinamento di tutti i documenti, all'interno di un sistema archivistico correttamente strutturato, attraverso attività di classificazione (Titolario di classificazione multilivello), fascicolazione gerarchica (fascicoli, sotto-fascicoli, inserti, annessi e allegati), non gerarchica (raccoglitori) e serie archivistiche (repertori); possibilità di assegnare un intero fascicolo in copia conoscenza;
* la gestione dei collegamenti tra documenti, fascicoli, raccoglitori per navigazioni trasversali; il trasferimento della titolarità di tutti i fascicoli e documenti da utente a un altro, ad esempio per passaggio di consegne e storicizzazione di tutte le operazioni di smistamento del documento.
* la definizione delle tipologie di allegati informatici (ad esempio DOC, PDF, ZIP, EML, etc..) ammessi in fase di registrazione di un documento;
* il caricamento di un file ZIP con scompattamento dei singoli file con verifica e salvataggiodei soli formati ammissibili;
* la creazione automatica di un documento attraverso modalità drag&drop;
* la pubblicazione per Albo on Line / Trasparenza attraverso WEB Service o modulo Bridge
strumenti di reporting per la generazione di statistiche anche mediante esportazione in formato CSV selettivo e memorizzazione dei report configurati nella scrivania dell'utente;
___

##### Infrastruttura tecnologica e applicativa

DocWay è una full web application sviluppata in Java in ambiente J2EE in architettura three-layer utilizzabile su protocollo sicuro HTTPS. Non facendosi uso di EJB o di altre funzionalità, che richiedono l'impiego di un Application Server, è sufficiente l'utilizzo di un Servlet Container quale Tomcat.

La soluzione proposta gestisce e supporta la modalità multi-Ente e multi-AOO senza alcuna limitazione, né tecnologica, né funzionale, né commerciale in quanto consente di configurare più ambienti virtuali e fisici al fine di bilanciare l'esigenza di performance con la massima separazione delle informazioni e autonomia dei sottosistemi.

![Struttura DocWay](images\strutturaDW.png)

Si tratta di una soluzione aperta basata sulle piattaforme tecnologiche MongoDB e eXtraWay XML, pensata e realizzata adottando gli Open Standard di riferimento (XML, JEE, SOA, JASON), per garantire l'espandibilità della soluzione e per accogliere una eventuale futura razionalizzazione e automazione di altri flussi applicativi.

È un sistema full web modulare e multi piattaforma, dove ogni modulo che lo compone realizza in maniera compiuta e consistente una specifica funzione. Tutti i moduli sono tra loro integrati e interoperabili per mettere a disposizione dell'intero sistema un impianto funzionale molto completo. Tutti i moduli sono realizzati in linguaggio Java e pertanto sono trasportabili, senza necessità di ricompilazione, da sistemi operativi Linux a sistemi Windows o Unix.

Risponde a stringenti requisiti in termini di sicurezza, sia per quanto concerne l'accesso al sistema, sia per quanto concerne l'autenticità e la sicurezza dei documenti gestiti. Il sistema può avvalersi di sistemi di autenticazione forte per l'accesso (su richiesta), e di una architettura PKI per quanto concerne la firma e la crittografia dei documenti, nonché la loro archiviazione digitale a norma.

Tutti i moduli del sistema (Modulo ACL, Modulo DOC e Modulo Workflow) possono essere utilizzati singolarmente grazie alla propria interfaccia applicativa e forniscono sia le funzionalità DM di base (XML Engine), sia i servizi SOA necessari al funzionamento dell'intera piattaforma.
La gestione dei dati in formato XML nativo, lo rende un sistema aperto che si adatta alla struttura e alle esigenze dell'azienda, permettendo il colloquio con tutti gli altri sistemi installati presso l'Amministrazione
___

##### Moduli

*DATABASE & INDEX LAYER*

Il DATABASE & INDEX LAYER è affidato completamente alla piattaforma documentale eXtraWay XML DATABASE.

*eXtraWay COMMON INTERFACE*

Il modulo, sviluppato in JAVA, fornisce la via di comunicazione da parte degli applicativi verso eXtraWay XML DATABASE. In sostanza costituisce lo strato di più basso livello per poter utilizzare in maniera completa i servizi esposti dal DATABASE & INDEX LAYER quali l'inserimento di documenti, la modifica, funzioni di ricerca, la gestione dei thesauri e degli indici. La comunicazione avviene tramite socket (TCP/IP).

*DOCUMENT MANAGEMENT PLATFORM*

Il modulo, sviluppato in Java, fornisce a DocWay XML uno strato di librerie di più alto livello di quello esposto dalla eXtraWay COMMON INTERFACE e implementa una serie di moduli per pilotare tutte le componenti applicative del sistema. Fornisce inoltre la base sui cui sono realizzati i web services. Fornisce la base per l'integrazione dei servizi per la Conservazione a norma, gestiti e realizzati dal modulo eXtraWay BRIDGE.

*eXtraWay BRIDGE*

Bridge è un modulo software la cui finalità è quella di gestire il processo di conservazione digitale dei documenti, in particolare il processo di conservazione sostitutiva. Il software è facilmente interfacciabile con tutti i sistemi di protocollo informatico e gestione documentale tramite un connettore SQL via JDBC e inoltre consente l'invio in conservazione di documenti che non sono gestiti da un sistema di gestione documentale ma che risiedono sul file system o su supporto ottico dell'utente, si pensi ad esempio ai mandati di pagamento, ai PUC, ecc. Il software è stato progettato non solo per essere indipendente dalla sorgente dati ma anche dal modulo esterno di conservazione.

*FCS/FCA*

Specifici moduli JAVA, FCS (File Conversion Service) e FCA (File Conversion Agent) rappresentano le componenti di servizio per le seguenti operazioni (funzionalità) sui file allegati ai documenti:
* Estrazione del testo per l'indicizzazione del contenuto;
* OCR;
* Conversione in PDF;
* Estrazione dei metadati dei documenti digitali;
* Conversione in formato XML (formato open document);
* Confronto tra versioni differenti dello stesso file.
FCS e FCA vengono installati come servizi multi-processo (possono stare anche su macchine differenti) e comunicano tra loro mediante TCP/IP. FCA gestisce e elabora una coda di richieste di conversione e invia i file a FCS che si occupa della conversione vera e propria. Per le principali conversioni FCS utilizza Open Office.

*MSA*

MSA (Mail Storage Agent) è un servizio Java multi-processo che si occupa delle seguenti operazioni:
* archiviazione delle email PEC e non (le mail vengono trasformate e salvate in documenti in DocWay XML);
* scambio di documenti tra sistemi DocWay XML differenti mediante la posta elettronica certificata (interoperabilità);
* Completa gestione del processo di interfacciamento con lo SdI per le fatture elettroniche.
MSA lavora esaminando periodicamente delle caselle di posta (certificate o meno) e dispone di una sua specifica console di amministrazione e controllo

*AUDIT*

Il modulo di Audit ha l'obiettivo di registrare tutte le azioni svolte su DocWay XML da parte degli operatori registrandole in un apposito archivio basato su mongoDB e autonomo dall'archivio DocWay, in modo da garantire l'integrità e l'indipendenza dei dati registrati. Tutti i dati registrati nel modulo di audit (messi a disposizione per la consultazione) garantiscono l'inalterabilità e la non modificabilità delle informazioni stesse e la sicurezza contro manomissioni da parte di terzi.

*AUTENTICAZIONE*

Il sistema di autenticazione del quale è dotato il sistema prevede l'utilizzo di moduli aggiuntivi per permettere diversi tipi di autenticazione. La struttura modulare di questo sistema permette di utilizzare diversi sottosistemi. Viene a questo punto definito un Realm a cui è possibile assegnare il modulo desiderato: da quelli compresi nell'installazione di TOMCAT, a quelli che possono essere scaricati dal web o addirittura implementati per soluzioni personalizzate. I moduli di autenticazione attualmente utilizzati sono: Autenticazione di base, tramite db xml su disco (tomcat-users.xml); Autenticazione LDAP, tramite directory su protocollo ldap; Autenticazione MYSQL, SQL; .Autenticazione Microsoft Active Directory, tramite un isapi per IIS.

DocWay può essere integrato con i sistemi di Identity and Access Management già presenti, l'identificazione e l'autenticazione degli utenti potranno avvenire tramite interconnessione ai sistemi di identificazione e di autenticazione in uso presso l'amministrazione, basati su Shibboleth. Il modulo eXtraWay Bridge è attualmente già integrato con autenticazione Shibboleth.

*3DIWS*

Tale modulo rende disponibili i Servizi Web di DocWay XML sviluppati in Java utilizzando Apache Axis  come implementazione del protocollo SOAP. 3DIWS espone le principali funzionalità di DocWay. I servizi sono completamente integrati con lo strato software DOCUMENT MANAGEMENT PLATFORM fornendo automaticamente la gestione dei diritti utente. Sono inoltre disponibili servizi per la gestione degli utenti in ACL.
Tramite i servizi WEB sono state effettuate integrazioni con i seguenti sistemi/ambienti:

`SAP, Microsoft SharePoint, Microsoft Dynamics NAV, Formula ERP, Alfresco, Easy Web`
___

#### Struttura del repository

Nel presente repository sono disponibili i war per le applicazioni: DocWay4, DocWay4-service, BRIDGE e AUDIT; i pacchetti precompilati di: eXtraWay, FCS, FCS e MSA.

Nel repository è disponibile anche un pacchetto che consente il deploy veloce dell'intero stack applicativo, con la creazione di una macchina virtuale.
Una volta avviata la macchina virtuale ospiterà pronti all'uso i seguenti applicativi:

- eXtraWay SE
- DocWay-fca
- DocWay-fcs
- DocWay-msa
- DocWay4
- DocWay4-service
- 3diws
- ExtraCDBridge
- auditConsole

Per il corretto funzionamento sono utilizzati software di terze parti:
- MongoDb
- Oracle JDK 7
- Oracle JDK 8
- Apache Tomcat 7
- Apache Tomcat 8
- Libreoffice
- Tesseract ocr
- ImageMagick
___
#### Prerequisiti e dipendenze per installazione su Linux (Debian o derivate):

- MongoDb
- Oracle JDK 7
- Oracle JDK 8
- Apache Tomcat 7
- Apache Tomcat 8
- Libreoffice
- Tesseract ocr
- ImageMagick
- Lib a 32 bit(i386):
  - libgcc
  - libzip
  - libc6
  - libxml
  - libxslt
  - libcurl
  - libncurses
  - libreadline
  - libstdc++

___
#### Istruzioni per l'installazione:

```
dpkg --add-architecture i386
apt-get update
apt-get install -y libgcc1:i386 libzip4:i386 libc6:i386 libxml2:i386 libxslt1.1:i386 \
                libcurl4:i386 libncurses5:i386 libreadline7:i386 libstdc++6:i386

ln -s /usr/lib/x86_64-linux-gnu/libreadline.so.7 /usr/lib/x86_64-linux-gnu/libreadline.so.6
ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
ln -s /usr/lib/i386-linux-gnu/libzip.so.4 /usr/lib/i386-linux-gnu//libzip.so.2

useradd -m extraway -d /opt/3di.it -s /bin/bash
cp /home/vagrant/.bashrc /opt/3di.it/.bashrc
grep -qxF 'kernel.shmmax=268435456' /etc/sysctl.conf || echo "kernel.shmmax=268435456" >> /etc/sysctl.conf && sysctl -p
grep -qxF '0 0 * * 0 /bin/rm -f /opt/3di.it/extraway/xw/conversion/*.xml >/dev/null 2>&1' /etc/crontab || echo "0 0 * * 0 /bin/rm -f /opt/3di.it/extraway/xw/conversion/*.xml >/dev/null 2>&1" >> /etc/crontab

cd /opt/
useradd -m extraway -d /opt/3di.it -s /bin/bash
cp /home/vagrant/.bashrc /opt/3di.it/.bashrc
grep -qxF 'kernel.shmmax=268435456' /etc/sysctl.conf || echo "kernel.shmmax=268435456" >> /etc/sysctl.conf && sysctl -p
grep -qxF '0 0 * * 0 /bin/rm -f /opt/3di.it/extraway/xw/conversion/*.xml >/dev/null 2>&1' /etc/crontab || echo "0 0 * * 0 /bin/rm -f /opt/3di.it/extraway/xw/conversion/*.xml >/dev/null 2>&1" >> /etc/crontab

cp /opt/3di.it/extra/systemd-script/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable {extraway,docway-fcs,docway-fca,docway-msa,tomcat7,tomcat8}

apt-get install -y libreoffice tesseract-ocr poppler-utils imagemagick

wget https://www.mongodb.org/static/pgp/server-3.6.asc && apt-key add server-3.6.asc
echo "deb [arch=amd64] http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
apt-get update && apt-get install -y mongodb-org-server mongodb-org-shell

systemctl enable mongod
```
___

##### Status del progetto:

- stabile

##### Limitazioni sull'utilizzo del progetto:

Il software, allo stato attuale, deve essere associato a un database specifico.

SW | DB
--- | ---
DocWay | eXtraWay
FCS/FCA | eXtraWay
MSA | eXtraWay + MongoDB
AUDIT | MongoDB
___

##### Detentori di copyright:

Agenzia delle Entrate-Riscossione (ADER)

##### Soggetti incaricati del mantenimento del progetto open source:

| 3D Informatica srl |
| :------------------- |
| Via Speranza, 35 - 40068 S. Lazzaro di Savena |
| Tel. 051.450844 - Fax 051.451942 |
| http://www.3di.it |

##### Indirizzo e-mail a cui inviare segnalazioni di sicurezza:
segnalazioni@3di.it
