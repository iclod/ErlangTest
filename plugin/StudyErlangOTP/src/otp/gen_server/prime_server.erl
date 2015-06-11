%% @author IcLod
%% @doc @todo Add description to prime_server.


%% ====================================================================
%% Head
%% ====================================================================
-module(prime_server).
-export([start_link/0,new_prime/1]).
-export([init/1,handle_info/2,handle_call/3,
		 code_change/3,terminate/2,handle_cast/2]).
-behaviour(gen_server).
%% ====================================================================
%% define
%% ====================================================================


%% ====================================================================
%% API functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new_prime(N) ->
	gen_server:call(?MODULE, {prime, N}, 20000).

init([]) ->
	process_flag(trap_exit, true),
	io:format("~p, starting~n", [?MODULE]),
	{ok, 0}.

handle_call({prime, K}, _From, N) ->
	{reply, make_new_prime(K), N+1}.

handle_cast(_Msg, N) ->	{noreply, N}.

handle_info(_Info, N) -> {noreply, N}.

terminate(_Reason, _n) ->
	io:format("~p stopping~n", [?MODULE]),
	ok.

code_change(_OldVsn, N, _Extra) -> {ok, N}.

make_new_prime(K) ->
	if
		K > 100 ->
			alarm_handler:set_alarm(tooHot),
			N = lib_primes:make_prime(K),
			alarm_handler:clear_alarm(tooHot),
			N;
		true ->
			lib_primes:make_prime(K)
	end.



%% ====================================================================
%% Internal functions
%% ====================================================================

