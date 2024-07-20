# Parser per la gestione di polilinee (AST)

## Descrizione

Il progetto consiste in un parser per la traduzione in un abstract syntax tree (AST) di un linguaggio che permette la gestione di polilinee, utilizzando Lex e Yacc. Una polilinea è una sequenza di segmenti lineari contigui e viene definita come una successione di punti nel piano. Se il punto iniziale e quello finale coincidono, si parla di polilinea chiusa. Diversamente, se non coincidono, si parla di polilinea aperta.

Il linguaggio supporta l'uso di simmetrie rispetto all'origine degli assi (`sim0`), rispetto all'asse x (`simx`) e rispetto all'asse y (`simy`) per definire i punti di una polilinea. È possibile anche utilizzare variabili per memorizzare e richiamare polilinee.

Le operazioni supportate includono la chiusura di una polilinea (`Close`), la verifica se una polilinea è aperta o chiusa (`isOpen`) e la concatenazione di due polilinee tramite un segmento che collega l'ultimo punto della prima polilinea al primo punto della seconda (`+`).

## File

Il progetto è organizzato nei seguenti file:

- `polyline.l` contiene le specifiche per Lex e definisce i token del linguaggio. Inoltre, gestisce il riconoscimento degli operatori, delle parole chiave, dei numeri interi e delle variabili, trasformandoli in token riconoscibili da Yacc.
- `polyline.y` contiene le specifiche per Yacc e definisce la grammatica del linguaggio. Inoltre, gestisce la sintassi del linguaggio, costruendo l'AST delle istruzioni fornite in input.
- `Makefile` semplifica il processo di compilazione del progetto.
- `README.md` fornisce una descrizione dettagliata del progetto.

## Compilazione ed esecuzione

Per compilare il progetto, utilizzando `Makefile`:

```
$ make
```

Per eseguire il programma compilato:

```
$ ./polyline [file]
```

Per terminare il programma:

```
$ (exit|e|quit|q);
```

Per rimuovere i file generati (compreso l'eseguibile):

```
$ make clean
```

## Utilizzo

Per utilizzare il parser, si compilano i file `polyline.l` e `polyline.y`, utilizzando `Makefile`, e si esegue il programma risultante. Il parser legge le istruzioni dalla tastiera o da un file, le analizza sintatticamente e costruisce il corrispondente AST.

## Esempi

### Definizione di un punto

Input:

```
1 -2;
```

Output:

```
Abstract syntax tree:
1
-2
```

### Definizione di una polilinea

Input:

```
1 -2 -3 4 5 6;
```

Output:

```
Abstract syntax tree:
1
-2
-3
4
5
6
```

### Definizione di una polilinea con simmetrie

Input:

```
simx(1 2 sim0(3 4)) 5 6;
```

Output:

```
Abstract syntax tree:
simx
----- 1
----- 2
----- sim0
----- ----- 3
----- ----- 4
5
6
```

### Verifica se una polilinea è aperta

Input:

```
isOpen simx(1 2 sim0(3 4)) 5 6;
```

Output:

```
Abstract syntax tree:
isOpen
----- simx
----- ----- 1
----- ----- 2
----- ----- sim0
----- ----- ----- 3
----- ----- ----- 4
----- 5
----- 6
```

### Chiusura di una polilinea

Input:

```
Close simx(1 2 sim0(3 4)) 5 6;
```

Output:

```
Abstract syntax tree:
Close
----- simx
----- ----- 1
----- ----- 2
----- ----- sim0
----- ----- ----- 3
----- ----- ----- 4
----- 5
----- 6
```

### Utilizzo di variabili per la memorizzazione di polilinee

Input:

```
P1 = simx(1 2 sim0(3 4)) 5 6;
```

Output:

```
Abstract syntax tree:
P1
----- =
----- ----- simx
----- ----- ----- 1
----- ----- ----- 2
----- ----- ----- sim0
----- ----- ----- ----- 3
----- ----- ----- ----- 4
----- ----- 5
----- ----- 6
```

### Utilizzo di variabili per la memorizzazione di polilinee (chiusura)

Input:

```
P2 = Close P1;
```

Output:

```
Abstract syntax tree:
P2
----- =
----- ----- Close
----- ----- ----- P1
```

### Utilizzo di variabili per la memorizzazione di polilinee (concatenazione)

Input:

```
P3 = P1 + P2;
```

Output:

```
Abstract syntax tree:
P3
----- =
----- ----- +
----- ----- ----- P1
----- ----- ----- P2
```

## Strutture dati

Il programma include una struttura dati per la gestione dei nodi dell'AST (Node). Questa struttura contiene:

- Il valore di un nodo.
- I figli di un nodo.
- Il numero totale e il numero massimo di figli di un nodo.
- La profondità di un nodo.
- Un flag per calcolare la giusta profondità dei nodi prima della costruzione dell'AST.
- Le coordinate di un nodo (se rappresenta un punto).

## Funzioni

Il programma include le seguenti funzioni per la gestione dei nodi dell'AST:

- `create_node` crea e inizializza un nuovo nodo dell'AST con il valore specificato e una lista vuota di figli.
- `add_child` aggiunge il nodo specificato come figlio del nodo padre specificato, gestendo, se necessario, l'espansione della lista dei figli.
- `modify_depth` aggiorna la profondità dei nodi dell'AST, assegnando ai figli la profondità del padre incrementata di 1.
- `adjust_depth` aggiusta la profondità dei nodi dell'AST in base al valore di un flag.
- `set_depth` modifica correttamente la profondità dei nodi dell'AST.
- `print_ast` stampa ricorsivamente l'AST a partire dal nodo specificato.

## Note

Una nota aggiuntiva:

- I comandi sono case-sensitive e devono essere scritti correttamente.
