# SOCIAL 4 EVENTS

**UNIVERSITÀ POLITECNICA DELLE MARCHE**
Dipartimento di Ingegnerie e Informazione
Corso di Laurea Triennale in Ingegneria Informatica e dell’automazione
Corso di Programmazione Mobile

Prof. Emanuele Storti			
Relazione di Daniele Benfatto

Anno accademico 2022/2023

Introduzione
 
Che cosa?
La presente relazione descrive lo sviluppo di un applicativo che consente agli utenti loggati di creare e partecipare ad eventi, escludendo l'accesso ai non registrati. Una volta scaricata l'applicazione, gli utenti possono registrarsi o accedere inserendo le proprie credenziali. La home dell'applicazione presenta una mappa che visualizza tutti gli eventi disponibili. Gli utenti possono effettuare una ricerca degli eventi in base alla posizione sulla mappa e partecipare a quelli che preferiscono. L'applicazione presenta inoltre un menù con diverse opzioni, tra cui la possibilità di visualizzare il proprio profilo utente, cercare altri utenti in base al nome e tornare alla home. Il profilo utente include una serie di dati personali, come l'Id utente, il nome, il cognome, l'età, la città di appartenenza, il CAP, l'immagine del profilo, il numero di eventi creati e la data di nascita. L'evento, invece, include il nome, la descrizione, l'ora e la data di inizio e fine, la durata, la locazione, l'immagine dell'evento, il numero massimo di partecipanti, il nome dell'organizzatore e la lista dei partecipanti. 

Come?
L’applicazione è stata realizzata in due versioni: una in Kotlin insieme alla piattaforma Android SDK, disponibile solo per smartphone Android e una in flutter, disponibile sia per Android che per Ios. Per realizzare l’app nativa Android in Kotlin ho utilizzato Android Studio, l'ambiente di sviluppo integrato ufficiale per lo sviluppo di app Android. Ho utilizzato le API di Google Maps per implementare la mappa interattiva e la funzionalità di ricerca degli eventi. Inoltre, ho utilizzato il database Nosql Firebase per gestire i dati degli utenti e degli eventi.
Per realizzare l'applicazione cross-platform, invece, ho utilizzato il linguaggio di programmazione Dart supportato dal framework Flutter. Flutter è un framework open source per lo sviluppo di app mobile (e non solo) che permette di creare app native per Android e iOS utilizzando lo stesso codice. Ho utilizzato Visual Studio Code come IDE per lo sviluppo di Flutter. Ho utilizzato il plugin di Flutter per Google Maps per integrare la mappa interattiva e la funzionalità di ricerca degli eventi. 
In entrambi i casi, si ha un'architettura pulita e modulare per organizzare il codice dell'applicazione, con una separazione chiara tra la logica di business e l'interfaccia utente (MVVM in android e BLoC in flutter). È stato annesso il versionamento del codice con Git per una gestione più sicura del codice. 

Perché?
L’idea nasce dalla necessità di avere una piattaforma intuitiva e facile da usare per la creazione e la gestione di eventi. Gli utenti, nei giorni liberi, possono facilmente visualizzare gli eventi sulla mappa e partecipare a quelli che più li interessano. Social4Events aiuta i giovani a “trovare qualcosa da fare” il fine settimana o comunque nei giorni liberi, creando network sociali tra utenti che prima solo con il passa-parola classico (strumento sociale che ancora oggi nel 2023 viene utilizzato per la formazione di feste a libero invito), non potevano in alcun modo formarsi. Inoltre, grazie alle funzionalità di ricerca degli eventi, gli utenti possono trovare facilmente eventi vicino alla loro posizione geografica. Infine, l'applicazione offre la possibilità di creare un profilo utente personalizzato, con cui gli utenti possono condividere informazioni su di loro e connettersi con altri utenti che condividono gli stessi interessi. In sintesi, l'applicazione offre una soluzione innovativa e completa per la creazione e la partecipazione ad eventi, fornendo agli utenti una piattaforma sicura, intuitiva e personalizzabile.


