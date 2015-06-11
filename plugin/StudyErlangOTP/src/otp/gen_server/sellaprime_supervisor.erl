%% @author IcLod
%% @doc @todo Add description to sellaprime_supervisor.


%% ====================================================================
%% Head
%% ====================================================================
-module(sellaprime_supervisor).
-export([start/0,start_in_shell_for_testing/0,start_link/1,init/1]).
-buhaviour(supervisor).
%% ====================================================================
%% define
%% ====================================================================


%% ====================================================================
%% API functions
%% ====================================================================
start() ->
	spawn(fun() ->
			supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = [] )
		  end).

start_in_shell_for_testing() ->
	{ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = []),
	unlink(Pid).

start_link(Args) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
	%安装自己的错误处理器
	gen_event:swap_handler(alarm_handler,{alarm_handler, swap},{my_alarm_handler, xyz}),
	{ok, {{one_for_one, 3, 10},
		  [{tag1,%原子类型标签,可以用来指代工作进程
			{area_server, start_link, []},	%定义了监控器用于启动工作器的函数,被用作apply(Mod,Fun,ArgList)的参数
			permanent,	%Restart = permanent#永久|transient#以非正常退出值终止是才会被重启|temporary#临时进程不会被重启
			10000,%ShutDown#工作器终止过程允许耗费的最长时间,超过这个时间,工作进程就会被杀掉(还有其他值,查supervisor手册)
			worker,%Type = worker|supervisor  被监控进程的类型
			[area_server]},%如果子进程是监控器或者gen_server行为回调模块,在这里制定回调模块名(其他值查手册)
		   {tag2,
			{prime_server, start_link, []},
			 permanent,
			 10000,
			 worker,
			 [prime_server]}]}}.

								 


%% ====================================================================
%% Internal functions
%% ====================================================================


