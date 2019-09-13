# Descrizione del progetto di Riuso.

3D Informatica vanta oltre trent’anni di esperienza al servizio di Pubbliche Amministrazioni, locali e centrali, complesse e articolate, alle quali viene offerto un supporto totale rispetto a tutti i processi di progettazione, sviluppo, mantenimento e miglioramento di sistemi informativi.

Nel rispetto delle novità introdotte dal piano triennale per l’informatica nella Pubblica Amministrazione e delle linee guida su acquisizione e riuso di software per le Pubbliche Amministrazioni, e grazie al supporto di ADER (Agenzia Delle Entrate/Riscossione) l'azienda ha avviato come incaricata il progetto di riuso di alcuni moduli software, sviluppati per conto di ADER ed imperniati attorno al sistema di gestione documentale e protocollo informatico DocWay.

Il progetto di riuso si articola dunque attraverso la liberazione del sorgente di questi moduli software ed il rilascio dell'applicazione DocWay in formato eseguibile, per abilitare qualsiasi utilizzatore ad avere con pochi click ed una procedura di installazione semplificata, un sistema documentale di protocollo completo e ricco di funzionalità, compliant con la normativa e basato su standard archivistici.

Allo stesso tempo i moduli dei quali viene liberato il codice sorgente, possono essere utilizzati sia in combinazione con l'applicazione documentale scaricata e rilasciata in questo repository come dipendenza al fine di estenderne le funzionalità e le capacità, sia come progetti software a se stanti, ciascuno dei quali in grado di operare ad uno strato più "generico" con specifiche finalità.

La licenza di distribuzione open source scelta dall'Amministrazione è la **Affero General Public License (AGPL) v3.** 

Per ciascun modulo descritto di seguito, vengono indicate le funzionalità principali e l'architettura del modulo stesso, il flusso di esecuzione, le dipendenze, le modalità di installazione e di utilizzo così come suggerimenti per gli sviluppatori che dovessero usare il codice liberato per implementarlo in proprie applicazioni.

## [FCA](https://github.com/3dinformatica/docway-fca/blob/master/README.md)/[FCS](https://github.com/3dinformatica/docway-fcs/blob/master/README.md)

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


## [Console Audit](https://github.com/3dinformatica/auditConsole/blob/master/README.md)

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

## [MSA](https://github.com/3dinformatica/msa/blob/master/README.md)

MSA (Mail Storage Agent) è un servizio Java multi-processo che si occupa delle seguenti operazioni:
* archiviazione delle email PEC e non (le mail vengono trasformate e salvate in documenti in DocWay XML);
* scambio di documenti tra sistemi DocWay XML differenti mediante la posta elettronica certificata (interoperabilità);
* Completa gestione del processo di interfacciamento con lo SdI per le fatture elettroniche.
MSA lavora esaminando periodicamente delle caselle di posta (certificate o meno) e dispone di una sua specifica console di amministrazione e controllo.

...

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
tickets@3di.it
