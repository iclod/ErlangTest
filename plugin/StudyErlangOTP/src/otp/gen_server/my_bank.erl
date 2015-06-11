%% @author IcLod
%% @doc @todo Add description to my_bank.


%% ====================================================================
%% Head
%% ====================================================================
-module(my_bank).
-export([init/1,handle_call/3,start/0,stop/0,new_account/1,deposit/2,withdraw/2]).
-export([handle_casl/2,handle_info/2,terminate/2,code_change/3]).
%% ====================================================================
%% define
%% ====================================================================
-define(SERVER, my_bank).

%% ====================================================================
%% API functions
%% ====================================================================

%%	打开银行
start() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%	关闭银行
stop() ->
	gen_server:call(?MODULE, stop).
%%	创建一个新帐号
new_account(Who) 		-> gen_server:call(?MODULE, {new, Who}).
%%	把钱存入银行
deposit(Who, Amount) 	-> gen_server:call(?MODULE, {add, Who, Amount}).
%%	把钱取出来
withdraw(Who, Amount) 	-> gen_server:call(?MODULE, {remove, Who, Amount}). 



init([]) -> {ok, ets:new(?MODULE, [])}.

handle_call({new, Who}, _From, Tab) ->
	Reply = case ets:lookup(Tab, Who) of
				[] -> ets:insert(Tab, {Who, 0}),
						{welcome, Who};
				[_] -> {Who, you_already_are_a_customer}
			end,
{reply, Reply, Tab};

handle_call({add, Who, X}, _From, Tab) ->
	Reply = case ets:lookup(Tab, Who) of
				[] -> not_a_customer;
				[{Who, Balance}] ->
					NewBalance = Balance + X,
					ets:insert(Tab, {Who, NewBalance}),
					{thanks, Who, your_balance_is, NewBalance}
			end,
	{reply, Reply, Tab};

handle_call({remove, Who, X}, _From, Tab) ->
	Reply = case ets:lookup(Tab, Who) of
				[] -> not_a_customer;
				[{Who, Balance}] when X =< Balance ->
					NewBalance = Balance - X,
					ets:insert(Tab, {Who, NewBalance}),
					{thanks, Who, your_balance_is, NewBalance};
				[{Who, Balance}] ->
					[sorry, Who, you_only_have, Balance, in_the_bank]
			end,
	{reply, Reply, Tab};

handle_call(stop, _From, Tab) -> 
	{stop, normal, stopped, Tab}.

handle_casl(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
  



%% ====================================================================
%% Internal functions
%% ====================================================================


