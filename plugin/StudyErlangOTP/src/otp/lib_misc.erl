%% @author IcLod
%% @doc @todo Add description to lib_misc.


-module(lib_misc).

-include_lib("G:/tools/erl6.3/lib/kernel-3.1/include/file.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([on_exit/2,start/1,keep_alive/2,consult/1,unconsult/2]).
-export([ls/1,string2value/1]).
on_exit(Pid, Fun) ->
	spawn(fun() ->
				  Ref = monitor(process , Pid),
				  receive
					  {'DOWN',Ref, process, Pid, Why}->
						  Fun(Why)
				  end
		  end).

start(Fs) ->
	spawn(	fun()->
				[spawn_link(F)||F<- Fs],
				receive
					after
							infinity ->true
				end
			end).

keep_alive(Name, Fun)->
	register(Name, Pid = spawn(Fun)),
	on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).

consult(File) ->
	case file:open(File, read) of
		{ok, S} ->
			Val = consult1(S),
			file:close(S),
			{ok, Val};
		{error, Why} ->
			{error, Why}
	end
.

consult1(S) ->
	case io:read(S, '') of
		{ok, Term} 	-> [Term|consult1(S)];
		eof 		-> [];
		Error 		-> Error
	end.

unconsult(File, L) ->
	{ok, S} = file:open(File, write),
	lists:foreach(fun(X) -> io:format(S, "~p.~n",[X]) end, L),
	file:close(S)
.

file_size_and_type(File) ->
	case file:read_file_info(File) of
		{ok, Facts} ->
			{Facts#file_info.type, Facts#file_info.size};
		_ ->
			error
	end.

ls(Dir) ->
	{ok, L} = file:list_dir(Dir),
	lists:map(fun(I) -> {I, file_size_and_type(I)} end, lists:sort(L)).

string2value(Str) ->
    {ok, Tokens, _} = erl_scan:string(Str ++ "."),
    {ok, Exprs} = erl_parse:parse_exprs(Tokens),
    Bindings = erl_eval:new_bindings(),
    {value, Value, _} = erl_eval:exprs(Exprs, Bindings),
    Value.

string_to_term(String) ->
    case erl_scan:string(String++".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> Term;
                _Err -> undefined
            end;
        _Error ->
            undefined
    end.
%% ====================================================================
%% Internal functions
%% ====================================================================


