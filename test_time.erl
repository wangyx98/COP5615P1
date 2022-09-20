-module(test_time).
-export([time_test/0]).

time_test() ->
	statistics(runtime),
	statistics(wall_clock),

	master:start(3),
	client:start(),

	{_,Time} = statistics(runtime),
	{_,Time2} = statistics(wall_clock),

	io:format("Run time ~p Milliseconds: ", [Time]),
	io:format("CPU time ~p Milliseconds: ", [Time2]).