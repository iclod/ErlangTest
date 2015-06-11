%% @author IcLod
%% @doc @todo Add description to tr_sup.


%% ====================================================================
%% Head
%% ====================================================================
-module(tr_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).
%% ====================================================================
%% define
%% ====================================================================
-define(SERVER, ?MODULE).

%% ====================================================================
%% API functions
%% ====================================================================
start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
	Server = {tr_server, {tr_server, start_link, []},
				permanent, 2000, worker, [tr_server]},
	Children = [Server],
	RestartStrategy = {one_for_one, 0, 1},
	{ok, {RestartStrategy, Children}}.


%% ====================================================================
%% Internal functions
%% ====================================================================


