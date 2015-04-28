-module (mylists).
-export ([member/2]).

member(H,[H1|_]) when H == H1 	-> true;
member(H, [_|T])				->	member(H, T);
member(H,[])					->	false.