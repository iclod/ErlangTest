
-module(five).
-export ([match/2]).
		


%	匹配成功，返回处理后的值，失败返回匹配B值
match( {Nam,ValA}, {Nam,ValB} )  ->
	{ true, {Nam,ValA+ValB} } ;
match( _, Th )  ->
	{ false, Th }.

%	对一个元素进行匹配，成功就OK了



















