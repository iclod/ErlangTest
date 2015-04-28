%% @author IcLod
%% @doc @todo Add description to area_server_final.


-module(area_server_final).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

%%	code:purge(area_server1),code:load_file(area_server1)
%%	code:load_file(area_server1)
%%	Pid = spawn(area_server_final,start,[])
%%	Pid = area_server_final:start() 
%%	area_server_final:area(Pid, {rectangle ,10, 8})
%%	

start()	->
	spawn(area_server_final, loop, []).

area(Pid, What)	->
	rpc(Pid, What).

rpc(Pid, Request)	->
	Pid ! {self(), Request},
	receive
		{Pid, Response}	->
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



%% ====================================================================
%% Internal functions
%% ====================================================================


