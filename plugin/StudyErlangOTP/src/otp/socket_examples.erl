%% @author IcLod
%% @doc @todo Add description to socket_examples.


-module(socket_examples).

%% ====================================================================
%% API functions
%% ====================================================================
-export([nano_get_url/0,start_nano_server/0,nano_client_eval/1]).
-export([start_parallel_server/0]).
nano_get_url() ->
	nano_get_url("www.baidu.com").

nano_get_url(Host) ->
	{ok, Socket} = gen_tcp:connect(Host, 80, [binary, {packet, 0}]),
	ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
	receive_data(Socket, []).

receive_data(Socket, SoFar) ->
	receive
		{tcp, Socket, Bin} ->
			receive_data(Socket, [Bin|SoFar]);
		{tcp_closed, Socket} ->
			list_to_binary(lists:reverse(SoFar))
	end.

start_nano_server() ->
	{ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4}, {reuseaddr, true}, {active, true}]),
 	%%  {ok, Socket} = gen_tcp:accept(Listen),
	%% 	gen_tcp:close(Listen),
	%% 	loop(Socket)
	%%loop(Socket)
	seq_loop(Listen).

seq_loop(Listen) ->
	{ok, Socket} = gen_tcp:accept(Listen),
	loop(Socket),
	seq_loop(Listen).
	
%%	=======================================================
start_parallel_server() ->
	io:format("server:~p~n",[self()]),
	{ok, Listen} = gen_tcp:listen(2222, [binary, {packet, 4}, {reuseaddr, true}, {active, true}]),
	spawn(fun() -> par_connect(Listen), io:format("server->spawn:~p~n",[self()]) end).

par_connect(Listen) ->
	io:format("par_connect:~p~n",[self()]),
	{ok, Socket} = gen_tcp:accept(Listen),
	spawn(fun() -> par_connect(Listen), io:format("server:~p~n",[self()]) end),
	loop(Socket).




loop(Socket) ->
	receive 
		{tcp, Socket, Bin} ->
			io:format("Server received binary = ~p~n", [Bin]),
			Str = binary_to_term(Bin),
			Reply = lib_misc:string2value(Str),
			io:format("Server replying = ~p~n", [Reply]),
			gen_tcp:send(Socket, term_to_binary(Reply)),
			loop(Socket);
		{tcp_closed, Socket} ->
			io:format("Server socket closed~n")
	end.

nano_client_eval(Str) ->
	{ok, Socket} = gen_tcp:connect("localhost", 2222, [binary, {packet, 4}]),
	ok = gen_tcp:send(Socket, term_to_binary(Str)),
	receive
		{tcp,Socket,Bin} ->
			io:format("Client received binary = ~p~n", [Bin]),
			Val = binary_to_term(Bin),
			io:format("Client result = ~p~n", [Val]),
			gen_tcp:close(Socket)
	end.
			

error_test() ->
	spawn(fun() -> error_test_server() end),
	lib_misc:sleep(2000),
	{ok, Socket} = gen_tcp:connect("localhost", 4321, [binary, {packet, 2}]),
	io:foramt("connected to:~p~n",[Socket]),
	receive
		Any ->
			io:format("Any=~p~n",[Any])
	end.
error_test_server() ->
	{ok, Listen} = gen_tcp:listen(4321, [binary, {packet, 2}]),
	{ok, Socket} = gen_tcp:accept(Listen),
	error_test_server_loop(Socket).
error_test_server_loop(Socket) ->
	receive
		{tcp, Socket, Data} ->
			io:format("reveive:~p~n", [Data]),
			_ = atom_to_list(Data),
			error_test_server_loop(Socket)
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================


