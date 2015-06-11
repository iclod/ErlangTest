%% @author IcLod
%% @doc @todo Add description to area_server0.


-module(area_server0).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

loop()->
	receive
		{rectangle,Width,Ht}->
			io:format("Area of rectangle is ~p~n",[Width*Ht]),
			loop();
		{square, Side}->
			io:format("Area of square is ~p~n",[Side*Side]),
			loop
	end.


%% ====================================================================
%% Internal functions
%% ====================================================================


