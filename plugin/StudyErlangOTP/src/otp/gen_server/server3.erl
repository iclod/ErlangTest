%% @author IcLod
%% @doc @todo Add description to server3.


%% ====================================================================
%% Head
%% ====================================================================
-module(server3).
-export([start/2,rpc/2,swap_code/2]).
%% ====================================================================
%% define
%% ====================================================================


%% ====================================================================
%% API functions
%% ====================================================================
start(Name, Mod) ->
	register(Name,
			 spawn(fun() -> loop(Name,Mod,Mod:init()) end)).
swap_code(Name, Mod) -> rpc(Name, {swap_code, Mod}).

rpc(Name, Request) ->
	Name ! {self(), Request},
	receive
		{Name, Response} -> Response
	end.

loop(Name, Mod, OldState) ->
	receive
		{From, {swap_code, NewCallBackMod}} ->
			From ! {Name, ack},
			loop(Name, NewCallBackMod, OldState);
		{From, Request} ->
			{Response, NewState} = Mod:handle(Request, OldState),
			From ! {Name, Response},
			loop(Name, Mod, NewState)
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================


