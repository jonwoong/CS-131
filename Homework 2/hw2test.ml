(* convert_grammar test *)

type myGrammar_nonterminals = | Number | Word | Operation;;

let myGrammar_rules = 
	[
	Number, [T "1"];
	Number, [T "2"];
	Number, [T "3"];
	Word, [T "hello"];
	Word, [N Word];
	Operation, [T "*"];
	Operation, [T "+"]
	];;

let convert_grammar_test_1 = ((snd (convert_grammar (Number, myGrammar_rules))) Number = [[T"1"];[T"2"];[T"3"]]);;
let convert_grammar_test_2 = ((snd (convert_grammar (Number, myGrammar_rules))) Word = [[T"hello"];[N Word]]);;
let convert_grammar_test_3 = ((snd (convert_grammar (Number, myGrammar_rules))) Operation = [[T"*"];[T"+"]]);;

(* parse_prefix test *)

let accept_all derivation string = Some (derivation, string);;
let accept_empty_suffix derivation = function
	| [] -> Some (derivation, [])
	| _ -> None;;

type myNewGrammar_nonterminals = | Expr | Else;;

let myNewGrammar = (Expr, function 
	| Expr -> [
		[T "if"; N Expr; T "then"; N Expr; T "else"; N Expr];
		[T "if"; N Expr; T "then"; N Expr];
		[N Else];
		[T "true"];
		[T "false"]
		]
	| Else -> [[T "else"; N Else]]
);;

let test_1 = ((parse_prefix myNewGrammar accept_all [
	"if";"true";"then";"false";"else";"true"]) = Some ([
		(Expr, [T "if"; N Expr; T "then"; N Expr; T "else"; N Expr]);
		(Expr, [T "true"]);
		(Expr, [T "false"]);
		(Expr, [T "true"])
	],[]));;

let test_2 = ((parse_prefix myNewGrammar accept_all [
	"if";"true";"then";"if";"true";"then";"false"]) = Some ([
		(Expr, [T "if"; N Expr; T "then"; N Expr]);
		(Expr, [T "true"]);
		(Expr, [T "if"; N Expr; T "then"; N Expr]);
		(Expr, [T "true"]);
		(Expr, [T "false"])
	],[]));;