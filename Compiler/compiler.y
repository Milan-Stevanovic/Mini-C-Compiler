%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "defs.h"
	#include "symtab.h"
	#include "codegen.h"
	#define MAX_PARAMS 64

	int yyparse(void);
	int yylex(void);
	int yyerror(char *s);
	void warning(char *s);

	struct params{
		unsigned id;
		unsigned types[MAX_PARAMS];
	};

	extern int yylineno;
	int out_lin = 0;
	char char_buffer[CHAR_BUFFER_LENGTH];
	int error_count = 0;
	int warning_count = 0;
	
	int var_num = 0;
	int fun_idx = -1;
	int fcall_idx = -1;
	int lab_num = -1;
	int con_num = -1;
	int pwr_num = -1;
	int branch_num = -1;
	int haihou_hiki_num = -1;
	int max_hh = -1;
	int brojac_ugnjezdenih = 0;
	
  	FILE *output;

	// Pomocna promenljiva za vars
	int var_type = -1; 
	
	// Pomocna promeljiva za return_statement
	bool funReturn = FALSE;
	
	// Pomocne promenljive za vise parametara
	int numOfIntParams  = 0;
	int numOfUIntParams = 0;
	
	struct params paramsArray[MAX_PARAMS];
	int br = 0;
	int paramsBr = 0;
	
	int argNum = 0;
	unsigned argType = 0;
	
	// stack je obrnut
	int ArgsArray[MAX_PARAMS];
	void pushAllArgs();
%}

%union {
	int i;
	char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token _COLON
%token _QMARK
%token <i> _RELOP

%token _POWER

%token _COMMA
%token _INCR;

%token _PERCENT
%token _HAIHOU
%token _HIKI

%token _BRANCH
%token _ONE
%token _TWO
%token _THREE
%token _OTHER
%token _ARROW
%token _END_BRANCH

%token _ADD
%token _SUB
%token _MUL
%token _DIV
%token _PWR

%type <i> num_exp exp literal function_call argument args rel_exp increment void_function_call if_part condition con_exp

%nonassoc ONLY_IF
%nonassoc _ELSE

%left _ADD _SUB
%left _MUL _DIV
%left PRIORITY
%right _PWR

%%

program
  : global_list function_list
      {  
          if(lookup_symbol("main", FUN) == NO_INDEX)
              err("Function [main] was never declared!");
      }
  ;

global_list
  : /*empty*/
  | global_list global_var
  ;
  
global_var
  : _TYPE _ID _SEMICOLON
    {
    	int idx = lookup_symbol($2, GVAR);
    	if(idx != NO_INDEX)
    	{
    		err("Redefinition of [%s]", $2);
    	}
    	else
    	{
    		insert_symbol($2, GVAR, $1, NO_ATR, NO_ATR, NO_ATR, NO_ATR);
    		code("\n%s:\n\t\tWORD\t1", $2);
    	}
    }
  ;

function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
      {
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
        {
            fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR, NO_ATR, NO_ATR);
            paramsArray[br].id = fun_idx;
        }
        else 
            err("Function [%s] is already defined!", $2);
            
            code("\n%s:", $2);
			code("\n\t\tPUSH\t%%14");
			code("\n\t\tMOV \t%%15,%%14");
      }
    _LPAREN parameter _RPAREN body
      {
      	if(funReturn == FALSE && $1 != VOID)
      		warn("Function [%s] must have return statement!", $2);

		//print_symtab();
        clear_symbols(fun_idx + 1);
        br++;
        paramsBr = 0;
        var_num = 0;
        funReturn = FALSE;
        numOfIntParams  = 0;
        numOfUIntParams = 0;
        
        code("\n@%s_exit:", $2);
        code("\n\t\tMOV \t%%14,%%15");
        code("\n\t\tPOP \t%%14");
        code("\n\t\tRET");
      }
  ;

parameter
  : /* empty */
      { 
      	set_atr1(fun_idx, 0);
      	set_atr3(fun_idx, 0);
      }
  | pars
  ;
  
pars
  : _TYPE _ID
      {
      	if($1 == VOID)
      		err("Parameter [%s] cannot be VOID type!", $2);
      	if(lookup_symbol($2, PAR) == NO_INDEX)
      	{
      		if($1 == INT)
      		{
      			paramsArray[br].types[paramsBr] = $1;
      			insert_symbol($2, PAR, $1, ++numOfIntParams + numOfUIntParams, NO_ATR, NO_ATR, NO_ATR);
      			set_atr1(fun_idx, numOfIntParams);
      			set_atr2(fun_idx, $1);
      		}
      		else if($1 == UINT)
      		{
      			paramsArray[br].types[paramsBr] = $1;
      			insert_symbol($2, PAR, $1, ++numOfUIntParams + numOfIntParams, NO_ATR, NO_ATR, NO_ATR);
      			set_atr3(fun_idx, numOfUIntParams);
      			set_atr4(fun_idx, $1);
      		}
      		paramsBr++;
      	}
      	else
      		err("Parameter [%s] is already defined in function!", $2);
	   }
  
  | pars _COMMA _TYPE _ID
      {
  	  	if($3 == VOID)
  	  		err("Parameter [%s] cannot be VOID type!", $4);
  	  	if(lookup_symbol($4, PAR) == NO_INDEX)
  	  	{
  	  		if($3 == INT)
      		{
      			paramsArray[br].types[paramsBr] = $3;
      			insert_symbol($4, PAR, $3, ++numOfIntParams + numOfUIntParams, NO_ATR, NO_ATR, NO_ATR);
      			set_atr1(fun_idx, numOfIntParams);
      			set_atr2(fun_idx, $3);
      		}
      		else if($3 == UINT)
      		{
      			paramsArray[br].types[paramsBr] = $3;
      			insert_symbol($4, PAR, $3, ++numOfUIntParams + numOfIntParams, NO_ATR, NO_ATR, NO_ATR);
      			set_atr3(fun_idx, numOfUIntParams);
      			set_atr4(fun_idx, $3);
      		}
      		paramsBr++;
  	  	}
  	  	else
  	  		err("Parameter [%s] is already defined in function!", $4);
  	  }
  ;

body
  : _LBRACKET variable_list 
  	  {
        if(var_num)
          code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
        code("\n@%s_body:", get_name(fun_idx));
      }
    statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

vars
  : _ID
     {
     	if(var_type == VOID)
     	   err("Variable [%s] cannot be VOID type!", $1);
     	else if(lookup_symbol($1, VAR|PAR) == NO_INDEX)
           insert_symbol($1, VAR, var_type, ++var_num, NO_ATR, NO_ATR, NO_ATR);
        else 
           err("Variable [%s] is already defined!", $1);
      }
  | vars _COMMA _ID
      {
        if(var_type == VOID)
     	   err("Variable [%s] cannot be VOID type!", $3);
     	else if(lookup_symbol($3, VAR|PAR) == NO_INDEX)
           insert_symbol($3, VAR, var_type, ++var_num, NO_ATR, NO_ATR, NO_ATR);
        else 
           err("Variable [%s] is already defined!", $3);
      }
  ;

variable
  : _TYPE { var_type = $1; } vars _SEMICOLON
  ;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | if_statement
  | increment_statement
  | return_statement
  | haihou_hiki_statement
  | branch_statement
  | void_function_call
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR|GVAR);
        if(idx == NO_INDEX)
          err("Invalid lvalue [%s] in assignment!", $1);
        else
          if(get_type(idx) != get_type($3))
            err("Incompatible types in assignment!");
		
        gen_mov($3, idx);
      }
  ;

num_exp
  : exp { $$ = $1; }
  ;

exp
  : literal
  | _ID
	  {
	    $$ = lookup_symbol($1, VAR|PAR|GVAR);
	    if($$ == NO_INDEX)
	    	err("[%s] undeclared", $1);
	  }
  | function_call
      {
      	$$ = take_reg();
      	gen_mov(FUN_REG, $$);
      }
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
  | increment
  	  { 
		int t1=get_type($1);
		$$ = take_reg();
		    set_type($$, t1);
		gen_mov($1, $$);
		if(t1 == INT)
			code("\n\t\tADDS\t");
		else
			code("\n\t\tADDU\t");
		gen_sym_name($1);
		code(", $1, ");
        gen_sym_name($1);
        free_if_reg($1);
  	  }
  | condition
  	{ $$ = $1; }
  | exp _ADD exp
      {		
        if(get_type($1) != get_type($3))
          err("Invalid operands: arithmetic operation!");
        int t1 = get_type($1);  
        if(get_type($1) == INT)
			code("\n\t\tADDS\t");
		else
			code("\n\t\tADDU\t");
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
      }
  | exp _SUB exp
      {		
        if(get_type($1) != get_type($3))
          err("Invalid operands: arithmetic operation!");
        int t1 = get_type($1);  
        if(get_type($1) == INT)
			code("\n\t\tSUBS\t");
		else
			code("\n\t\tSUBU\t");
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
      }
  | exp _MUL exp
      {		
        if(get_type($1) != get_type($3))
          err("Invalid operands: arithmetic operation!");
        int t1 = get_type($1);  
        if(get_type($1) == INT)
			code("\n\t\tMULS\t");
		else
			code("\n\t\tMULU\t");
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
      }
  | exp _DIV exp
      {		
        if(get_type($1) != get_type($3))
          err("Invalid operands: arithmetic operation!");
        int t1 = get_type($1);  
        if(get_type($1) == INT)
			code("\n\t\tDIVS\t");
		else
			code("\n\t\tDIVU\t");
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
      }
  | _SUB exp %prec PRIORITY
  	  { 
  	  	int t1 = get_type($2);  
        int pom_reg = take_reg();
        set_type(pom_reg, t1);
        if(t1 == INT)
            code("\n\t\tSUBS\t");
        else
            code("\n\t\tSUBU\t");
        gen_sym_name(pom_reg);
        code(" , ");
        gen_sym_name(pom_reg);
        code(" , ");
        gen_sym_name(pom_reg);
        if(t1 == INT)
            code("\n\t\tSUBS\t");
        else
            code("\n\t\tSUBU\t");
        gen_sym_name(pom_reg);
        code(",");
        gen_sym_name($2);
        code(",");
        free_if_reg($2);
        $$ = pom_reg;
        gen_sym_name($$);
  	  }
  | exp _PWR exp
      {
      	if(get_type($1) != get_type($3))
          err("Invalid operands: arithmetic operation!");
        int t1 = get_type($1);  
        int reg_rez = take_reg();
        int brojac = take_reg();
        gen_mov($1, reg_rez);
        gen_mov($3, brojac);
        ++pwr_num;
        // PROVERA DA LI JE STEPEN NULA
        if(get_type($3) == INT)
			code("\n\t\tCMPS\t");
		else
			code("\n\t\tCMPU\t");
        gen_sym_name(brojac);
        code(", $0");
        code("\n\t\tJEQ\t@pow_zero%d", pwr_num);
        code("\n\t\tJMP\t@pow_loop%d", pwr_num);
        
        // KOD KOJI SE GENERISE AKO JE SEPEN NULA
        code("\n@pow_zero%d:", pwr_num);
		if(get_type($3) == INT)
			code("\n\t\tMOV\t");
		else
			code("\n\t\tMOV\t");
		code("$1, ");
		gen_sym_name(reg_rez);
        code("\n\t\tJMP\t@pow_exit%d", pwr_num);
        
        // LOOP ZA STEPENOVANJE
        code("\n@pow_loop%d:", pwr_num);
        if(get_type($3) == INT)
			code("\n\t\tSUBS\t");
		else
			code("\n\t\tSUBU\t");
		gen_sym_name(brojac);
		code(", $1, ");
		gen_sym_name(brojac);
		
		
        if(get_type($1) == INT)
			code("\n\t\tCMPS\t");
		else
			code("\n\t\tCMPU\t");
        gen_sym_name(brojac);
        code(", $0");
        code("\n\t\tJEQ\t@pow_exit%d", pwr_num);
        
        if(get_type($1) == INT)
			code("\n\t\tMULS\t");
		else
			code("\n\t\tMULU\t");
        gen_sym_name($1);
        code(",");
        gen_sym_name(reg_rez);
        code(",");
        gen_sym_name(reg_rez);
        
        
        code("\n\t\tJMP\t@pow_loop%d", pwr_num);
        code("\n@pow_exit%d:", pwr_num);
        free_if_reg($3);
        free_if_reg($1);
        free_if_reg(brojac);
        $$ = reg_rez;
        set_type(reg_rez, t1);
      }
  ;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

void_function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("[%s] is not a function", $1);
        if(get_type(fcall_idx) != VOID)
          err("Function [%s] is not VOID type!", $1);
      }
    _LPAREN argument _RPAREN _SEMICOLON
      {
        if((get_atr1(fcall_idx) + get_atr3(fcall_idx)) != $4)
          err("Function [%s] has wrong number of parameters", get_name(fcall_idx));
        code("\n\t\t\tCALL\t%s", get_name(fcall_idx));
        if($4 > 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $4 * 4);
    	set_type(FUN_REG, get_type(fcall_idx));
    	$$ = FUN_REG;
    	argNum = 0;
      }
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("[%s] is not a function", $1);
      }
    _LPAREN argument _RPAREN
      {
          if((get_atr1(fcall_idx) + get_atr3(fcall_idx)) != $4)
              err("Function [%s] has wrong number of parameters", get_name(fcall_idx));
          code("\n\t\t\tCALL\t%s", get_name(fcall_idx));
          if($4 > 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $4 * 4);
    	  set_type(FUN_REG, get_type(fcall_idx));
    	  $$ = FUN_REG;
    	  argNum = 0;
      }
  ;

argument
  : /* empty */
    { $$ = 0; }
  | args
    {
      $$ = $1;
      // FUNKCIJA ZA PUSHOVANJE SVIH ARGUMENATA NA STACK U PRAVOM REDOSLEDU
      pushAllArgs();
    }
  ;

args
  : num_exp
    {
    	// KOD ZA PROVERU REDOSLEDA AGUMENATA U POZIVU FUNKCIJE
        argType = get_type($1);
        for(int i = 0; i < get_last_element(); i++)
        {
	  	    if(fcall_idx == paramsArray[i].id)
	  	    {
	  	        if(paramsArray[i].types[argNum] == argType)
	  	        {
	  	        
	  	        }
	  	        else
	  	            err("Wrong order of arguments in fucntion call [%s]", get_name(fcall_idx));
	  	    }
        }
        free_if_reg($1);
        ArgsArray[argNum] = $1; // insert parameter in array (later reverse push in function)
        argNum++;
        
        if(get_type($1) == INT)
        {
		    if(get_atr2(fcall_idx) != get_type($1))
		        err("Incompatible type for argument in [%s]", get_name(fcall_idx));
        }
        else
        {
		    if(get_atr4(fcall_idx) != get_type($1))
		        err("Incompatible type for argument in [%s]", get_name(fcall_idx));
        }
        $$ = argNum;
    }
  | argument _COMMA num_exp
  	{
  		// KOD ZA PROVERU REDOSLEDA AGUMENATA U POZIVU FUNKCIJE
  	    argType = get_type($3);
        for(int i = 0; i < get_last_element(); i++)
        {
	        if(fcall_idx == paramsArray[i].id)
	  	    {
	  	        if(paramsArray[i].types[argNum] == argType)
	  	        {
	  	        
	  	        }
	  	        else
	  	            err("Wrong order of arguments in fucntion call [%s]", get_name(fcall_idx));
	  	    }
        }
        free_if_reg($3);
        ArgsArray[argNum] = $3; // insert parameter in array (later reverse push in function)
        argNum++;
        $$ = argNum;
  	}
  ;

if_statement
  : if_part %prec ONLY_IF
  		{ code("\n@exit%d:", $1); }
  | if_part _ELSE statement
  		{ code("\n@exit%d:", $1); }
  ;

if_part
  : _IF _LPAREN 
  		{
		    $<i>$ = ++lab_num;
		    code("\n@if%d:", lab_num);
        }
    rel_exp 
    	{
		    code("\n\t\t%s\t@false%d", opp_jumps[$4], $<i>3); 
		    code("\n@true%d:", $<i>3);
        }
  
    _RPAREN statement
    	{
		    code("\n\t\tJMP \t@exit%d", $<i>3);
		    code("\n@false%d:", $<i>3);
		    $$ = $<i>3;
        }
  ;

rel_exp
  : num_exp _RELOP num_exp
      {
        if(get_type($1) != get_type($3))
          err("Invalid operands: relational operator!");
        $$ = $2 + ((get_type($1) - 1) * RELOP_NUMBER);
		
        gen_cmp($1, $3);
      }
  ;

return_statement
  : _RETURN { funReturn = TRUE; } _SEMICOLON
  	  {
  	  	  if(get_type(fun_idx) != VOID)
  	          warn("Function [%s] must have return statement!", get_name(fun_idx));
  	  }
  | _RETURN { funReturn = TRUE; } num_exp _SEMICOLON
      {
      	  if(get_type(fun_idx) == VOID)
      	      err("Void function [%s] cannot have return statement!", get_name(fun_idx));
          if(get_type(fun_idx) != get_type($3))
              err("Incompatible types in return!");

          gen_mov($3, FUN_REG);
          code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));
      }
  ;
  
condition
  : _LPAREN rel_exp _RPAREN _QMARK 
  		{
	  		++con_num;
			code("\n\t\t%s\t@con_false%d", opp_jumps[$2], con_num); 
			code("\n@con_true%d:", con_num);
	  	}  
    con_exp _COLON con_exp
		{
			if(get_type($6) != get_type($8))
				err("Operands must be the same type!");
			
			int reg = take_reg();

            gen_mov($6, reg);
            code("\n\t\tJMP \t@con_exit%d", con_num);

            code("\n@con_false%d:", con_num);
            gen_mov($8, reg);

            $$ = reg;
            code("\n@con_exit%d:", con_num);
		}
  ;

/* NOVO PRAVILO ZA USLOVNI IZRAZ
   (IZRAZ MOZE DA BUDE SAMO PROMENLJIVA ILI LITERAL) */
con_exp
  : literal
  | _ID 
  	{
  		int index = lookup_symbol($1, VAR|PAR|GVAR);
  		if(index == NO_INDEX)
  			err("Operand not defined!");
  		$$ = index;
  	}
  ;
  
increment_statement
  : increment _SEMICOLON
	  {
		if(get_type($1) == INT)
			code("\n\t\tADDS\t");
		else
			code("\n\t\tADDU\t");
		gen_sym_name($1);
		code(", $1, ");
		gen_sym_name($1);
		free_if_reg($1);
	  }
  ;
  
increment
  : _ID _INCR
     {
     	if(lookup_symbol($1, FUN) != NO_INDEX)
			err("Function [%s] cannot be incremented!", $1);
		else if(lookup_symbol($1, VAR|PAR|GVAR) == NO_INDEX)
			err("Variable [%s] is not declared!", $1);

		$$ = lookup_symbol($1, VAR|PAR|GVAR);
     }
  ;

haihou_hiki_statement
  : _PERCENT _HAIHOU _PERCENT 
	  	{
	  		// LOGIKA ZA ISPIS REDNOG BROJA LABELE
	  		// ZBOG UGNJEZDENOG HAIHOU-HIKI IZRAZA
	  		++haihou_hiki_num;
	  		if(haihou_hiki_num > max_hh)
	  			max_hh = haihou_hiki_num;
  			++brojac_ugnjezdenih;
	  		code("\n@haihou_hiki_body%d:", haihou_hiki_num);
	  	}
    statement_list _PERCENT _HIKI
  		{
  			code("\n@haihou_hiki_cond%d:", haihou_hiki_num);
  		}
    rel_exp _PERCENT _SEMICOLON
  		{  			
  			code("\n\t\t%s\t@haihou_hiki_false%d", opp_jumps[$9], haihou_hiki_num); 
  			code("\n\t\t%s\t@haihou_hiki_body%d", jumps[$9], haihou_hiki_num); 
  			code("\n@haihou_hiki_false%d:", haihou_hiki_num);
  			code("\n@haihou_hiki_exit%d:", haihou_hiki_num);
  			if(--brojac_ugnjezdenih)
  				--haihou_hiki_num;
  			else
  				haihou_hiki_num = max_hh;
  		}
  ;

branch_statement
  : _BRANCH _LPAREN _ID _SEMICOLON literal _COMMA literal _COMMA literal _RPAREN
  		{
  			int index = lookup_symbol($3, VAR|PAR|GVAR);
  			if(index == NO_INDEX)
  				err("(BRANCH) Variable [%s] must be declared first!", $3);
  			else
  			{
	  			int branch_var_type = get_type(lookup_symbol($3, VAR|PAR));
	  			if(branch_var_type != get_type($5) || branch_var_type != get_type($7) || branch_var_type != get_type($9))
	  				err("(BRANCH) Incompatible types in branch statement!");
	  			
	  			++branch_num;
	  			code("\n@branch%d:", branch_num);
	  			
	  			gen_cmp(index, $5);
	  			code("\n\t\tJEQ\t@one%d", branch_num);
	  			
	  			gen_cmp(index, $7);
	  			code("\n\t\tJEQ\t@two%d", branch_num);
	  			
	  			gen_cmp(index, $9);
	  			code("\n\t\tJEQ\t@three%d", branch_num);
	  			
	  			code("\n\t\tJMP\t@other%d", branch_num);
  			}
  		}
  	_ONE _ARROW   { code("\n@one%d:", branch_num); }
  	statement 	  { code("\n\t\tJMP\t@branch_end%d", branch_num); }
  	_TWO _ARROW   { code("\n@two%d:", branch_num); }
  	statement     { code("\n\t\tJMP\t@branch_end%d", branch_num); }
  	_THREE _ARROW { code("\n@three%d:", branch_num); }
  	statement     { code("\n\t\tJMP\t@branch_end%d", branch_num); }
  	_OTHER _ARROW { code("\n@other%d:", branch_num); }
  	statement
  	_END_BRANCH   { code("\n@branch_end%d:", branch_num); }
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nLINE : %d, [ERROR] [%s]", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nLINE : %d, [WARNING] [%s]", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();

  output = fopen("output.asm", "w+");	

  synerr = yyparse();
  
  // TEST - PRINT POMOCNE STRUKTURE ZA DOBAR REDOSLED PARAMETARA U FUNKCIJI   
  /*print_symtab();

  printf("ID | PARAMS\n");
  printf("---  --------\n");
  for(int i = 0; i < br; i++)
  {
  	printf("%u   ", paramsArray[i].id);
  	for(int j = 0; j < MAX_PARAMS; j++)
  	{	if(paramsArray[i].types[j] == 0)
  			break;
  		printf("%u ", paramsArray[i].types[j]);
  	}
  	printf("\n");
  }
  */
  
  clear_symtab();
  fclose(output);
  
  if(warning_count)
    printf("\n%d WARNING(S).\n", warning_count);

  if(error_count)
  {
    remove("output.asm");
    printf("\n%d ERROR(S).\n", error_count);
  }
  
  if(synerr)
    return -1;  //syntax error
  else if(error_count)
    return error_count & 127; //semantic errors
  else if(warning_count)
    return (warning_count & 127) + 127; //warnings
  else
    return 0; //OK
}

/* FUNKCIJA KOJA PUSH-UJE PROSLEDJENE ARGUMENTE U 
OBRNUTOM REDOSLEDU ZBOG (LIFO) STACK STRUKTURE */
void pushAllArgs()
{
	for(int i = argNum; i >= 0; i--)
	{
        code("\n\t\t\tPUSH\t");
        gen_sym_name(ArgsArray[i]);
	}
}
