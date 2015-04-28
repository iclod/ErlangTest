
-module(one).
-export ([test5/2]).


%	******************************************************************************
%	------------------------------------------------------------------------------
%	习题 5
%	 	合并列表，A=[{a,1},{b,2},{c,3},{b,1}],B=[{b,4},{c,5},{d,6},{d,2}].
%			结果：[{a,1},{b,7},{c,8},{d,8}]
%		D=[{a,3},{f,14},{k,39},{f,22},{g,88},{d,23}].
%	把B列表合并到A列表，新增的放后面，不能用++
%	------------------------------------------------------------------------------


test5( A, B )  ->
	M = test5a_2( A,[] ),
	test5a_2( B, M ).

%	%	对待定列表的单元素进行判定操作等
test5a_1( E, [Th|T], F, R ) ->
	{Flag,V} = match(E ,Th),
	test5a_1( E, T, Flag or F, [V|R] );
test5a_1( E, [], F, R ) ->
	case F of
		true  ->
			R;
		false ->
			[E|R]
	end.

%	%	遍历待定列表，使其每个元素进行test5a_1操作 
test5a_2( [Th|T], R ) ->
	M = test5a_1( Th, R, false, [] ),
	Mr= lists:reverse(M),
	test5a_2( T, Mr ) ;
test5a_2( [], R ) ->
	R.


%	匹配成功，返回处理后的值，失败返回匹配B值
match( {Nam,ValA}, {Nam,ValB} )  ->
	{ true, {Nam,ValA+ValB} } ;
match( _, Th )  ->
	{ false, Th }.


	

% ****************************************************************
%	test5( A, B )  ->
%	
%		M = test5b( A,[] ),
%		test5b( B, M ).
%	
%	
%	
%	%	匹配成功，返回处理后的值，失败返回匹配B值
%	match( {Nam,ValA}, {Nam,ValB} )  ->
%		{ true, {Nam,ValA+ValB} } ;
%	match( _, Th )  ->
%		{ false, Th }.
%	
%	
%	%	对待定列表的单元素进行判定操作等
%	test5a( E, [Th|T], R )	->
%		{Flag, V} = match(E,Th),
%	%	io:format("match E=~p,Th=~p,V=~p,R=~p ~n",[E,Th,V,R]),
%		case Flag of
%			true  ->
%				test5a(  T, [V|R]  );
%			false ->
%				test5a( E, T, [V|R] )
%		end;
%	test5a( E, [], R ) -> 
%		[E|R].
%	%	添加B列表在A列表后
%	test5a(  [Th|T], R  ) ->
%	 	test5a( T, [Th|R] );
%	test5a( [], R ) ->
%		R.
%	%	遍历待定列表，使其每个元素进行test5a操作 
%	test5b( [Th|T], R ) ->
%		M = test5a( Th, R, [] ),
%		test5b( T, M );
%	test5b( [], R ) ->
%		R.
%	