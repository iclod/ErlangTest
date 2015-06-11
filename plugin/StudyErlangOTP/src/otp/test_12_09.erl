%% @author IcLod
%% @doc @todo Add description to test_12_09.


-module(test_12_09).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

%% fun()-> io:format("test,hello~n") end
start(Atom,Fun ) ->
	Pid = spawn(Fun),
	register(Atom,Pid).

	  

%% ====================================================================
%% Internal functions
%% ====================================================================


