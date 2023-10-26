%{
/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Definicao dos atributos dos atomos operadores */

#define 	LT 			1
#define 	LE 			2
#define	    GT			3
#define	    GE			4
#define	    EQ			5
#define	    NE			6
#define		PLUS		1
#define		MINUS		2 
#define		TIMES		1
#define		DIV			2 	
#define		PERC		3

/*   Definicao dos tipos de identificadores   */

#define 	IDGLOB		1
#define 	IDVAR		2
#define		IDFUNC		3
#define		IDPROC		4
#define		IDPROG		5

/*  Definicao dos tipos de variaveis   */

#define 	NAOVAR		0
#define 	INTEIRO		1
#define 	LOGICO		2
#define 	REAL		3
#define 	CARACTERE	4

/* Definicao de constantes para os operadores de quadruplas */

#define		OPOR			1
#define		OPAND	 		2
#define 	OPLT	 		3
#define 	OPLE	 		4
#define		OPGT		    5
#define		OPGE			6
#define		OPEQ			7
#define		OPNE			8
#define		OPMAIS		    9
#define		OPMENOS		    10
#define		OPMULTIP		11
#define		OPDIV			12
#define		OPRESTO		    13
#define		OPMENUN		    14
#define		OPNOT			15
#define		OPATRIB		    16
#define		OPENMOD		    17
#define		NOP			    18
#define		OPJUMP		    19
#define		OPJF			20
#define		OPJT			21
#define		PARAM			22
#define		OPREAD		    23
#define		OPWRITE		    24
#define		OPIND			25
#define		OPINDEX			26
#define		CONTAPONT		27
#define		ATRIBPONT		28
#define		OPCALL			29
#define		OPRETURN		30
#define		OPEXIT			31

/* Definicao de constantes para os tipos de operandos de quadruplas */

#define		IDLEOPND		0
#define		VAROPND		    1
#define		INTOPND		    2
#define		REALOPND		3
#define		CHAROPND		4
#define		LOGICOPND	    5
#define		CADOPND		    6
#define		ROTOPND		    7
#define		MODOPND		    8

/*   Definicao de outras constantes   */

#define		NCLASSHASH	23
#define		VERDADE		1
#define		FALSO		0
#define 	MAXDIMS		10

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[6] = {" ", "IDGLOB", "IDVAR", "IDFUNC", "IDPROC", "IDPROG"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[5] = {"NAOVAR", "INTEIRO", "LOGICO", "REAL", "CARACTERE"};

/* Strings para operadores de quadruplas */

char *nomeoperquad[32] = {"",
	"OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
	"MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
	"OPENMOD", "NOP", "JUMP", "JF", "JT", "PARAM", "READ", 
	"WRITE", "IND", "INDEX", "CONTAPONT", "ATRIBPONT", "CALL", 
	"RETURN", "EXIT"
};

/*
	Strings para tipos de operandos de quadruplas
 */

char *nometipoopndquad[9] = {"IDLE",
	"VAR", "INT", "REAL", "CARAC", "LOGIC", "CADEIA", "ROTULO", "MODULO"
};

/* Lista de expressoes para os argumentos das funcoes e procedimentos */

typedef struct pontexprtipo pontexprtipo;
typedef pontexprtipo * listexprtipo;
struct pontexprtipo {
	int tipo;
	pontexprtipo *prox;
};

typedef struct infolistexpr infolistexpr;
struct infolistexpr { 
	listexprtipo listtipo;  
	int nargs; 
};

/*    Declaracoes para a tabela de simbolos     */

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
struct celsimb {
	char *cadeia;
	int tid, tvar, ndims, dims[MAXDIMS + 1];
	char inic, ref, array, tempindex, param;
	int *valint;
	float *valfloat;
  	char *valchar, *vallogic;
	simbolo escopo, prox;
	infolistexpr infofuncproc;
};

/*  Variaveis globais para a tabela de simbolos e analise semantica */

simbolo tabsimb[NCLASSHASH];
simbolo simb;
int tipocorrente;
simbolo escopo;
simbolo global;
char * globalID;
infolistexpr infolexpr;

/*
	Prototipos das funcoes para a tabela de simbolos e analise semantica
 */

void InicTabSimb (void);
void ImprimeTabSimb (void);
simbolo InsereSimb (char *, int, int, simbolo);
int hash (char *);
simbolo ProcuraSimb (char *, simbolo);
listexprtipo InicListaTipo (int);
listexprtipo AdicElemListaTipo (listexprtipo, int);
void ChecArgumentos (listexprtipo, listexprtipo);
void DeclaracaoRepetida (char *);
void TipoInadequado (char *);
void NaoDeclarado (char *);
void VerificaInicRef (void);
void Incompatibilidade (char *);
void NaoInicializado (char *);
void NaoReferenciado (char *); 
void Esperado (char *);
void NaoEsperado (char *);

int tab = 0;
void tabular (void);
char tratachar (char *);
void tratacadeia (char *);

/* Declaracoes para a estrutura do codigo intermediario */

typedef union atribopnd atribopnd;
typedef struct operando operando;
typedef struct celquad celquad;
typedef celquad *quadrupla;
typedef struct celmodhead celmodhead;
typedef celmodhead *modhead;

/*  Listas de simbolos  */

typedef struct elemlistsimb elemlistsimb;
typedef elemlistsimb *pontelemlistsimb;
typedef elemlistsimb *listsimb;
struct elemlistsimb {
	simbolo simb; 
	pontelemlistsimb prox;
};

union atribopnd {
	simbolo simb; int valint; float valfloat;
	char valchar; char vallogic; char *valcad;
	quadrupla rotulo; modhead modulo;
};

struct operando {
	int tipo; atribopnd atr;
};

struct celquad {
	int num, oper; operando opnd1, opnd2, result;
	quadrupla prox;
};

struct celmodhead {
	simbolo modname; modhead prox;
	int modtip;
	quadrupla listquad;
	listsimb listparam;
};

/* Variaveis globais para o codigo intermediario */

quadrupla quadcorrente, quadaux, quadaux2, quadindex;
modhead codintermed, modcorrente, modmain, modaux;
int oper, numquadcorrente;
operando opnd1, opnd2, result, opndaux;
int numtemp;
const operando opndidle = {IDLEOPND, 0};

/* Prototipos das funcoes para o codigo intermediario */

void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
void ImprimeQuadruplas (void);
quadrupla GeraQuadrupla (int, operando, operando, operando);
simbolo NovaTemp (int);
void RenumQuadruplas (quadrupla, quadrupla);
modhead ProcuraModhead (simbolo);
simbolo ProcuraEscopo (quadrupla);

/* Declaracoes para atributos das expressoes e variaveis */

typedef struct infoexpressao infoexpressao;
struct infoexpressao {
	int tipo;
	operando opnd;
};

typedef struct infovariavel infovariavel;
struct infovariavel {
	simbolo simb;
	operando opnd;
};

/* Prototipos das funcoes para o interpretador */

void InterpCodIntermed (void);
void AlocaVariaveis (simbolo);
listsimb InicListaSimb (simbolo);
void AdicElemListaSimb (listsimb, simbolo); 
void ExecQuadOr (quadrupla);
void ExecQuadAnd (quadrupla);
void ExecQuadLT (quadrupla);
void ExecQuadLE (quadrupla);
void ExecQuadGT (quadrupla);
void ExecQuadGE (quadrupla);
void ExecQuadEQ (quadrupla);
void ExecQuadNE (quadrupla);
void ExecQuadMais (quadrupla);
void ExecQuadMenos (quadrupla);
void ExecQuadMult (quadrupla);
char ExecQuadDiv (quadrupla);
char ExecQuadResto (quadrupla);
void ExecQuadMenun (quadrupla);
void ExecQuadNot (quadrupla);
void ExecQuadAtrib (quadrupla);
void ExecQuadRead (quadrupla);
void ExecQuadWrite (quadrupla);
void ExecQuadInd (quadrupla);
char ExecQuadIndex (quadrupla);
void ExecQuadContapont (quadrupla);
void ExecQuadReturn (quadrupla);
void ExecQuadCall (quadrupla);

/*	Declaracoes para pilhas de operandos  */

typedef struct nohopnd nohopnd;
struct nohopnd {
	operando opnd;
	nohopnd *prox;
};
typedef nohopnd *pilhaoperando;
pilhaoperando pilhaopnd, pilhaind, pilharet;

/*  Prototipos das funcoes para pilhas de operandos  */

void EmpilharOpnd (operando, pilhaoperando *);
void DesempilharOpnd (pilhaoperando *);
operando TopoOpnd (pilhaoperando);
void InicPilhaOpnd (pilhaoperando *);
char VaziaOpnd (pilhaoperando);

/*	Declaracoes para pilhas de quadruplas */

typedef struct nohquad nohquad;
struct nohquad {
	quadrupla quad;
	nohquad *prox;
};
typedef nohquad *pilhaquadrupla;
pilhaquadrupla pilhaquad;

/*  Prototipos das funcoes para pilhas de quadruplas  */

void EmpilharQuad (quadrupla, pilhaquadrupla *);
void DesempilharQuad (pilhaquadrupla *);
quadrupla TopoQuad (pilhaquadrupla);
void InicPilhaQuad (pilhaquadrupla *);
char VaziaQuad (pilhaquadrupla);

/* Variaveis globais para o interpretador */

FILE *finput;

%}

/* Definicao do tipo de yylval e dos atributos dos nao terminais */

%union {
	char string[50];
	int atr, valor;
	float valreal;
	char carac;
	simbolo simb;
	infoexpressao infoexpr;
	infovariavel infovar;
	int tipoexpr, nsubscr, nargs;
	infolistexpr  infolexpr;
	quadrupla quad;
}

/* Declaracao dos atributos dos tokens e dos nao-terminais */

%type		<infovar>		Variable   FuncCall
%type 	    <infoexpr> 	    Expression  AuxExpr1  AuxExpr2
                            AuxExpr3   AuxExpr4   Term   Factor   WriteElem
%type   	<nsubscr>       SubscrList
%type		<nargs>			ReadList   WriteList
%type		<infolexpr>   	ExprList
%token		CALL 		
%token 		CHAR    	
%token	    DO			
%token		ELSE		
%token		FALSE		
%token		FLOAT		
%token		FOR			
%token		FUNCTION	
%token		GLOBAL				
%token		IF				
%token		INIT			
%token		INT			
%token		LOCAL		
%token		LOGIC		
%token		MAIN		
%token		NEW			
%token		PROCEDURE	 	
%token		PROGRAM		
%token		READ		
%token		REPEAT		
%token		RETURN		
%token		STATEMENTS	
%token		THEN		
%token		TRUE		
%token		WHILE		
%token		WRITE		
%token	    <string>	ID			
%token	    <valor>		INTCT		
%token		<string>	CHARCT		
%token		<valreal>	FLOATCT		
%token		<string>	STRING		
%token		OR			
%token		AND			
%token		NOT			
%token		<atr>		RELOP		
%token		<atr>		ADOP		
%token		<atr>		MULTOP		
%token		NEG			
%token		OPPAR		
%token		CLPAR		
%token		OPBRAK		
%token		CLBRAK		
%token		OPBRACE		
%token		CLBRACE		
%token		OPTRIP		
%token		CLTRIP		
%token		SCOLON		
%token		COMMA		
%token		ASSIGN		
%token		<carac>		INVAL		
%%
/* Producoes da gramatica:

	Os terminais sao escritos e, depois de alguns,
	para alguma estetica, ha mudanca de linha       */

Prog			:	{
						InicTabSimb ();
						InicCodIntermed ();
						numtemp = 0;
						globalID = (char*) malloc (10 * sizeof(char));
						strcpy (globalID, "##global");
						global = InsereSimb (globalID, IDGLOB, NAOVAR, NULL);
						escopo = global;
					}
					PROGRAM  ID 
					{
						printf("program %s ", $3); 
						simb = InsereSimb ($3, IDPROG, NAOVAR, global);
						InicCodIntermMod (simb);
					}
					OPTRIP {printf ("{{{\n\n");}  GlobDecls  ModList  MainMod  CLTRIP
					{
						printf ("}}}\n\n"); 
						modcorrente = codintermed->prox;
						opnd1.tipo = MODOPND;
						opnd1.atr.modulo = modcorrente;
						quadcorrente = modcorrente->listquad;
						quadcorrente->prox = NULL;
						numquadcorrente = 0;
						quadcorrente->num = numquadcorrente;
						GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
						opnd1.tipo = MODOPND;
						opnd1.atr.modulo = modmain;
						GeraQuadrupla (OPCALL, opnd1, opndidle, opndidle);
						GeraQuadrupla (OPEXIT, opndidle, opndidle, opndidle);
						VerificaInicRef (); 
						//ImprimeTabSimb ();
						//ImprimeQuadruplas ();
						InterpCodIntermed ();
					}
				;
GlobDecls 		:	 
				|  	GLOBAL OPBRACE 
					{printf ("global \{\n"); tab++;} 
					DeclList  
					CLBRACE 
					{tab--; tabular (); printf ("}\n\n");}

				;
DeclList		:	Declaration  
				|   DeclList  Declaration
				;
Declaration 	:	{tabular ();} Type  ElemList  SCOLON {printf(";\n");} 
				;
Type			: 	INT {printf("int "); tipocorrente = INTEIRO;}
				| 	FLOAT {printf("float "); tipocorrente = REAL;}
				|  	CHAR  {printf("char "); tipocorrente = CARACTERE;}
				|	LOGIC  {printf("logic "); tipocorrente = LOGICO;}
				;
ElemList    	:	Elem  
				|	ElemList  COMMA {printf(", ");} Elem
				;
Elem        	:	ID  
					{
						printf ("%s", $1);
						if  (ProcuraSimb ($1, escopo)  !=  NULL)
							DeclaracaoRepetida ($1);
						else {
							simb = InsereSimb ($1,  IDVAR,  tipocorrente, escopo);
							simb->array = FALSO;
						}
					}
				|	ID OPBRAK
					{
						printf ("%s [", $1);
						if  (ProcuraSimb ($1, escopo)  !=  NULL)
							DeclaracaoRepetida ($1);
						else {
							simb = InsereSimb ($1,  IDVAR,  tipocorrente, escopo);
							simb->array = VERDADE;
							simb->ndims = 0;
						}
					}
					DimList  
					CLBRAK {printf("]");}
				;
DimList	    	: 	INTCT  
					{
						printf ("%d", $1);
						if ($1 <= 0) Esperado ("Valor inteiro positivo");
						simb->ndims++; simb->dims[simb->ndims] = $1;

					}
				|	DimList  COMMA INTCT 
					{
						printf (", %d", $3);
						if ($3 <= 0) Esperado ("Valor inteiro positivo");
						simb->ndims++; simb->dims[simb->ndims] = $3;

					}
				;
ModList	    	:	  
				|  	ModList  Module
				;
Module      	:	ModHeader  ModBody 
				;
ModHeader   	:  	FuncHeader  
				|	ProcHeader
				;
FuncHeader		:   Type FUNCTION  ID OPPAR CLPAR   
					{
						printf("function %s ()\n", $3);
						if (ProcuraSimb($3, global) != NULL)
							DeclaracaoRepetida ($3);
						else {
							escopo = InsereSimb($3, IDFUNC, tipocorrente, global);
							InicCodIntermMod(escopo);
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = modcorrente;
							GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
						}
					}
				|  	Type FUNCTION  ID  OPPAR 
					{
						printf("function %s (", $3);
						if (ProcuraSimb($3, global) != NULL)
							DeclaracaoRepetida ($3);
						else {
							escopo = InsereSimb($3, IDFUNC, tipocorrente, global);
							InicCodIntermMod(escopo);
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = modcorrente;
							GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
						}
					}				
					ParamList  CLPAR {printf(")\n");}
				;
ProcHeader		:   PROCEDURE  ID  OPPAR 
					{
						if (ProcuraSimb($2, global) != NULL)
							DeclaracaoRepetida ($2);
						else {
							escopo = InsereSimb($2, IDPROC, NAOVAR, global);
							InicCodIntermMod(escopo);
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = modcorrente;
							GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
						}
						printf("procedure %s ()\n", $2);
						
					}
					CLPAR 
				|  	PROCEDURE  ID OPPAR 
					{
						if (ProcuraSimb($2, global) != NULL)
							DeclaracaoRepetida ($2);
						else {
							escopo = InsereSimb($2, IDPROC, NAOVAR, global);
							InicCodIntermMod(escopo);
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = modcorrente;
							GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
						}
						printf("procedure %s (", $2);
					}				
					ParamList  CLPAR {printf(")\n");}
				;
ParamList   	:  	Parameter  
				|	ParamList  COMMA {printf(", ");} Parameter
				;
Parameter   	:  	Type  ID 
					{
						escopo->infofuncproc.nargs++;
						escopo->infofuncproc.listtipo = 
						AdicElemListaTipo(escopo->infofuncproc.listtipo, tipocorrente);
						simb = InsereSimb($2, IDVAR, tipocorrente, escopo);
						if (escopo->infofuncproc.nargs == 1)
							modcorrente->listparam = InicListaSimb(simb);
						else
							AdicElemListaSimb(modcorrente->listparam, simb);
						simb->inic = VERDADE;
						simb->ref = VERDADE;
						simb->param = VERDADE;
						printf ("%s", $2);
					} 
				;
ModBody     	:	LocDecls  Stats
					{
						if (quadcorrente->oper != OPRETURN)
							GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
					}
				;
LocDecls 		:	
				| 	LOCAL {printf("local ");} 
					OPBRACE {printf ("\{\n"); tab++;} 
					DeclList  
					CLBRACE 
					{tab--; tabular (); printf ("}\n");}
				;
MainMod     	:  	MAIN 
					{
						printf("main \n"); 
						escopo = InsereSimb("main", IDPROC, NAOVAR, global);
						InicCodIntermMod(escopo);
						opnd1.tipo = MODOPND;
						opnd1.atr.modulo = modcorrente;
						GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
						modmain = modcorrente;
					} 
					ModBody
				;
Stats       	:  	STATEMENTS {printf("statements ");}  
					CompStat 
					{printf ("\n\n");}
				;
CompStat		:  	OPBRACE {printf ("\{"); tab++;}
					StatList  
					CLBRACE 
					{tab--; printf ("\n"); tabular (); printf ("}");}
				;
StatList		:	
				| 	StatList  Statement
				;
Statement   	:  	CompStat  
				|	{printf("\n"); tabular ();} IfStat  
				|	{printf("\n"); tabular ();} WhileStat  
				|	{printf("\n"); tabular ();} RepeatStat
            	|   {printf("\n"); tabular ();} ForStat  
				| 	{printf("\n"); tabular ();} ReadStat  
				|	{printf("\n"); tabular ();} WriteStat  
				| 	{printf("\n"); tabular ();} AssignStat
            	|   {printf("\n"); tabular ();} CallStat  
				|	{printf("\n"); tabular ();} ReturnStat  
				|  	SCOLON {printf(";\n");}
				;
IfStat			:   IF {printf("if ");} Expression 
					{ 
						if ($3.tipo != LOGICO)
							Incompatibilidade ("Expressao impropria para comando if");
						opndaux.tipo = ROTOPND;
						$<quad>$ = GeraQuadrupla (OPJF, $3.opnd, opndidle, opndaux);
					}
					THEN {printf(" then "); tab++;} Statement 
					{
						tab--;
						$<quad>$ = quadcorrente;
						$<quad>4->result.atr.rotulo =
						GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					} 
					ElseStat
					{
						if ($<quad>8->prox != quadcorrente) {
							quadaux = $<quad>8->prox;
							$<quad>8->prox = quadaux->prox;
							quadaux->prox = $<quad>8->prox->prox;
							$<quad>8->prox->prox = quadaux;
							RenumQuadruplas ($<quad>8, quadcorrente);
						}	
					}
				;
ElseStat		:	
				| 	ELSE 
					{
						printf("\n"); 
						tabular(); 
						printf("else "); 
						tab++;
						opndaux.tipo = ROTOPND;
						$<quad>$ = GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
					} 
					Statement 
					{
						tab--;
						$<quad>2->result.atr.rotulo = 
						GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					}
				;
WhileStat   	:	WHILE 
					{
						printf("while ");
						$<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					} 
					Expression 
					{ 
						if ($3.tipo != LOGICO)
							Incompatibilidade ("Expressao impropria para comando while");
						opndaux.tipo = ROTOPND;
						$<quad>$ = GeraQuadrupla (OPJF, $3.opnd, opndidle, opndaux);
					}
					DO {printf(" do ");} Statement
					{
						$<quad>$ = quadcorrente;
						result.tipo = ROTOPND;
						result.atr.rotulo = $<quad>2;
						GeraQuadrupla (OPJUMP, opndidle, opndidle, result);
						$<quad>4->result.atr.rotulo = 
						GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					}
				;
RepeatStat  	:  	REPEAT 
					{
						printf("repeat ");
						$<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					} 
					Statement  
					WHILE {printf(" while ");} Expression  
					{ 
						if ($6.tipo != LOGICO)
							Incompatibilidade ("Expressao impropria para encerramento de comando repeat");
						opndaux.tipo = ROTOPND;
						opndaux.atr.rotulo = $<quad>2;
						GeraQuadrupla (OPJT, $6.opnd, opndidle, opndaux);
					}
					SCOLON {printf(";");}
				;
ForStat	    	:  	FOR {printf("for ");} Variable 
					{
						if ($3.simb != NULL)
							if ($3.simb->tvar != INTEIRO && $3.simb->tvar != CARACTERE)
								Incompatibilidade ( "Variavel impropria para cabecalho de comando for");
					}
					INIT {printf(" init ");}  Expression  
					{
						if ($3.simb != NULL) { 
							$3.simb->inic = $3.simb->ref = VERDADE;
						}
						if ($7.tipo != INTEIRO && $7.tipo != CARACTERE)
							Incompatibilidade ("Expressao impropria para inicializacao em comando for");
						GeraQuadrupla (OPATRIB, $7.opnd, opndidle, $3.opnd);
						$<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					}
					WHILE {printf(" while ");} Expression 
					{ 
						if ($11.tipo != LOGICO)
							Incompatibilidade ("Expressao impropria para condicao em comando for");
						opndaux.tipo = ROTOPND;
						$<quad>$ = GeraQuadrupla (OPJF, $11.opnd, opndidle, opndaux);
					}					
					NEW 
					{
						printf(" new ");
						$<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					} 
					Expression 
					{
						if ($15.tipo != INTEIRO && $15.tipo != CARACTERE)
							Incompatibilidade ("Expressao impropria para acao em comando for");
						$<quad>$ = GeraQuadrupla (OPATRIB, $15.opnd, opndidle, $3.opnd);
					}					
					DO 
					{$<quad>$ = quadcorrente;}
					{
						printf(" do ");
						$<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
					} 
					Statement 
					{
						quadaux = quadcorrente;
						result.tipo = ROTOPND;
						result.atr.rotulo = $<quad>8;
						quadaux2 = GeraQuadrupla (OPJUMP, opndidle, opndidle, result);
						$<quad>12->result.atr.rotulo = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
						$<quad>12->prox = $<quad>19;
						quadaux->prox = $<quad>14;
						$<quad>18->prox = quadaux2;
						RenumQuadruplas ($<quad>12, quadcorrente);
					}
				;	
ReadStat   		:  	READ OPPAR {printf("read (");} ReadList  
					{
						if ($4 != 0) {
							opnd1.tipo = INTOPND;
							opnd1.atr.valint = $4;
							GeraQuadrupla (OPREAD, opnd1, opndidle, opndidle);
						}
					}
					CLPAR  SCOLON  {printf (") ;");}
				;
ReadList		:  	Variable  
					{
						if  ($1.simb != NULL) {
							$1.simb->inic = $1.simb->ref = VERDADE;
							if ($1.simb->array == VERDADE) {
								opnd1.tipo = VAROPND;
								opnd1.atr.simb = NovaTemp($1.simb->tvar);
								GeraQuadrupla (PARAM, opnd1, opndidle, opndidle);
								opndaux.tipo = INTOPND;
								opndaux.atr.valint = 1;
								GeraQuadrupla (OPREAD, opndaux, opndidle, opndidle);
								GeraQuadrupla (ATRIBPONT, opnd1, opndidle, quadindex->result);
								$$ = 0;
							}
							else {
								$$ = 1;
								GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
							}
						}
					}
				| 	ReadList  COMMA {printf(", ");}  Variable
					{
						if  ($4.simb != NULL) {
							$4.simb->inic = $4.simb->ref = VERDADE;
							if ($4.simb->array == VERDADE) {
								if ($1 != 0) {
									opnd1.tipo = INTOPND;
									opnd1.atr.valint = $1;
									GeraQuadrupla (OPREAD, opnd1, opndidle, opndidle);
								}
								opnd1.tipo = VAROPND;
								opnd1.atr.simb = NovaTemp($4.simb->tvar);
								GeraQuadrupla (PARAM, opnd1, opndidle, opndidle);
								opndaux.tipo = INTOPND;
								opndaux.atr.valint = 1;
								GeraQuadrupla (OPREAD, opndaux, opndidle, opndidle);
								GeraQuadrupla (ATRIBPONT, opnd1, opndidle, quadindex->result);
								$$ = 0;
							}
							else {
								$$ = $1 + 1;
								GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
							}
						}
					}
				;
WriteStat  		:	WRITE  OPPAR  {printf ("write ( ");}  WriteList
					{
						opnd1.tipo = INTOPND;
						opnd1.atr.valint = $4;
						GeraQuadrupla (OPWRITE, opnd1, opndidle, opndidle);
					} 
					CLPAR  SCOLON  {printf (") ;");}
				;
WriteList		:	WriteElem  
					{
						$$ = 1;
						GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
					}
				|  	WriteList  COMMA {printf(", ");} WriteElem
					{
						$$ = $1 + 1;
						GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
					}
				;
WriteElem		:   STRING  
					{
						printf("%s", $1);
						$$.opnd.tipo = CADOPND;
						$$.opnd.atr.valcad = malloc (strlen($1) + 1);
						strcpy ($$.opnd.atr.valcad, $1);
						tratacadeia($$.opnd.atr.valcad);
					}
				|	Expression  
				;
CallStat    	:	CALL  ID  OPPAR  CLPAR  SCOLON 
					{
						printf("call %s ();\n", $2);
						simb = ProcuraSimb ($2, global);
						if (simb == NULL) 
							NaoDeclarado($2);
						else if (simb->tid != IDPROC)
							TipoInadequado($2);
						else if (simb->infofuncproc.nargs != 0)
							Incompatibilidade("Numero de argumentos diferente do numero de parametros");
						if (simb != NULL && simb->tid == IDPROC) {
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = ProcuraModhead(simb);
							opnd2.tipo = INTOPND;
							opnd2.atr.valint = 0;
							GeraQuadrupla (OPCALL, opnd1, opnd2, opndidle);
						}
					}
				|  	CALL  ID  OPPAR  
					{
						printf("call %s (", $2);
						simb = ProcuraSimb ($2, global);
						if (simb == NULL) 
							NaoDeclarado($2);
						else if (simb->tid != IDPROC)
							TipoInadequado($2);
						$<simb>$ = simb;
					} 
					ExprList  CLPAR  SCOLON 
					{
						printf(");");
						simb = $<simb>4;
						if (simb && simb->tid == IDPROC) {
							if (simb->infofuncproc.nargs != $5.nargs)
								Incompatibilidade("Numero de argumentos diferente do numero de parametros");
							ChecArgumentos(simb->infofuncproc.listtipo, $5.listtipo);
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = ProcuraModhead(simb);
							opnd2.tipo = INTOPND;
							opnd2.atr.valint = $5.nargs;
							GeraQuadrupla (OPCALL, opnd1, opnd2, opndidle);
						}						
					} 
				;
ReturnStat  	:	RETURN SCOLON 
					{
						printf("return;");
						if (escopo->tid != IDPROC)
							Esperado ("Escopo procedimento");
						GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
					}  
				|  	RETURN 
					{
						printf("return ");
						if (escopo->tid != IDFUNC)
							Esperado ("Escopo funcao");
					} 
					Expression SCOLON 
					{
						printf(";");
						switch(escopo->tvar) {
							case INTEIRO: case CARACTERE:
								if ($3.tipo != INTEIRO && $3.tipo != CARACTERE)
									Incompatibilidade("Retorno incompativel com a funcao");
								break;
							case REAL:
								if ($3.tipo != INTEIRO &&  $3.tipo != CARACTERE && $3.tipo != REAL)
									Incompatibilidade("Retorno incompativel com a funcao");					
								break;
							case LOGICO:
								if ($3.tipo != LOGICO)
									Incompatibilidade("Retorno incompativel com a funcao");
								break;
							default:
								if (escopo->tvar != $3.tipo)
									Incompatibilidade("Retorno incompativel com a funcao");
								break;		
						}
						GeraQuadrupla (OPRETURN, $3.opnd, opndidle, opndidle);
					}  
				;
AssignStat 		:   Variable  
					{
						if  ($1.simb != NULL) {
							$1.simb->inic = $1.simb->ref = VERDADE;
							if ($1.simb->array == VERDADE)
								$<quad>$ = quadindex;
						}
					}
					ASSIGN  {printf(" = ");} Expression SCOLON  
					{
						printf(";");
						if ($1.simb != NULL) {
							if ((($1.simb->tvar == INTEIRO || $1.simb->tvar == CARACTERE) &&
								($5.tipo == REAL || $5.tipo == LOGICO)) ||
								($1.simb->tvar == REAL && $5.tipo == LOGICO) ||
								($1.simb->tvar == LOGICO && $5.tipo != LOGICO))
								Incompatibilidade ("Lado direito de comando de atribuicao improprio");
							if ($1.simb->array == VERDADE)
								GeraQuadrupla (ATRIBPONT, $5.opnd, opndidle, $<quad>2->result);
							else
								GeraQuadrupla (OPATRIB, $5.opnd, opndidle, $1.opnd);
						}
					}
				;
ExprList		:  	Expression  
					{
						$$.nargs = 1;
						$$.listtipo = InicListaTipo ($1.tipo);
						GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
					}
				| 	ExprList  COMMA {printf(", ");} Expression
					{
						$$.nargs = $1.nargs + 1;
						$$.listtipo = AdicElemListaTipo ($1.listtipo, $4.tipo);
						GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);

					}
				;
Expression  	:   AuxExpr1
				|   Expression  OR {printf(" || ");} AuxExpr1  
					{
						if ($1.tipo != LOGICO || $4.tipo != LOGICO)
							Incompatibilidade ("Operando improprio para operador or");
						$$.tipo = LOGICO;
	                    $$.opnd.tipo = VAROPND;
						$$.opnd.atr.simb = NovaTemp ($$.tipo);
						GeraQuadrupla (OPOR, $1.opnd, $4.opnd, $$.opnd);
					}
				;
AuxExpr1    	:   AuxExpr2
				|   AuxExpr1  AND {printf(" && ");} AuxExpr2  
					{
						if ($1.tipo != LOGICO || $4.tipo != LOGICO)
							Incompatibilidade ("Operando improprio para operador and");
						$$.tipo = LOGICO;
						$$.opnd.tipo = VAROPND;
						$$.opnd.atr.simb = NovaTemp ($$.tipo);
						GeraQuadrupla (OPAND, $1.opnd, $4.opnd, $$.opnd);
					}
				;
AuxExpr2    	:   AuxExpr3
				|   NOT {printf("!");} AuxExpr3  
					{
						if ($3.tipo != LOGICO)
							Incompatibilidade ("Operando improprio para operador not");
						$$.tipo = LOGICO;
						$$.opnd.tipo = VAROPND;
						$$.opnd.atr.simb = NovaTemp ($3.tipo);
						GeraQuadrupla (OPNOT, $3.opnd, opndidle, $$.opnd);
					}
				;
AuxExpr3    	:   AuxExpr4
				|   AuxExpr4  RELOP
					{
						if ($2 == LT) printf(" < ");
						else if ($2 == LE) printf(" <= ");
						else if ($2 == GT) printf(" > ");
						else if ($2 == GE) printf(" >= ");
						else if ($2 == EQ) printf(" == ");
						else if ($2 == NE) printf(" != ");
					}
					AuxExpr4  
					{
						switch ($2) 
						{
							case LT: case LE: case GT: case GE:
								if ($1.tipo != INTEIRO && $1.tipo != REAL && $1.tipo != CARACTERE 
								|| $4.tipo != INTEIRO && $4.tipo != REAL && $4.tipo != CARACTERE)
									Incompatibilidade	("Operando improprio para operador relacional");
								break;
							case EQ: case NE:
								if (($1.tipo == LOGICO || $4.tipo == LOGICO) && $1.tipo != $4.tipo)
									Incompatibilidade ("Operando improprio para operador relacional");
								break;
						}	
						$$.tipo = LOGICO;
	                    $$.opnd.tipo = VAROPND;
						$$.opnd.atr.simb = NovaTemp ($$.tipo);
						switch ($2) {
							case LT:
								GeraQuadrupla (OPLT, $1.opnd, $4.opnd, $$.opnd);
								break;
							case LE:
								GeraQuadrupla (OPLE, $1.opnd, $4.opnd, $$.opnd);
								break;
							case GT:
								GeraQuadrupla (OPGT, $1.opnd, $4.opnd, $$.opnd);
								break;
							case GE:
								GeraQuadrupla (OPGE, $1.opnd, $4.opnd, $$.opnd);
								break;
							case EQ:
								GeraQuadrupla (OPEQ, $1.opnd, $4.opnd, $$.opnd);
								break;
							case NE:
								GeraQuadrupla (OPNE, $1.opnd, $4.opnd, $$.opnd);
								break;
						}
					}
				;
AuxExpr4    	:	Term
				|   AuxExpr4  ADOP  
					{
						if ($2 == PLUS) printf (" + ");
						else if ($2 == MINUS) printf (" - ");
					}
					Term  
					{
                        if ($1.tipo != INTEIRO && $1.tipo != REAL && 
						$1.tipo != CARACTERE || $4.tipo != INTEIRO && 
						$4.tipo != REAL && $4.tipo != CARACTERE)
                            Incompatibilidade ("Operando improprio para operador aritmetico");
                        if ($1.tipo == REAL || $4.tipo == REAL) 
							$$.tipo = REAL;
                        else 
							$$.tipo = INTEIRO;
						$$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        if ($2 == PLUS)
                            GeraQuadrupla (OPMAIS, $1.opnd, $4.opnd, $$.opnd);
                        else  
							GeraQuadrupla (OPMENOS, $1.opnd, $4.opnd, $$.opnd);
					}
				;
Term  	    	:   Factor
				|   Term  MULTOP 
					{
						if ($2 == TIMES) printf(" * ");
						else if ($2 == DIV) printf(" / ");
						else if ($2 == PERC) printf(" %% ");
					}
					Factor 
					{
						switch ($2) {
							case TIMES: case DIV:
								if ($1.tipo != INTEIRO && $1.tipo != REAL && 
								$1.tipo != CARACTERE || $4.tipo != INTEIRO && 
								$4.tipo != REAL && $4.tipo != CARACTERE)
									Incompatibilidade ("Operando improprio para operador aritmetico");
								if ($1.tipo == REAL || $4.tipo == REAL) 
									$$.tipo = REAL;
								else 
									$$.tipo = INTEIRO;
								$$.opnd.tipo = VAROPND;
								$$.opnd.atr.simb = NovaTemp ($$.tipo);
								if ($2 == TIMES)
									GeraQuadrupla (OPMULTIP, $1.opnd, $4.opnd, $$.opnd);
								else  
									GeraQuadrupla (OPDIV, $1.opnd, $4.opnd, $$.opnd);
								break;
							case PERC:
								if ($1.tipo != INTEIRO && $1.tipo != CARACTERE  || 
								$4.tipo != INTEIRO && $4.tipo != CARACTERE)
									Incompatibilidade ("Operando improprio para operador resto");
								$$.tipo = INTEIRO;
	                            $$.opnd.tipo = VAROPND;
								$$.opnd.atr.simb = NovaTemp ($$.tipo);
								GeraQuadrupla (OPRESTO, $1.opnd, $4.opnd, $$.opnd);
								break;
						}
					}
				;
Factor			:   Variable  
					{
						if  ($1.simb != NULL) {
							$1.simb->ref  =  VERDADE;
						   	$$.tipo = $1.simb->tvar;
							if ($1.simb->array == VERDADE) {
								$$.opnd.tipo = VAROPND;
								$$.opnd.atr.simb = NovaTemp ($$.tipo);
								GeraQuadrupla (CONTAPONT, quadindex->result, opndidle, $$.opnd); 
							}
							else 
								$$.opnd = $1.opnd;
						}
					}
				|   INTCT  
					{
						printf("%d", $1); 
						$$.tipo = INTEIRO;
						$$.opnd.tipo = INTOPND;
						$$.opnd.atr.valint = $1;
					}
				|   FLOATCT  
					{
						printf("%g", $1); 
						$$.tipo = REAL;
						$$.opnd.tipo = REALOPND;
						$$.opnd.atr.valfloat = $1;
					}
				|   CHARCT  
					{
						printf("%s", $1); 
						$$.tipo = CARACTERE;
						$$.opnd.tipo = CHAROPND;
						$$.opnd.atr.valchar = tratachar($1);
					}
				|   TRUE  
					{
						printf("true"); 
						$$.tipo = LOGICO;
						$$.opnd.tipo = LOGICOPND;
						$$.opnd.atr.vallogic = 1;
					}
				|   FALSE  
					{
						printf("false"); 
						$$.tipo = LOGICO;
	                    $$.opnd.tipo = LOGICOPND;
						$$.opnd.atr.vallogic = 0;
					}
				|	NEG {printf("~");} Factor 
					{
						if ($3.tipo != INTEIRO && $3.tipo != REAL && $3.tipo != CARACTERE)
							Incompatibilidade  ("Operando improprio para menos unario");
						if ($3.tipo == REAL) 
							$$.tipo = REAL;
						else 
							$$.tipo = INTEIRO;
	                    $$.opnd.tipo = VAROPND;
						$$.opnd.atr.simb = NovaTemp ($$.tipo);
						GeraQuadrupla  (OPMENUN, $3.opnd, opndidle, $$.opnd);
					}
				|   OPPAR {printf("(");} Expression {printf(")");} CLPAR  
					{
						$$.tipo = $3.tipo;
						$$.opnd = $3.opnd;
					}
				| 	FuncCall 
					{
						if ($1.simb != NULL) {
							$$.tipo = $1.simb->tvar;
							$$.opnd = $1.opnd;
						}
					}
				;
Variable		:   ID  
					{
						printf("%s", $1);
						simb = ProcuraSimb ($1, escopo);
						if (simb == NULL)
							simb = ProcuraSimb ($1, global);
						if (simb == NULL) 
							NaoDeclarado ($1);
						else if (simb->tid != IDVAR) 
							TipoInadequado ($1);
						$$.simb = simb;
						if ($$.simb != NULL) {
							if ($$.simb->array == VERDADE)
								Esperado ("Subscrito\(s)");
							$$.opnd.tipo = VAROPND;
							$$.opnd.atr.simb = $$.simb;							
						}
					}
				|  	ID OPBRAK
					{
						printf("%s [", $1);
						simb = ProcuraSimb ($1, escopo);
						if (simb == NULL)
							simb = ProcuraSimb ($1, global);
						if (simb == NULL) 
							NaoDeclarado ($1);
						else if (simb->tid != IDVAR) 
							TipoInadequado ($1);
						$<simb>$ = simb;
					}
					SubscrList CLBRAK 
					{
						printf("]"); 
						$$.simb = $<simb>3;
						if ($$.simb != NULL) {
                        	if ($$.simb->array == FALSO)
                       			NaoEsperado ("Subscrito\(s)");
							else if ($$.simb->ndims != $4)
								Incompatibilidade ("Numero de subscritos incompativel com declaracao");
							else {
								$$.opnd.tipo = VAROPND;
								$$.opnd.atr.simb = $$.simb;
								opnd2.tipo = INTOPND;
								opnd2.atr.valint = $4;
								result.tipo = VAROPND;
								result.atr.simb = NovaTemp ($$.opnd.atr.simb->tvar);
								result.atr.simb->tempindex = VERDADE;
								quadindex = GeraQuadrupla (OPINDEX, $$.opnd, opnd2, result);
							}
						}
					}   
				;
SubscrList  	:  	AuxExpr4 
					{
						if ($1.tipo != INTEIRO && $1.tipo != CARACTERE)
								Incompatibilidade ("Tipo inadequado para subscrito");
						$$ = 1;
						GeraQuadrupla (OPIND, $1.opnd, opndidle, opndidle);
					}
				| 	SubscrList  COMMA {printf(",");}  AuxExpr4
					{
						if ($4.tipo != INTEIRO && $4.tipo != CARACTERE)
							Incompatibilidade ("Tipo inadequado para subscrito");
						$$ = $1 + 1;
						GeraQuadrupla (OPIND, $4.opnd, opndidle, opndidle);
					}
				;
FuncCall    	:  	ID  OPPAR  CLPAR 
					{
						printf("%s ()", $1);
						simb = ProcuraSimb ($1, global);
						if (simb == NULL) 
							NaoDeclarado($1);
						else if (simb->tid != IDFUNC)
							TipoInadequado($1);
						else if (simb->infofuncproc.nargs != 0)
							Incompatibilidade("Numero de argumentos diferente do numero de parametros");
						$$.simb = simb;
						if ($$.simb != NULL && $$.simb->tid == IDFUNC) {
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = ProcuraModhead($$.simb);
							opnd2.tipo = INTOPND;
							opnd2.atr.valint = 0;
							result.tipo = VAROPND;
							result.atr.simb = NovaTemp ($$.simb->tvar);
							GeraQuadrupla (OPCALL, opnd1, opnd2, result);
							$$.opnd = result;
						}
					} 
				| 	ID  OPPAR
					{
						printf("%s (", $1);
						simb = ProcuraSimb ($1, global);
						if (simb == NULL) 
							NaoDeclarado($1);
						else if (simb->tid != IDFUNC)
							TipoInadequado($1);
						$<simb>$ = simb;
					} 
					ExprList CLPAR
					{
						$$.simb = $<simb>3;
						if ($$.simb && $$.simb->tid == IDFUNC) {
							if ($$.simb->infofuncproc.nargs != $4.nargs)
								Incompatibilidade("Numero de argumentos diferente do numero de parametros");
							ChecArgumentos($$.simb->infofuncproc.listtipo, $4.listtipo);
							opnd1.tipo = MODOPND;
							opnd1.atr.modulo = ProcuraModhead($$.simb);
							opnd2.tipo = INTOPND;
							opnd2.atr.valint = $4.nargs;
							result.tipo = VAROPND;
							result.atr.simb = NovaTemp ($$.simb->tvar);
							GeraQuadrupla (OPCALL, opnd1, opnd2, result);
							$$.opnd = result;
						}
						printf(")");

					} 
				;
				
%%

/* Inclusao do analisador lexico  */

#include "lex.yy.c"

/*  InicTabSimb: Inicializa a tabela de simbolos 
	Funcao obtida do arquivo tsimb022015.y */

void InicTabSimb () {
	int i;
	for (i = 0; i < NCLASSHASH; i++)
		tabsimb[i] = NULL;
}

/*
	ProcuraSimb (cadeia, escopo): Procura cadeia em um determinado
	escopo na tabela de simbolos;
	Caso ela ali esteja, retorna um ponteiro para sua celula;
	Caso contrario, retorna NULL.
	Funcao adaptada do arquivo tsimb022015.y 
 */

simbolo ProcuraSimb (char *cadeia, simbolo escopo) {
	simbolo s; int i;
	i = hash (cadeia);
	for (s = tabsimb[i]; (s!=NULL) 
	&& (strcmp(cadeia, s->cadeia) || strcmp(s->escopo->cadeia, escopo->cadeia));
		s = s->prox);
	return s;
}

/*
	InsereSimb (cadeia, tid, tvar, escopo): Insere cadeia na tabela de
	simbolos, com tid como tipo de identificador e com tvar como
	tipo de variavel, bem como o escopo em que se encontra a variavel
	lida, se for o caso; Retorna um ponteiro para a celula inserida
	Funcao adaptada do arquivo tsimb022015.y 
 */

simbolo InsereSimb (char *cadeia, int tid, int tvar, simbolo escopo) {
	int i; simbolo aux, s;
	i = hash (cadeia); aux = tabsimb[i];
	s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
	s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
	strcpy (s->cadeia, cadeia);
	s->tid = tid;		s->tvar = tvar;
	s->inic = FALSO;	s->ref = FALSO;
	s->prox = aux;	s->escopo = escopo;
	s->infofuncproc.nargs = 0;
	s->infofuncproc.listtipo = NULL;
	s->tempindex = FALSO;
	s->param = FALSO;
	return s;
}

/*
	hash (cadeia): funcao que determina e retorna a classe
	de cadeia na tabela de simbolos implementada por hashing
	Funcao obtida do arquivo tsimb022015.y 
 */

int hash (char *cadeia) {
	int i, h;
	for (h = i = 0; cadeia[i]; i++) {h += cadeia[i];}
	h = h % NCLASSHASH;
	return h;
}

/* ImprimeTabSimb: Imprime todo o conteudo da tabela de simbolos 
	Funcao adaptada do arquivo tsimb022015.y  */

void ImprimeTabSimb () {
	int i; simbolo s; modhead m; listsimb L;
	printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i]) {
			printf ("Classe %d:\n", i);
			for (s = tabsimb[i]; s!=NULL; s = s->prox){
				printf ("  (%s, %s", s->cadeia,  nometipid[s->tid]);
				if (s->tid == IDVAR) {
					if (s->array == VERDADE){
						int j;
						printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
						for (j = 1; j <= s->ndims; j++)
							printf ("  %d", s->dims[j]);
					}
					printf (", %s, %d, %d, %s", nometipvar[s->tvar], s->inic, s->ref, s->escopo->cadeia);
				}
				if (s->tid == IDFUNC)
					printf (", %s", nometipvar[s->tvar]);
				if (s->tid == IDFUNC || s->tid == IDPROC) {
					printf (", %d params", s->infofuncproc.nargs);
					if (s->infofuncproc.nargs > 0) {
						m = ProcuraModhead(s);
						for (L = m->listparam->prox; L != NULL; L = L->prox) {
							printf(" %s", L->simb->cadeia);
						}
					}
				}
				printf(")\n");
			}
		}
}

/* VerificaInicRef: Percorre a tabela de símbolos checando identificadores
	não-inicializados e não-referenciados  
 */

void VerificaInicRef () {
	int i; simbolo s;
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i])
			for (s = tabsimb[i]; s!=NULL; s = s->prox)
				if (s->tid == IDVAR) {
					if (s->inic == FALSO)
						printf ("%s: Nao Inicializada\n", s->cadeia);
					if (s->ref == FALSO)
						printf ("%s: Nao Referenciada\n", s->cadeia);
				}
}

/* InicListaTipo: Inicializa uma lista de tipos recebendo um tipo a ser inserido.
	O noh lider da lista nao contem informacao de tipos, servindo apenas para
	acessar a lista.
 */

listexprtipo InicListaTipo (int tipo) {
	listexprtipo L;
	L = (listexprtipo) malloc (sizeof (listexprtipo));
	L->prox = (pontexprtipo *) malloc (sizeof (pontexprtipo));
	L->prox->tipo = tipo;
	L->prox->prox = NULL;
	return L;
}

/* AdicElemListaTipo: Recebe uma lista de tipos e um tipo a ser adicionado
	ao final da lista, retornando uma cópia da lista com o elemento adicionado
	no final.
 */

listexprtipo AdicElemListaTipo (listexprtipo L, int tipo) {
    pontexprtipo * p;
    pontexprtipo * p1;
    listexprtipo L1;
    if (L == NULL)
        return InicListaTipo(tipo);
    else{
        L1 = (listexprtipo) malloc (sizeof (listexprtipo));
        p1 = L1;
        p = L;
        while (p->prox != NULL) {
            p1->prox = (pontexprtipo *) malloc (sizeof (pontexprtipo));
            p1 = p1->prox;
            p = p->prox;
            p1->tipo = p->tipo;
        }
        p1->prox = (pontexprtipo *) malloc (sizeof (pontexprtipo));
        p1 = p1->prox;
        p1->tipo = tipo;
        p1->prox = NULL;
    }
    return L1;
}

/* ChecArgumentos: Percorre as listas de tipos dos argumentos de uma chamada
	de funcao ou procedimento e de tipos de parametros dessa funcao ou procedimento,
	verificando se sao tipos compativeis.
	Funcao adaptada do Cap 6 de Aulas Teoricas de CES-41
 */

void ChecArgumentos (listexprtipo lparams, listexprtipo largs) {
	pontexprtipo * p;
	pontexprtipo * q;
	p = lparams->prox;
	q = largs->prox;
	while (p != NULL && q != NULL) {
		switch(p->tipo) {
			case INTEIRO: case CARACTERE:
				if (q->tipo != INTEIRO && q->tipo != CARACTERE)
					Incompatibilidade("Argumentos incompativeis com os parametros");
				break;
			case REAL:
				if (q->tipo != INTEIRO &&  q->tipo != CARACTERE && q->tipo != REAL)
					Incompatibilidade("Argumentos incompativeis com os parametros");					
				break;
			case LOGICO:
				if (q->tipo != LOGICO)
					Incompatibilidade("Argumentos incompativeis com os parametros");
				break;
			default:
				if (p->tipo != q->tipo)
					Incompatibilidade("Argumentos incompativeis com os parametros");
				break;
		}
		p = p->prox;
		q = q->prox;
	}
}

void tabular () {
	/*int i;
	for (i = 1; i <= tab; i++)
   	printf ("\t");*/
}

/*  Mensagens de erros semanticos  */

void DeclaracaoRepetida (char *s) {
	printf ("\n\n***** Declaracao Repetida: %s *****\n\n", s);
}

void NaoDeclarado (char *s) {
    printf ("\n\n***** Identificador Nao Declarado: %s *****\n\n", s);
}

void TipoInadequado (char *s) {
    printf ("\n\n***** Identificador de Tipo Inadequado: %s *****\n\n", s);
}

void Incompatibilidade (char *s) {
    printf ("\n\n***** Incompatibilidade: %s *****\n\n", s);
}

void NaoInicializado (char *s) {
    printf ("\n\n***** Identificador Nao Inicializado: %s *****\n\n", s);
}

void NaoReferenciado (char *s) {
    printf ("\n\n***** Identificador Nao Referenciado: %s *****\n\n", s);
}

void Esperado (char *s) {
	printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
	printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
}

/* Funcoes para o codigo intermediario
	Obtidas do arquivo inter022015.y*/

void InicCodIntermed () {
	modcorrente = codintermed = malloc (sizeof (celmodhead));
    modcorrente->listquad = NULL;
	modcorrente->prox = NULL;
}

void InicCodIntermMod (simbolo simb) {
	modcorrente->prox = malloc (sizeof (celmodhead));
	modcorrente = modcorrente->prox;
	modcorrente->prox = NULL;
	modcorrente->modname = simb;
	modcorrente->modtip = simb->tid;
	modcorrente->listquad = malloc (sizeof (celquad));
	quadcorrente = modcorrente->listquad;
	quadcorrente->prox = NULL;
	numquadcorrente = 0;
	quadcorrente->num = numquadcorrente;
}

quadrupla GeraQuadrupla (int oper, operando opnd1, operando opnd2,
	operando result) {
	quadcorrente->prox = malloc (sizeof (celquad));
	quadcorrente = quadcorrente->prox;
	quadcorrente->oper = oper;
	quadcorrente->opnd1 = opnd1;
	quadcorrente->opnd2 = opnd2;
	quadcorrente->result = result;
	quadcorrente->prox = NULL;
	numquadcorrente ++;
    quadcorrente->num = numquadcorrente;
    return quadcorrente;
}

simbolo NovaTemp (int tip) {
	simbolo simb; int temp, i, j;
	char nometemp[10] = "##", s[10] = {0};

	numtemp ++; temp = numtemp;
	for (i = 0; temp > 0; temp /= 10, i++)
		s[i] = temp % 10 + '0';
	i --;
	for (j = 0; j <= i; j++)
		nometemp[2+i-j] = s[j];
	simb = InsereSimb (nometemp, IDVAR, tip, escopo);
	simb->inic = simb->ref = VERDADE;
    simb->array = FALSO;
	return simb;
}

void ImprimeQuadruplas () {
	modhead p;
	quadrupla q;
	for (p = codintermed->prox; p != NULL; p = p->prox) {
		printf ("\n\nQuadruplas do modulo %s:\n", p->modname->cadeia);
		for (q = p->listquad->prox; q != NULL; q = q->prox) {
			printf ("\n\t%4d) %s", q->num, nomeoperquad[q->oper]);
			printf (", (%s", nometipoopndquad[q->opnd1.tipo]);
			switch (q->opnd1.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd1.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd1.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd1.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd1.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd1.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd1.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd1.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->opnd2.tipo]);
			switch (q->opnd2.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd2.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd2.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd2.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd2.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd2.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd2.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd2.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd2.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->result.tipo]);
			switch (q->result.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->result.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->result.atr.valint); break;
				case REALOPND: printf (", %g", q->result.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->result.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->result.atr.vallogic); break;
				case CADOPND: printf (", %s", q->result.atr.valcad); break;
				case ROTOPND: printf (", %d", q->result.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->result.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
		}
	}
   printf ("\n");
}

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
	quadrupla q; int nquad;
	for (q = quad1->prox, nquad = quad1->num; q != quad2->prox; q = q->prox) {
        nquad++;
		q->num = nquad;
	}
}

/* ProcuraModhead: encontra o modhead de um modulo (funcao ou procedimento)
	dado o ponteiro para este modulo na tabela de simbolos*/

modhead ProcuraModhead (simbolo simb) {
	modhead p;
	if (simb == NULL)
		return NULL;
	else if (simb->tid != IDPROG && simb->tid != IDFUNC && simb->tid != IDPROC)
		return NULL;
	else {
		for (p = codintermed->prox; p != NULL; p = p->prox) {
			if (p->modname == simb)
				return p;
		}
	}
	return NULL;
}

/*
	tratachar: retorna o codigo ASCII de uma constante do tipo char,
   eliminando os apostrofos e as barras invertidas.
   Funcao obtida do arquivo inter022015.l
 */

char tratachar (char *s) {
	if (s[1] != '\\') return s[1];
	else switch (s[2]) {
		case 'a': 	return 7;		case '\\': 	return 92;
		case 'b': 	return 8;		case 'r': 	return 13;
		case '\"': 	return 34;		case 'f': 	return 12;
		case 't': 	return 9;		case 'n': 	return 10;
		case '0': 	return 0;		case '\'': 	return 39;
		case 'v': 	return 11;
		default:	return s[2];
	}
}

void tratacadeia (char *s) {
	int i, n, d;
	n = strlen (s);
	for (i = 0, d = 1; i <= n-2-d; i++)   {
		if (s[i+d] != '\\') s[i] = s[i+d];
		else {
			switch (s[i+d+1]) {
				case 'a': 	s[i] = 7;break;
				case '\\': 	s[i] = 92; break;
				case 'b': 	s[i] = 8; break;
				case 'r': 	s[i] = 13; break;
				case '\"': 	s[i] = 34; break;
				case 'f': 	s[i] = 12; break;
				case 't': 	s[i] = 9;  break;
				case 'n': 	s[i] = 10; break;
				case '\0': 	s[i] = 0;  break;
				case '\'': 	s[i] = 39; break;
				case 'v': 	s[i] = 11; break;
				default:	s[i] = s[i+d+1];
			}
			d++;
		}
	}
	s[i] = s[n];
}

/* Funcoes para a interpretacao do codigo intermediario
 
	InterpCodIntermed: le cada quadrupla do codigo intermediario
	e executa as devidas acoes (incluindo desvios para outras quadruplas)
	Funcao adaptada do arquivo pret012015.y */

void InterpCodIntermed () {
	quadrupla quad, quadprox;  char encerra; char condicao;
	simbolo escopo;
	//printf ("\n\nINTERPRETADOR:\n");
	InicPilhaOpnd (&pilhaopnd);
	InicPilhaOpnd (&pilhaind);
	InicPilhaOpnd (&pilharet);
	InicPilhaQuad (&pilhaquad);
	encerra = FALSO;
	finput = fopen ("entrada2015", "r");
	quad = codintermed->prox->listquad->prox;
	while (! encerra) {
		//printf ("\n%4d) %s", quad->num, nomeoperquad[quad->oper]);
		quadprox = quad->prox;
		switch (quad->oper) {
			case OPENMOD:
				if (quad->opnd1.atr.modulo->modtip == IDPROG)
					escopo = global;
				else if (quad->opnd1.atr.modulo->modtip == IDPROC || 
					quad->opnd1.atr.modulo->modtip == IDFUNC)
					escopo = quad->opnd1.atr.modulo->modname;
				if (escopo != NULL)
					AlocaVariaveis (escopo); 
				break;
			case OPOR: ExecQuadOr (quad); break;
			case OPAND: ExecQuadAnd (quad); break;
			case OPNOT: ExecQuadNot (quad); break;
			case OPLT: ExecQuadLT (quad); break;
			case OPLE: ExecQuadLE (quad); break;
			case OPGT: ExecQuadGT (quad); break;
			case OPGE: ExecQuadGE (quad); break;
			case OPEQ: ExecQuadEQ (quad); break;
			case OPNE: ExecQuadNE (quad); break;
			case OPMAIS: ExecQuadMais (quad); break;
			case OPMENOS: ExecQuadMenos (quad); break;
			case OPMULTIP: ExecQuadMult (quad); break;
			case OPDIV: 
				encerra = ExecQuadDiv(quad); 
				if (encerra)
					printf("\n\n***** Erro: divisao por zero *****\n\n");
				break;
			case OPRESTO:
				encerra = ExecQuadResto(quad); 
				if (encerra)
					printf("\n\n***** Erro: divisao por zero *****\n\n");
				break;
			case OPMENUN: ExecQuadMenun (quad); break;
			case OPATRIB: ExecQuadAtrib (quad); break;
			case OPJUMP: quadprox = quad->result.atr.rotulo; break;
			case OPJF: 
				if (quad->opnd1.tipo == LOGICOPND)
					condicao = quad->opnd1.atr.vallogic;
				if (quad->opnd1.tipo == VAROPND)
					condicao = *(quad->opnd1.atr.simb->vallogic);
				if (!condicao)
					quadprox = quad->result.atr.rotulo; 
				break;
			case OPJT: 
				if (quad->opnd1.tipo == LOGICOPND)
					condicao = quad->opnd1.atr.vallogic;
				if (quad->opnd1.tipo == VAROPND)
					condicao = *(quad->opnd1.atr.simb->vallogic);
				if (condicao)
					quadprox = quad->result.atr.rotulo; 
				break;
			case PARAM: EmpilharOpnd (quad->opnd1, &pilhaopnd); break;
			case OPREAD: ExecQuadRead (quad); break;
			case OPWRITE: ExecQuadWrite (quad); break;
			case OPIND: ExecQuadInd (quad); break;
			case OPINDEX: 
				encerra = ExecQuadIndex (quad);
				if (encerra)
					printf("\n\n***** Erro: indice fora dos limites do array *****\n\n");
				break;
			case CONTAPONT: ExecQuadContapont (quad); break;
			case ATRIBPONT: ExecQuadAtrib (quad); break;
			case OPCALL:
				if (quad->opnd2.atr.valint > 0)
					ExecQuadCall(quad);
				EmpilharOpnd(quad->result, &pilharet);
				EmpilharQuad(quadprox, &pilhaquad);
				quadprox = quad->opnd1.atr.modulo->listquad->prox;
				break;
			case OPEXIT: encerra = VERDADE; break;
			case OPRETURN:
				ExecQuadReturn(quad);
				if (! VaziaQuad(pilhaquad)) {
					quadprox = TopoQuad(pilhaquad);
					DesempilharQuad(&pilhaquad);
					escopo = ProcuraEscopo(quadprox);
				}
				break;	
		}
		if (! encerra) quad = quadprox;
		if (quad == NULL) encerra = VERDADE;
	}
	//printf ("\n");
}

/* AlocaVariaveis: aloca espaco na memoria para armazenar os valores
	das variaveis de um determinado modulo (escopo)
	Funcao adaptada do arquivo pret012015.y */
	
void AlocaVariaveis (simbolo escopo) {
	simbolo s; int nelemaloc, i, j;
	//printf ("\n\t\tAlocando as variaveis:");
	for (i = 0; i < NCLASSHASH; i++)
	    if (tabsimb[i]) {
			for (s = tabsimb[i]; s != NULL; s = s->prox) {
				if ((s->tid == IDVAR && s->escopo == escopo && s->param == FALSO) || 
					(escopo == global && s->param == VERDADE)) {
					nelemaloc = 1;
	                if (s->array == VERDADE) {
						for (j = 1; j <= s->ndims; j++) {
							nelemaloc *= s->dims[j];
						}
					}
				    switch (s->tvar) {
						case INTEIRO:
							s->valint = malloc (nelemaloc * sizeof (int)); break;
	                    case REAL:
							s->valfloat = malloc (nelemaloc * sizeof (float)); break;
	                    case CARACTERE:
							s->valchar = malloc (nelemaloc * sizeof (char)); break;
	                    case LOGICO:
							s->vallogic = malloc (nelemaloc * sizeof (char)); break;
	                }
	                //printf ("\n\t\t\t%s: %d elemento(s) alocado(s) no escopo %s",
					//s->cadeia, nelemaloc, escopo->cadeia);
	            }
	      	}
	    }
}

/* ProcuraEscopo: retorna o escopo ao qual pertence uma determinada quádrupla */

simbolo ProcuraEscopo(quadrupla quad) {
	modhead p; simbolo s; quadrupla q;
	if (quad == NULL)
		return NULL;
	else {
		for (p = codintermed->prox; p != NULL; p = p->prox) {
			for (q = p->listquad->prox; q != NULL; q = q->prox) {
				if (q == quad)
					return p->modname;
			}
		}
	}
	return NULL;
} 

/* InicListaSimb: Inicializa uma lista de simbolos recebendo um simbolo a ser inserido.
	O noh lider da lista nao contem informacao, servindo apenas para
	acessar a lista.
 */

listsimb InicListaSimb (simbolo simb) {
	listsimb L;
	L = (listsimb) malloc (sizeof (listsimb));
	L->prox = (pontelemlistsimb) malloc (sizeof (pontelemlistsimb));
	L->prox->simb = simb;
	L->prox->prox = NULL;
	return L;
}

/* AdicElemListaSimb: Adiciona um elemento ao final de uma lista de símbolos,
	sem criar uma nova cópia */

void AdicElemListaSimb (listsimb L, simbolo simb) {
    pontelemlistsimb p;
    if (L == NULL) {
        L->prox = (pontelemlistsimb) malloc (sizeof (pontelemlistsimb));
		L->prox->simb = simb;
		L->prox->prox = NULL;
	}
    else {
        p = L;
        while (p->prox != NULL) {
            p = p->prox;
        }
        p->prox = (pontelemlistsimb) malloc (sizeof (pontelemlistsimb));
        p->prox->simb = simb;
        p->prox->prox = NULL;
    }
}

/* Funcoes para manipulacao da pilha de operandos
	Obtidas do arquivo pret012015.y */

void EmpilharOpnd (operando x, pilhaoperando *P) {
	nohopnd *temp;
	temp = *P;   
	*P = (nohopnd *) malloc (sizeof (nohopnd));
	(*P)->opnd = x; 
	(*P)->prox = temp;
}

void DesempilharOpnd (pilhaoperando *P) {
	nohopnd *temp;
	if (! VaziaOpnd (*P)) {
		temp = *P;  
		*P = (*P)->prox; 
		free (temp);
	}
	else  
		printf ("\n\tDelecao em pilha vazia\n");
}

operando TopoOpnd (pilhaoperando P) {
	if (! VaziaOpnd (P))  
		return P->opnd;
	else  
		printf ("\n\tTopo de pilha vazia\n");
}

void InicPilhaOpnd (pilhaoperando *P) { 
	*P = NULL;
}

char VaziaOpnd (pilhaoperando P) {
	if  (P == NULL)  
		return 1;  
	else 
		return 0; 
}

/* Funcoes para manipulacao da pilha de quadruplas
	Adaptadas do arquivo pret012015.y */

void EmpilharQuad (quadrupla x, pilhaquadrupla *P) {
	nohquad *temp;
	temp = *P;   
	*P = (nohquad *) malloc (sizeof (nohquad));
	(*P)->quad = x; 
	(*P)->prox = temp;
}

void DesempilharQuad (pilhaquadrupla *P) {
	nohquad *temp;
	if (! VaziaQuad (*P)) {
		temp = *P;  
		*P = (*P)->prox; 
		free (temp);
	}
	else  
		printf ("\n\tDelecao em pilha vazia\n");
}

quadrupla TopoQuad (pilhaquadrupla P) {
	if (! VaziaQuad (P))  
		return P->quad;
	else  
		printf ("\n\tTopo de pilha vazia\n");
}

void InicPilhaQuad (pilhaquadrupla *P) { 
	*P = NULL;
}

char VaziaQuad (pilhaquadrupla P) {
	if  (P == NULL)  
		return 1;  
	else 
		return 0; 
}

/* Funcoes para execucao de quadruplas
	As funcoes das quadruplas IND, INDEX, ATRIBPONT, CONTAPONT, CALL e RETURN
	foram implementadas de forma independente, enquanto as demais foram obtidas
	ou adaptadas do arquivo pret012015.y */

void ExecQuadOr (quadrupla quad) {
	int vallogic1, vallogic2;
	switch (quad->opnd1.tipo) {
		case LOGICOPND:
			vallogic1 = quad->opnd1.atr.vallogic;  break;
		case VAROPND:
			if (quad->opnd1.atr.simb->tvar == LOGICO) 
				vallogic1 = *(quad->opnd1.atr.simb->vallogic); 
			break;
	}
	switch (quad->opnd2.tipo) {
		case LOGICOPND:
			vallogic2 = quad->opnd2.atr.vallogic;  break;
		case VAROPND:
			if (quad->opnd2.atr.simb->tvar == LOGICO) 
				vallogic2 = *(quad->opnd2.atr.simb->vallogic); 
			break;
	}
	*(quad->result.atr.simb->vallogic) = vallogic1 || vallogic2;
}

void ExecQuadAnd (quadrupla quad) {
	int vallogic1, vallogic2;
	switch (quad->opnd1.tipo) {
		case LOGICOPND:
			vallogic1 = quad->opnd1.atr.vallogic;  break;
		case VAROPND:
			if (quad->opnd1.atr.simb->tvar == LOGICO) 
				vallogic1 = *(quad->opnd1.atr.simb->vallogic); 
			break;
	}
	switch (quad->opnd2.tipo) {
		case LOGICOPND:
			vallogic2 = quad->opnd2.atr.vallogic;  break;
		case VAROPND:
			if (quad->opnd2.atr.simb->tvar == LOGICO) 
				vallogic2 = *(quad->opnd2.atr.simb->vallogic); 
			break;
	}
	*(quad->result.atr.simb->vallogic) = vallogic1 && vallogic2; 
}

void ExecQuadNot (quadrupla quad) {
	int vallogic1;
	switch (quad->opnd1.tipo) {
		case LOGICOPND:
			vallogic1 = quad->opnd1.atr.vallogic;  break;
		case VAROPND:
			if (quad->opnd1.atr.simb->tvar == LOGICO) 
				vallogic1 = *(quad->opnd1.atr.simb->vallogic); 
			break;
	}
	*(quad->result.atr.simb->vallogic) = ! vallogic1; 
}

void ExecQuadMais (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat); break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = valint1 + valint2;
			break;
		case REAL:
			if (tipo1 == INTOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1 + valint2;
			if (tipo1 == INTOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valint1 + valfloat2;
			if (tipo1 == REALOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 + valint2;
			if (tipo1 == REALOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 + valfloat2;
			break;
	}
}

void ExecQuadMenos (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat); break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat); break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = valint1 - valint2;
			break;
		case REAL:
			if (tipo1 == INTOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1 - valint2;
			if (tipo1 == INTOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valint1 - valfloat2;
			if (tipo1 == REALOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 - valint2;
			if (tipo1 == REALOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 - valfloat2;
			break;
	}
}

void ExecQuadMult (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat); break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = valint1 * valint2;
			break;
		case REAL:
			if (tipo1 == INTOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1 * valint2;
			if (tipo1 == INTOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valint1 * valfloat2;
			if (tipo1 == REALOPND && tipo2 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 * valint2;
			if (tipo1 == REALOPND && tipo2 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1 * valfloat2;
			break;
	}
}

char ExecQuadDiv (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	char erro = FALSO;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
		case CHAROPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case REAL:
					tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat); break;
				case CARACTERE:
					tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar); break;
			}
			break;
	}
	if (valint2 == 0 || valfloat2 == 0)
		erro = VERDADE;
	else {
		switch (quad->result.atr.simb->tvar) {
			case INTEIRO:
				*(quad->result.atr.simb->valint) = valint1 / valint2;
				break;
			case REAL:
				if (tipo1 == INTOPND && tipo2 == INTOPND)
					*(quad->result.atr.simb->valfloat) = valint1 / valint2;
				if (tipo1 == INTOPND && tipo2 == REALOPND)
					*(quad->result.atr.simb->valfloat) = valint1 / valfloat2;
				if (tipo1 == REALOPND && tipo2 == INTOPND)
					*(quad->result.atr.simb->valfloat) = valfloat1 / valint2;
				if (tipo1 == REALOPND && tipo2 == REALOPND)
					*(quad->result.atr.simb->valfloat) = valfloat1 / valfloat2;
				break;
		}
	}
	return erro;
}

char ExecQuadResto (quadrupla quad) {
	int valint1, valint2;
	char erro = FALSO;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			valint1 = quad->opnd1.atr.valint;  break;
		case CHAROPND:
			valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case CARACTERE:
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			valint2 = quad->opnd2.atr.valint;  break;
		case CHAROPND:
			valint2 = quad->opnd2.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:
					valint2 = *(quad->opnd2.atr.simb->valint);  break;
				case CARACTERE:
					valint2 = *(quad->opnd2.atr.simb->valchar); break;
			}
			break;
	}
	if (valint2 == 0)
		erro = VERDADE;
	else 
		*(quad->result.atr.simb->valint) = valint1 % valint2;
	return erro;
}

void ExecQuadMenun (quadrupla quad) {
	int tipo1, valint1;
	float valfloat1;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);  break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			*(quad->result.atr.simb->valint) = - valint1;
			break;
		case REAL:
			if (tipo1 == INTOPND)
				*(quad->result.atr.simb->valfloat) = - valint1;
			if (tipo1 == REALOPND)
				*(quad->result.atr.simb->valfloat) = - valfloat1;
			break;
	}
}

void ExecQuadLT (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND; valfloat1=quad->opnd1.atr.valfloat;break;
		case CHAROPND:
			tipo1 = INTOPND; valint1 = quad->opnd1.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);
					break;
				case REAL:  tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar);
					break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2=REALOPND;valfloat2 = quad->opnd2.atr.valfloat;break;
		case CHAROPND:
			tipo2 = INTOPND;valint2 = quad->opnd2.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);
					break;
				case REAL:  tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar);
					break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 < valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 < valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 < valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 < valfloat2;
}

void ExecQuadLE (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND; valfloat1=quad->opnd1.atr.valfloat;break;
		case CHAROPND:
			tipo1 = INTOPND; valint1 = quad->opnd1.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);
					break;
				case REAL:  tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar);
					break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2=REALOPND;valfloat2 = quad->opnd2.atr.valfloat;break;
		case CHAROPND:
			tipo2 = INTOPND;valint2 = quad->opnd2.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);
					break;
				case REAL:  tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar);
					break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 <= valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 <= valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 <= valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 <= valfloat2;
}

void ExecQuadGT (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND; valfloat1=quad->opnd1.atr.valfloat;break;
		case CHAROPND:
			tipo1 = INTOPND; valint1 = quad->opnd1.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);
					break;
				case REAL:  tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar);
					break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2=REALOPND;valfloat2 = quad->opnd2.atr.valfloat;break;
		case CHAROPND:
			tipo2 = INTOPND;valint2 = quad->opnd2.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);
					break;
				case REAL:  tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar);
					break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 > valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 > valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 > valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 > valfloat2;
}

void ExecQuadGE (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND; valfloat1=quad->opnd1.atr.valfloat;break;
		case CHAROPND:
			tipo1 = INTOPND; valint1 = quad->opnd1.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);
					break;
				case REAL:  tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar);
					break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2=REALOPND;valfloat2 = quad->opnd2.atr.valfloat;break;
		case CHAROPND:
			tipo2 = INTOPND;valint2 = quad->opnd2.atr.valchar; break;
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);
					break;
				case REAL:  tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar);
					break;
			}
			break;
	}
	if (tipo1 == INTOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valint1 >= valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 >= valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 >= valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 >= valfloat2;
}

void ExecQuadEQ (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND; valfloat1=quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND; valint1 = quad->opnd1.atr.valchar; break;
		case LOGICOPND:
			tipo1 = LOGICOPND; valint1 = quad->opnd1.atr.vallogic;  break; 
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);
					break;
				case REAL:  tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar);
					break;
				case LOGICO:  tipo1 = LOGICOPND;
					valint1 = *(quad->opnd1.atr.simb->vallogic);
					break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2=REALOPND;valfloat2 = quad->opnd2.atr.valfloat;break;
		case CHAROPND:
			tipo2 = INTOPND;valint2 = quad->opnd2.atr.valchar; break;
		case LOGICOPND:
			tipo2 = LOGICOPND; valint2 = quad->opnd2.atr.vallogic;  break; 
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);
					break;
				case REAL:  tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar);
					break;
				case LOGICO:  tipo2 = LOGICOPND;
					valint2 = *(quad->opnd2.atr.simb->vallogic);
					break;
			}
			break;
	}
	if ( (tipo1 == INTOPND && tipo2 == INTOPND) ||
		(tipo1 == LOGICOPND && tipo2 == LOGICOPND))
		*(quad->result.atr.simb->vallogic) = valint1 == valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 == valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 == valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 == valfloat2;
}

void ExecQuadNE (quadrupla quad) {
	int tipo1, tipo2, valint1, valint2;
	float valfloat1, valfloat2;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
		case REALOPND:
			tipo1 = REALOPND; valfloat1=quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = INTOPND; valint1 = quad->opnd1.atr.valchar; break;
		case LOGICOPND:
			tipo1 = LOGICOPND; valint1 = quad->opnd1.atr.vallogic;  break; 
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint);
					break;
				case REAL:  tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valchar);
					break;
				case LOGICO:  tipo1 = LOGICOPND;
					valint1 = *(quad->opnd1.atr.simb->vallogic);
					break;
			}
			break;
	}
	switch (quad->opnd2.tipo) {
		case INTOPND:
			tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
		case REALOPND:
			tipo2=REALOPND;valfloat2 = quad->opnd2.atr.valfloat;break;
		case CHAROPND:
			tipo2 = INTOPND;valint2 = quad->opnd2.atr.valchar; break;
		case LOGICOPND:
			tipo2 = LOGICOPND; valint2 = quad->opnd2.atr.vallogic;  break; 
		case VAROPND:
			switch (quad->opnd2.atr.simb->tvar) {
				case INTEIRO:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valint);
					break;
				case REAL:  tipo2 = REALOPND;
					valfloat2 = *(quad->opnd2.atr.simb->valfloat);
					break;
				case CARACTERE:  tipo2 = INTOPND;
					valint2 = *(quad->opnd2.atr.simb->valchar);
					break;
				case LOGICO:  tipo2 = LOGICOPND;
					valint2 = *(quad->opnd2.atr.simb->vallogic);
					break;
			}
			break;
	}
	if ( (tipo1 == INTOPND && tipo2 == INTOPND) ||
		(tipo1 == LOGICOPND && tipo2 == LOGICOPND))
		*(quad->result.atr.simb->vallogic) = valint1 != valint2;
	if (tipo1 == INTOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valint1 != valfloat2;
	if (tipo1 == REALOPND && tipo2 == INTOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 != valint2;
	if (tipo1 == REALOPND && tipo2 == REALOPND)
		*(quad->result.atr.simb->vallogic) = valfloat1 != valfloat2;
}

void ExecQuadWrite (quadrupla quad) {
	int i;  operando opndaux;  pilhaoperando pilhaopndaux;
	//printf ("\n\t\tEscrevendo: \n\n");
	InicPilhaOpnd (&pilhaopndaux);
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
		DesempilharOpnd (&pilhaopnd);
	}
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		opndaux = TopoOpnd (pilhaopndaux);
		DesempilharOpnd (&pilhaopndaux);
		switch (opndaux.tipo) {
			case INTOPND:
				printf ("%d", opndaux.atr.valint); break;
			case REALOPND:
				printf ("%g", opndaux.atr.valfloat); break;
			case CHAROPND:
				printf ("%c", opndaux.atr.valchar); break;
			case LOGICOPND:
				if (opndaux.atr.vallogic == 1) printf ("TRUE");
				else printf ("FALSE");
				break;
			case CADOPND:
				printf ("%s", opndaux.atr.valcad); 
				break ;
			case VAROPND:
				switch (opndaux.atr.simb->tvar) {
					case INTEIRO:
						printf ("%d", *(opndaux.atr.simb->valint)); 
						break;
					case REAL:
						printf ("%g", *(opndaux.atr.simb->valfloat));
						break;
					case LOGICO:
						if (*(opndaux.atr.simb->vallogic) == 1)
							printf ("TRUE"); 
						else printf ("FALSE"); 
						break;
					case CARACTERE:
						printf ("%c", *(opndaux.atr.simb->valchar)); 
						break;
				}
				break;
		}
	}
	//printf ("\n");
}

void ExecQuadRead (quadrupla quad) {
	int i;  operando opndaux;  pilhaoperando pilhaopndaux;

	//printf ("\n\t\tLendo: \n");
	InicPilhaOpnd (&pilhaopndaux);
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
		DesempilharOpnd (&pilhaopnd);
	}
	for (i = 1; i <= quad->opnd1.atr.valint; i++) {
		opndaux = TopoOpnd (pilhaopndaux);
		DesempilharOpnd (&pilhaopndaux);
      	switch (opndaux.atr.simb->tvar) {
				case INTEIRO:
         			fscanf (finput, "%d", opndaux.atr.simb->valint); 
					break;
        		case REAL:
         			fscanf (finput, "%g", opndaux.atr.simb->valfloat);
					break;
         		case LOGICO:
         			fscanf (finput, "%d", opndaux.atr.simb->vallogic); 
					break;
        		case CARACTERE:
         			fscanf (finput, "%c", opndaux.atr.simb->valchar);
					break;
     		}
	}
}

void ExecQuadInd (quadrupla quad) {
	int valindice; operando opndaux;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			valindice = quad->opnd1.atr.valint;  break;
		case CHAROPND:
			valindice = quad->opnd1.atr.valchar;  break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					valindice = *(quad->opnd1.atr.simb->valint);  break;
				case CARACTERE:
					valindice = *(quad->opnd1.atr.simb->valchar); break;
			}
			break;
	}
	opndaux.tipo = INTOPND;
	opndaux.atr.valint = valindice;
	EmpilharOpnd (opndaux, &pilhaind);
}

char ExecQuadIndex (quadrupla quad) {
	int * endint; float * endfloat; char * endchar;
	int indices[MAXDIMS + 1]; int offset, prod, numIndices, i, k, l;
	operando opndaux; char erro = FALSO;
	switch (quad->opnd1.atr.simb->tvar) {
		case INTEIRO: 
			endint = quad->opnd1.atr.simb->valint; break;
		case REAL:
			endfloat = quad->opnd1.atr.simb->valfloat; break;
		case LOGICO:
			endchar = quad->opnd1.atr.simb->vallogic; break;
		case CARACTERE:
			endchar = quad->opnd1.atr.simb->valchar; break;
	}
	numIndices = quad->opnd2.atr.valint;
	for (i = numIndices; i > 0; i--) {
		opndaux = TopoOpnd (pilhaind);
		indices[i] = opndaux.atr.valint;
		DesempilharOpnd (&pilhaind);
	}
	offset = 0; prod = 1;
	for (k = 1; k <= numIndices; k++) {
		//printf("\n\n Indice %d \n\n", indices[k]);
		for (l = k + 1; l <= numIndices; l++) {
			prod *= quad->opnd1.atr.simb->dims[l];
		}
		if (indices[k] > quad->opnd1.atr.simb->dims[k] || indices[k] <= 0) {
			erro = VERDADE;
		}
		offset += prod * (indices[k] - 1);
		prod = 1;
	}
	//printf("\n Offset: %d \n", offset);
	if (erro == FALSO) {
		switch (quad->result.atr.simb->tvar) {
			case INTEIRO:
				quad->result.atr.simb->valint = endint + offset;
				break;
			case REAL:
				quad->result.atr.simb->valfloat = endfloat + offset;
				break;
			case LOGICO:
				quad->result.atr.simb->vallogic = endchar + offset;
				break;
			case CARACTERE:
				quad->result.atr.simb->valchar = endchar + offset;
				break;
		}
	}
	return erro;
}

void ExecQuadAtrib (quadrupla quad) {
	int tipo1, valint1;
	float valfloat1;
	char valchar1, vallogic1;
	switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;
			valint1 = quad->opnd1.atr.valint; break;
		case REALOPND:
			tipo1 = REALOPND;
			valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = CHAROPND;
			valchar1 = quad->opnd1.atr.valchar; break;
		case LOGICOPND:
			tipo1 = LOGICOPND;
			vallogic1 = quad->opnd1.atr.vallogic; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint); break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = CHAROPND;
					valchar1 = *(quad->opnd1.atr.simb->valchar);break;
				case LOGICO:
					tipo1 = LOGICOPND;
					vallogic1 = *(quad->opnd1.atr.simb->vallogic);
					break;
			}
			break;
	}
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO:
			if (tipo1 == INTOPND)  *(quad->result.atr.simb->valint) = valint1;
			if (tipo1 == CHAROPND) *(quad->result.atr.simb->valint) = valchar1;
			break;
		case CARACTERE:
			if (tipo1 == INTOPND) *(quad->result.atr.simb->valchar) = valint1;
			if (tipo1==CHAROPND) *(quad->result.atr.simb->valchar)=valchar1;
			break;
		case LOGICO:  *(quad->result.atr.simb->vallogic) = vallogic1; break;
		case REAL:
			if (tipo1 == INTOPND)
				*(quad->result.atr.simb->valfloat) = valint1;
			if (tipo1 == REALOPND)
				*(quad->result.atr.simb->valfloat) = valfloat1;
			if (tipo1 == CHAROPND)
				*(quad->result.atr.simb->valfloat) = valchar1;
			break;
	}
}

void ExecQuadContapont (quadrupla quad) {
	switch (quad->result.atr.simb->tvar) {
		case INTEIRO: 
			*(quad->result.atr.simb->valint) = *(quad->opnd1.atr.simb->valint); 
			break;
		case REAL: 
			*(quad->result.atr.simb->valfloat) = *(quad->opnd1.atr.simb->valfloat); 
			break;
		case LOGICO: 
			*(quad->result.atr.simb->vallogic) = *(quad->opnd1.atr.simb->vallogic); 
			break;
		case CARACTERE: 
			*(quad->result.atr.simb->valchar) = *(quad->opnd1.atr.simb->valchar); 
			break;
	}
}

void ExecQuadReturn (quadrupla quad) {
	int tipo1, valint1;
	float valfloat1;
	char valchar1, vallogic1;
	if (quad->opnd1.tipo != IDLEOPND) {
		switch (quad->opnd1.tipo) {
		case INTOPND:
			tipo1 = INTOPND;
			valint1 = quad->opnd1.atr.valint; break;
		case REALOPND:
			tipo1 = REALOPND;
			valfloat1 = quad->opnd1.atr.valfloat; break;
		case CHAROPND:
			tipo1 = CHAROPND;
			valchar1 = quad->opnd1.atr.valchar; break;
		case LOGICOPND:
			tipo1 = LOGICOPND;
			vallogic1 = quad->opnd1.atr.vallogic; break;
		case VAROPND:
			switch (quad->opnd1.atr.simb->tvar) {
				case INTEIRO:
					tipo1 = INTOPND;
					valint1 = *(quad->opnd1.atr.simb->valint); break;
				case REAL:
					tipo1 = REALOPND;
					valfloat1 = *(quad->opnd1.atr.simb->valfloat);break;
				case CARACTERE:
					tipo1 = CHAROPND;
					valchar1 = *(quad->opnd1.atr.simb->valchar);break;
				case LOGICO:
					tipo1 = LOGICOPND;
					vallogic1 = *(quad->opnd1.atr.simb->vallogic);
					break;
			}
			break;
		}
		opndaux = TopoOpnd(pilharet);
		DesempilharOpnd (&pilharet);
		switch (opndaux.atr.simb->tvar) {
		case INTEIRO:
			if (tipo1 == INTOPND)  *(opndaux.atr.simb->valint) = valint1;
			if (tipo1 == CHAROPND) *(opndaux.atr.simb->valint) = valchar1;
			break;
		case CARACTERE:
			if (tipo1 == INTOPND) *(opndaux.atr.simb->valchar) = valint1;
			if (tipo1 == CHAROPND) *(opndaux.atr.simb->valchar) = valchar1;
			break;
		case LOGICO:  *(opndaux.atr.simb->vallogic) = vallogic1; break;
		case REAL:
			if (tipo1 == INTOPND)
				*(opndaux.atr.simb->valfloat) = valint1;
			if (tipo1 == REALOPND)
				*(opndaux.atr.simb->valfloat) = valfloat1;
			if (tipo1 == CHAROPND)
				*(opndaux.atr.simb->valfloat) = valchar1;
			break;
		}
	}
}

void ExecQuadCall (quadrupla quad) {
	int tipo1, valint1;
	float valfloat1;
	char valchar1, vallogic1;
	int i;  operando opndaux;  pilhaoperando pilhaopndaux;
	pontelemlistsimb pontparam;
	InicPilhaOpnd (&pilhaopndaux);
	for (i = 1; i <= quad->opnd2.atr.valint; i++) {
		EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
		DesempilharOpnd (&pilhaopnd);
	}
	
	pontparam = quad->opnd1.atr.modulo->listparam->prox;
	
	for (i = 1; i <= quad->opnd2.atr.valint; i++) {
		opndaux = TopoOpnd (pilhaopndaux);
		DesempilharOpnd (&pilhaopndaux);
		switch (opndaux.tipo) {
			case INTOPND:
				tipo1 = INTOPND;
				valint1 = opndaux.atr.valint; break;
			case REALOPND:
				tipo1 = REALOPND;
				valfloat1 = opndaux.atr.valfloat; break;
			case CHAROPND:
				tipo1 = CHAROPND;
				valchar1 = opndaux.atr.valchar; break;
			case LOGICOPND:
				tipo1 = LOGICOPND;
				vallogic1 = opndaux.atr.vallogic; break;
			case VAROPND:
				switch (opndaux.atr.simb->tvar) {
					case INTEIRO:
						tipo1 = INTOPND;
						valint1 = *(opndaux.atr.simb->valint); break;
					case REAL:
						tipo1 = REALOPND;
						valfloat1 = *(opndaux.atr.simb->valfloat);break;
					case CARACTERE:
						tipo1 = CHAROPND;
						valchar1 = *(opndaux.atr.simb->valchar);break;
					case LOGICO:
						tipo1 = LOGICOPND;
						vallogic1 = *(opndaux.atr.simb->vallogic);
						break;
				}
				break;
		}
		switch (pontparam->simb->tvar) {
			case INTEIRO:
				if (tipo1 == INTOPND)  *(pontparam->simb->valint) = valint1;
				if (tipo1 == CHAROPND) *(pontparam->simb->valint) = valchar1;
				break;
			case CARACTERE:
				if (tipo1 == INTOPND) *(pontparam->simb->valchar) = valint1;
				if (tipo1==CHAROPND) *(pontparam->simb->valchar)= valchar1;
				break;
			case LOGICO:  *(pontparam->simb->vallogic) = vallogic1; break;
			case REAL:
				if (tipo1 == INTOPND)
					*(pontparam->simb->valfloat) = valint1;
				if (tipo1 == REALOPND)
					*(pontparam->simb->valfloat) = valfloat1;
				if (tipo1 == CHAROPND)
					*(pontparam->simb->valfloat) = valchar1;
				break;
		}
		pontparam = pontparam->prox;
	}
}
