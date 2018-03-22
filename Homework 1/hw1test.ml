let my_subset_test0 = subset [] []
let my_subset_test1 = subset [1] [1;2]
let my_subset_test2 = subset [1;2] [2;1]
let my_subset_test3 = not (subset [1;2] [1;3])

let my_equal_sets_test0 = equal_sets [] []
let my_equal_sets_test1 = equal_sets [1] [1;1;1]
let my_equal_sets_test2 = equal_sets [1;2] [2;1]
let my_equal_sets_test3 = not (equal_sets [1;2] [2;3])

let my_set_union_test0 = equal_sets (set_union [1] [1]) [1]
let my_set_union_test1 = equal_sets (set_union [0;1;2] [3;4;5]) [0;1;2;3;4;5]

let my_set_intersection_test0 = equal_sets (set_intersection [] []) []
let my_set_intersection_test1 = equal_sets (set_intersection [1] [1]) [1]
let my_set_intersection_test2 = equal_sets (set_intersection [0;1] [2;3]) []
let my_set_intersection_test3 = equal_sets (set_intersection [1;2;3] [2;3;4]) [3;2]

let my_set_diff_test0 = equal_sets (set_diff [] []) []
let my_set_diff_test1 = equal_sets (set_diff [0] [1]) [0]
let my_set_diff_test2 = equal_sets (set_diff [6;6;6] [1;2;6]) []
let my_set_diff_test3 = equal_sets (set_diff [1;2;3] [4;5;6]) [1;2;3]

let my_computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> 1. /. (sqrt x)) 2. = 1.

let my_computed_periodic_point_test0 = computed_periodic_point (=) (fun x -> (sin x)) 10000 0. = 0.

let while_away_test0 = equal_sets (while_away (( * ) 2) ((>) 10) 1) [1;2;4;8]
let while_away_test1 = equal_sets (while_away ((/) 2) ((>) 0) 12) []

let rle_decode_test0 = equal_sets (rle_decode [1,"b"; 2,"o"; 1,"t"; 1,"y"]) ["b";"o";"o";"t";"y"]
let rle_decode_test1 = equal_sets (rle_decode [0,"z"; 0,"y"; 5,"t"]) ["t";"t";"t";"t";"t"]

type someWeirdLanguage_nonterminals = 
	| A | B | C | D | E 

let someWeirdLanguage_grammar = 
	A,
	[B, [];
	 C, [T"hello"];
	 D, [T"there"];
	 E, [N C];
	 A, [N D]]

let someWeirdLanguage_test0 = filter_blind_alleys someWeirdLanguage_grammar = someWeirdLanguage_grammar
let someWeirdLanguage_test1 = filter_blind_alleys (A, List.tl (snd someWeirdLanguage_grammar)) = 
	(A, [C,[T"hello"]; D,[T"there"]; E,[N C]; A,[N D]])


