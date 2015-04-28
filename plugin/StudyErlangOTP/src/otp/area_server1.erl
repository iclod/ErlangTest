%% @author IcLod
%% @doc @todo Add description to area_server1.


-module(area_server1).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

%%	code:purge(area_server1),code:load_file(area_server1)
%%	code:load_file(area_server1)
%%	Pid = spawn(area_server1,loop,[])
%%	area_server1:rpc(Pid,{rectangle,6,8})
%%	area_server1:rpc(Pid,{circle,6})
rpc(Pid, Request)	->
	Pid ! {self(), Request},
	receive
		{Pid,Response}	->
			io:format("rpc:~p~n",[self()]),
			Response
	end.
loop()	->
	receive
		{From, {rectangle, Width, Ht} }	->
			From ! {self(), Width*Ht},
			io:format("loop:~p~n",[self()]),
			loop();
		{From, {circle, R} }	->
			From ! {self(), 3.14159 * R * R},
			io:format("loop:~p~n",[self()]),
			loop();
		{From, Other}	->
			From ! {error, {self(), Other}},
			io:format("loop:~p~n",[self()]),
			loop()
	end.

kk()	->
	io:format("hello~n").

%% ====================================================================
%% Internal functions
%% ====================================================================


