-module(master).
-export([start/1,server_print/0,talkToClient/2, string_generator/0]).


start(K) ->
	register(print,spawn(master,server_print,[])),
	register(getK,spawn(master, talkToClient,[K,0])),
	register(string_gen, spawn(master, string_generator,[])),
	statistics(runtime),
	statistics(wall_clock),
	mine_process(print, K).

talkToClient(K,ID) ->
	receive
		{From} ->
			From ! {K, ID+1},
			talkToClient(K, ID+1)
		end.
string_generator() ->
	receive
		{From} ->
			% generate number of string
			List = generate_string(1000,[]),
			From ! {List},
			string_generator()
		end.

generate_string(Count, List) when Count > 0->
	Code = randomizer(),
	generate_string(Count - 1, List ++ [Code]);
generate_string(0, List) ->
	List.

randomizer() ->
	Random_Str = string:concat("xizhe",
		base64:encode_to_string(crypto:strong_rand_bytes(9))),
	Random_Str.


mine_process(print,K) ->
	Code = randomizer(),
	HashCode = hashFunction:encode(Code),
	KSubStr= string:substr(HashCode,1,K),
	DuplicateZero = lists:concat(lists:duplicate(K, "0")),
	if 
		KSubStr == DuplicateZero ->
			try 
				print ! {Code, HashCode}
			catch
				error:badarg -> exit(self(),kill)
			end;
		true ->
			mine_process(print, K)
		end.

server_print() ->
	receive
		{Code, HashCode} ->
			io:format("Code is ~s\n",[Code]),
			io:format("HashCode is ~s\n",[HashCode]),
			{_,Time} = statistics(runtime),
			{_,Time2} = statistics(wall_clock),

			timer:sleep(2000),
			CPU_time = Time / 1000,
			Run_time = Time2 / 1000,
			Time3 = CPU_time / Run_time,
			io:format("CPU time: ~p seconds\n", [CPU_time]),
			io:format("real time: ~p seconds\n", [Run_time]),
			io:format("Ratio is ~p \n", [Time3]),
			exit(self(),kill)
		end.