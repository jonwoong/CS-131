type ('nt, 't) symbol = N of 'nt | T of 't

(* subset checks if set "a" is a subset of "b" *)
let rec subset a b = match a with 
	| [] -> true
	| head :: tail -> 
		if (List.mem head b)
		then (subset tail b)
		else false;;

(* equal_sets checks if set "a" equals set "b" *)
let rec equal_sets a b = match a with 
	| [] -> if (b = []) then true else false
	| head :: tail -> (subset a b) && (subset b a)

(* set_union performs aUb *)
let set_union a b = a@b;;

(* set_intersection performs a n b*)
let rec set_intersection a b = match a with 
	| [] -> []
	| head :: tail -> 
		if (List.mem head b) 
		then head :: (set_intersection tail b) 
		else set_intersection tail b;;

(* set_diff performs a - b *)
let rec set_diff a b = match a with 
	| [] -> []
	| head :: tail -> 
		if not (List.mem head b) 
		then head :: (set_diff tail b) 
		else set_diff tail b;;

(* computed_fixed_point finds fixed point for f x *)
let rec computed_fixed_point eq f x =  
	if (eq x (f@@x))
	then x
	else (computed_fixed_point eq f (f@@x));;

(* HELPER FUNCTION: computed_point finds the value returned after p periods *)
let rec computed_point f p x = 
	if (p == 0)
	then x
	else (computed_point f (p-1) (f@@x));;

(* computed_periodic_point finds periodic point for f x *)
let rec computed_periodic_point eq f p x = 
	if (eq x (computed_point f p x))
	then x
	else (computed_periodic_point eq f p (f@@x));;

(* while_away returns the longest list of values where p e is true *)
let rec while_away s p x = 
	if (p@@x)
	then x::(while_away s p (s@@x))
 	else []

(* HELPER FUNCTION: repeat_char repeats char c for i many times *)
 let rec repeat_char i c = 
 	if (i > 0)
 	then c::(repeat_char (i-1) c)
 	else [];;

 (* rle_decode returns a list from an (int,char) pair *)
 let rle_decode lp = 
 	let rec repeat lihst n c = 
 		if n = 0 
 		then lihst
 		else repeat (c :: lihst) (n-1) c in 
 	let rec build lihst = function 
 		| [] -> lihst
 		| (n, c)::t -> build (repeat lihst n c) t in 
 	build [] (List.rev lp);;

(* HELPER FUNCTION: is_rule checks each element in the list of rules for correct syntax *)
let rec is_rule generalType ruleList = match ruleList with 
	| [] -> false
	| (symbolType,symbolDefinition)::tail -> 
		if generalType = symbolType;
		then true 
		else is_rule generalType tail;;

(* get_terminal_rules builds a list of knownTerminalSymbols given a grammar *)
let rec get_terminal_rules grammar knownTerminalSymbols = 
	(* HELPER FUNCTION: is_terminal_symbol checks whether a symbol is terminal *)
	let is_terminal_symbol symbolInQuestion restOfSymbols = match symbolInQuestion with
		| T symbolInQuestion -> true
		(* if the expression is "N expr" then check whether expr is a terminal symbol or whether expr is a rule containing terminal symbols *)
		| N symbolInQuestion -> List.mem symbolInQuestion knownTerminalSymbols || is_rule symbolInQuestion (get_terminal_rules restOfSymbols knownTerminalSymbols) in

	(* HELPER FUNCTION: is_terminal_rule checks whether a rule contains only terminal symbols or not *)
	let rec is_terminal_rule rule wholeExpression = match rule with 
		| [] -> true
		(* if the rule is a list, check whether each element is a terminal symbol *)
		| head :: tail -> 
			if (is_terminal_symbol head wholeExpression)
			then (is_terminal_rule tail wholeExpression)
			else false in 

	(* check whether symbolDefinition is a terminal rule, if it is, add the rule to the beginning of the list *)
	(* and collect all terminal symbols associated with symbolDefinition *)
	(* if symbolDefinition is not a terminal rule, check the next rule *)
	match grammar with 
		| [] -> grammar 
		| (symbolType,symbolDefinition) :: tail ->
			if (is_terminal_rule symbolDefinition tail)
			then (symbolType,symbolDefinition)::(get_terminal_rules tail (symbolType::knownTerminalSymbols))
			else (get_terminal_rules tail knownTerminalSymbols);;

(* filter_blind_alleys returns all terminal rules of a given grammar *)
let rec filter_blind_alleys g = match g with 
	| (startSymbol,rules) -> (startSymbol, get_terminal_rules rules []);;
 		