type ('nonterminal, 'terminal) symbol = N of 'nonterminal | T of 'terminal;;

let rec convert_grammar gram1 = 
	let rec buildRules ruleList someType = match ruleList with
		| [] -> []
		| h::t -> 
			(* Expr match Expr, Lvalue match Lvalue, etc. *)
			if (fst h) = someType
			then (snd h)::(buildRules t someType)
			else buildRules t someType
	in match gram1 with 
		| (startSymbol,rules) -> (startSymbol, (fun aType -> (buildRules rules aType)));;

(* Seunghyun's "AND matchers"*)
let rec appendMatchers ruleList rule acceptor derivation fragment = 
	(* sym -> [rule;...;rule] *)
  	match rule with 
	    | rHead :: rTail -> (
	        match rHead with 
	          | T(terminal) -> (
	            (* check if fragment matches this terminal rule *)
	              match fragment with 
	                | [] -> None
	                | fHead :: fTail -> (
	                  	(* element of fragment matches a rule *)
	                    if (fHead = terminal) 
	                    (* check next rule and next fragment *)
	                    then (appendMatchers ruleList rTail acceptor derivation fTail) 
	                    else None )
	            )
	            (* branch to another level and call appendMatchers on lower level elements *)
	          | N(nonterminal) -> (orMatchers ruleList (ruleList nonterminal) nonterminal (appendMatchers ruleList rTail acceptor) fragment derivation) 
	      )
	    | [] -> acceptor derivation fragment

(* Seunghyun's "OR matchers" *)
(* when encountering a non-terminal rule, try to match possible fragments *)
and orMatchers ruleList matchedRules lhs acceptor fragment derivation = 
	(* non-terminal rules from appendMatchers *)
	match matchedRules with 
	    | rHead :: rTail -> (
	        match appendMatchers ruleList rHead acceptor (derivation @ [(lhs, rHead)]) fragment with
	        	(* acceptor returned none, so try next non-terminal *)
	          	| None -> (orMatchers ruleList rTail lhs acceptor fragment derivation)
	          	(* acceptor returned some (match) *)
	          	| something -> something
	      )
	    | [] -> None

let parse_prefix gram acceptor fragment = 
  match gram with
    | (startSymbol, rules) -> orMatchers rules (rules startSymbol) startSymbol acceptor fragment []