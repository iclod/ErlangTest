-module(friday).
-export ([test/0]).
-export ([my_reverse/1]).
-export ([flat_length/1]).



%	*****************************************
%	这个列表长度计算是包含子列表元素个数的
flat_length(L)	->
	flat_length(L,0).

flat_length( [A|L], N ) when is_list(A) ->
	flat_length(L, flat_length(A,N));
flat_length( [_A|L], N ) ->
	flat_length( L, N+1 );
flat_length( [], N) ->
	N.











%	***************************************
%	反转操作，由于Erlang里列表的特殊操作
%	只需要取列表元素，存列表元素就行了
%
my_reverse(T)	->
	my_reverse([],T).

my_reverse( A, [Th|T] ) ->
	my_reverse( [Th|A], T );
my_reverse( A, [])		->
	A.



%	**********************************************
%
%
f()->io:format("f()~n"),aa.
b()->io:format("b()~n"),bb.
c()->io:format("c()~n"),cc.

test() -> 	testa( f(), b(), c() ),
		io:format("test()~n").
testa(_F,_B,_C) ->	io:format("testa()~n").














