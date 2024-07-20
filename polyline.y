%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// numero di coordinate di un punto
#define NUM_COORDINATES 2

// struttura dati per la gestione di un nodo
typedef struct Node {
    char* value; // valore del nodo
    struct Node** children; // figli del nodo
    int total; // numero totale di figli del nodo
    int size; // numero massimo di figli del nodo
    int depth; // profondità del nodo
    int same_depth; // flag per calcolare la giusta profondità dei nodi prima della costruzione dell'AST
    int coordinates[NUM_COORDINATES]; // coordinate del nodo (se rappresenta un punto)
} Node;

extern FILE* yyin;

void yyerror(const char* s);
int yylex();

// funzione per creare un nodo di un AST
Node* create_node(char* value);

// funzione per aggiungere un figlio a un nodo di un AST
void add_child(Node* parent, Node* child, int same_depth);

// funzione per calcolare la giusta profondità dei nodi di un AST
void modify_depth(Node* node);
void adjust_depth(Node* node, int depth_adjustment);
void set_depth(Node* node);

// funzione per stampare ricorsivamente un AST
void print_ast(Node* node);
%}

%union {
    int integer;
    char* string;
    void* pointer;
}

%token <string> LBRACK RBRACK
%token <string> PLUS ASSIGN SEMICOLON
%token <string> ISOPEN CLOSE
%token <string> TERMINATE
%token <integer> INTEGER
%token <string> SYMMETRY
%token <string> VARIABLE

%type <pointer> polyline points end point

%%

program     : program statement { }
            | { }
            ;

statement   : polyline SEMICOLON {
                set_depth($1); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast($1); // stampa dell'AST
                printf("\n");
            }
            | ISOPEN polyline SEMICOLON {
                Node* node = create_node("isOpen"); // creazione del nodo isOpen
                add_child(node, $2, 0); // aggiunta del nodo polilinea come figlio del nodo isOpen
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | CLOSE polyline SEMICOLON {
                Node* node = create_node("Close"); // creazione del nodo Close
                add_child(node, $2, 0); // aggiunta del nodo polilinea come figlio del nodo Close
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | VARIABLE ASSIGN polyline SEMICOLON {
                Node* node = create_node($1); // creazione del nodo variabile
                Node* assign_node = create_node("="); // creazione del nodo =
                add_child(assign_node, $3, 0); // aggiunta del nodo polilinea come figlio del nodo =
                add_child(node, assign_node, 0); // aggiunta del nodo = come figlio del nodo variabile
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | VARIABLE ASSIGN CLOSE polyline SEMICOLON {
                Node* node = create_node($1); // creazione del nodo variabile
                Node* assign_node = create_node("="); // creazione del nodo =
                Node* close_node = create_node("Close"); // creazione del nodo Close
                add_child(close_node, $4, 0); // aggiunta del nodo polilinea come figlio del nodo Close
                add_child(assign_node, close_node, 0); // aggiunta del nodo Close come figlio del nodo =
                add_child(node, assign_node, 0); // aggiunta del nodo = come figlio del nodo variabile
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | VARIABLE ASSIGN VARIABLE SEMICOLON {
                Node* node = create_node($1); // creazione del primo nodo variabile
                Node* assign_node = create_node("="); // creazione del nodo =
                Node* var_node = create_node($3); // creazione del secondo nodo variabile
                add_child(assign_node, var_node, 0); // aggiunta del secondo nodo variabile come figlio del nodo =
                add_child(node, assign_node, 0); // aggiunta del nodo = come figlio del primo nodo variabile
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | VARIABLE SEMICOLON {
                Node* node = create_node($1); // creazione del nodo variabile
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | ISOPEN VARIABLE SEMICOLON {
                Node* node = create_node("isOpen"); // creazione del nodo isOpen
                Node* var_node = create_node($2); // creazione del nodo variabile
                add_child(node, var_node, 0); // aggiunta del nodo variabile come figlio del nodo isOpen
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | CLOSE VARIABLE SEMICOLON {
                Node* node = create_node("Close"); // creazione del nodo Close
                Node* var_node = create_node($2); // creazione del nodo variabile
                add_child(node, var_node, 0); // aggiunta del nodo variabile come figlio del nodo Close
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | VARIABLE ASSIGN CLOSE VARIABLE SEMICOLON {
                Node* node = create_node($1); // creazione del primo nodo variabile
                Node* assign_node = create_node("="); // creazione del nodo =
                Node* close_node = create_node("Close"); // creazione del nodo Close
                Node* var_node = create_node($4); // creazione del secondo nodo variabile
                add_child(close_node, var_node, 0); // aggiunta del secondo nodo variabile come figlio del nodo Close
                add_child(assign_node, close_node, 0); // aggiunta del nodo Close come figlio del nodo =
                add_child(node, assign_node, 0); // aggiunta del nodo = come figlio del primo nodo variabile
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | VARIABLE ASSIGN VARIABLE PLUS VARIABLE SEMICOLON {
                Node* node = create_node($1); // creazione del primo nodo variabile
                Node* assign_node = create_node("="); // creazione del nodo =
                Node* plus_node = create_node("+"); // creazione del nodo +
                Node* var1_node = create_node($3); // creazione del secondo nodo variabile
                Node* var2_node = create_node($5); // creazione del terzo nodo variabile
                add_child(plus_node, var1_node, 0); // aggiunta del terzo nodo variabile come figlio del nodo +
                add_child(plus_node, var2_node, 0); // aggiunta del secondo nodo variabile come figlio del nodo +
                add_child(assign_node, plus_node, 0); // aggiunta del nodo + come figlio del nodo =
                add_child(node, assign_node, 0); // aggiunta del nodo = come figlio del primo nodo variabile
                set_depth(node); // modifica della profondità dei nodi dell'AST
                printf("Abstract syntax tree:\n");
                print_ast(node); // stampa dell'AST
                printf("\n");
            }
            | TERMINATE SEMICOLON {
                return 0; // terminazione del parser
            }
            ;

polyline    : points {
                $$ = $1;
            }
            | end {
                $$ = $1;
            }
            ;

points      : polyline point {
                add_child($1, $2, 1); // aggiunta del nodo punto come figlio del nodo polilinea
                $$ = $1;
            }
            | polyline SYMMETRY LBRACK polyline RBRACK {
                Node* sym_node = create_node($2); // creazione del nodo simmetria
                add_child(sym_node, $4, 0); // aggiunta del secondo nodo polilinea come figlio del nodo simmetria
                add_child($1, sym_node, 1); // aggiunta del nodo simmetria come figlio del primo nodo polilinea
                $$ = $1;
            }
            ;

end         : point {
                $$ = $1;
            }
            | SYMMETRY LBRACK polyline RBRACK {
                Node* node = create_node($1); // creazione del nodo simmetria
                add_child(node, $3, 0); // aggiunta del nodo polilinea come figlio del nodo simmetria
                $$ = node;
            }
            ;

point       : INTEGER INTEGER {
                Node* node = create_node("point"); // creazione del nodo punto
                node->coordinates[0] = $1; // modifica della coordinata x del nodo punto
                node->coordinates[1] = $2; // modifica della coordinata y del nodo punto
                $$ = node;
            }
            ;

%%

int main(int argc, char **argv) {
    if (argc > 1) { // la lettura dei dati avviene da un file
        printf("Reading from a file (%s)\n\n", argv[1]);
        yyin = fopen(argv[1], "r"); // aggiornamento del flusso di input
    } else { // la lettura dei dati avviene dalla tastiera
        printf("Reading from the keyboard\n\n");
        yyin = stdin; // aggiornamento del flusso di input
    }
    yyparse(); // chiamata del parser
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

Node* create_node(char* value) {
    Node* node = (Node*)malloc(sizeof(Node)); // allocazione dello spazio per il nodo
    node->value = strdup(value); // inizializzazione del valore del nodo
    node->children = (Node**)malloc(10 * sizeof(Node*)); // allocazione dello spazio per i figli del nodo
    node->total = 0; // inizializzazione del numero totale di figli del nodo
    node->size = 10; // inizializzazione del numero massimo di figli del nodo
    node->depth = 0; // inizializzazione della profondità del nodo
    node->same_depth = 0; // inizializzazione del flag per calcolare la giusta profondità dei nodi
    return node;
}

void add_child(Node* parent, Node* child, int same_depth) {
    if (parent->total >= parent->size) { // il numero totale di figli del nodo è maggiore o uguale al numero massimo di figli del nodo
        parent->size += 10; // incremento del numero massimo di figli del nodo
        parent->children = (Node**)realloc(parent->children, parent->size * sizeof(Node*)); // riallocazione dello spazio per i figli del nodo
    }
    child->same_depth = same_depth; // modifica del flag per calcolare la giusta profondità dei nodi
    parent->children[parent->total++] = child; // aggiunta del figlio
}

void print_ast(Node* node) {
    if (strcmp(node->value, "point") == 0) { // il nodo rappresenta un punto
        for (int i = 0; i < NUM_COORDINATES; i++) { // scorrimento delle coordinate del punto
            for (int j = 0; j < node->depth; j++) { // scorrimento della profondità del nodo
                printf("----- ");
            }
            printf("%d\n", node->coordinates[i]); // stampa di una coordinata del punto
        }
    } else { // il nodo non rappresenta un punto
        for (int i = 0; i < node->depth; i++) { // scorrimento della profondità del nodo
            printf("----- ");
        }
        printf("%s\n", node->value); // stampa del valore del nodo
    }
    for (int i = 0; i < node->total; i++) { // scorrimento dei figli del nodo
        print_ast(node->children[i]); // stampa ricorsiva dell'AST
    }
}

void modify_depth(Node* node) {
    for (int i = 0; i < node->total; i++) { // scorrimento dei figli del nodo
        node->children[i]->depth = node->depth + 1; // modifica della profondità di un figlio del nodo rispetto alla profondità del padre
        modify_depth(node->children[i]); // modifica ricorsiva della profondità dei nodi
    }
}

void adjust_depth(Node* node, int depth_adjustment) {
    int depth_adjustment_used = 0;
    for (int i = 0; i < node->total; i++) { // scorrimento dei figli del nodo
        if (node->children[i]->same_depth == 1) { // il flag per calcolare la giusta profondità dei nodi vale 1
            node->children[i]->depth = node->depth; // modifica della profondità di un figlio del nodo rispetto alla profondità del padre
        }
        if ((strcmp(node->value, "simx") == 0 || strcmp(node->value, "simy") == 0 || strcmp(node->value, "sim0") == 0) &&
                node->same_depth == 1) { // il nodo è un nodo simmetria e il flag per calcolare la giusta profondità dei nodi vale 1
            node->children[i]->depth -= depth_adjustment; // modifica della profondità di un figlio del nodo rispetto all'annidamento dell simmetrie
            depth_adjustment_used = 1;
        }
    }
    if (depth_adjustment_used)
        depth_adjustment++;
    for (int i = 0; i < node->total; i++) { // scorrimento dei figli del nodo
        adjust_depth(node->children[i], depth_adjustment); // modifica ricorsiva della profondità dei nodi
    }
}

void set_depth(Node* node) {
    // calcolo della giusta profondità dei nodi di un AST
    modify_depth(node);
    adjust_depth(node, 1);
}
