%% @author IcLod
%% @doc @todo Add description to server1.


%% ====================================================================
%% Head
%% ====================================================================
-module(server1).
-export([start/2, rpc/2]).
%% ====================================================================
%% define
%% ====================================================================


%% ====================================================================
%% API functions
%% ====================================================================
start(Name, Mod) ->
	register(Name, spawn(fun() -> loop(Name, Mod, Mod:init()) end)).

rpc(Name, Request) ->
	Name ! {self(), Request},
	receive
		{Name, Response} -> Response
	end.

loop(Name, Mod, State) ->
	receive
		{From, Request} ->
			{Response, State1} = Mod:handle(Request, State),
			From ! {Name, Response},
			loop(Name, Mod, State1)
	end.




%% ====================================================================
%% Internal functions
%% ====================================================================


