-module(master).
-export([start/1,server_print/0,talkToClient/2]).


start(K) ->
	register(print,spawn(master,server_print,[])),
	register(getK,spawn(master, talkToClient,[K,0])),
	mine_process(print, K).

talkToClient(K,ID) ->
	receive
		{From} ->
			From ! {K, ID+1},
			talkToClient(K, ID+1)
		end.

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
			print ! {Code, HashCode},
			mine_process(print, K);
		true ->
			mine_process(print, K)
		end.

server_print() ->
	receive
		{Code, HashCode} ->
			io:format("From server\n"),
			io:format("Code is ~s\n",[Code]),
			io:format("HashCode is ~s\n",[HashCode]),
			server_print();
		{ClientID, Code, HashCode} ->
			io:format("From Client ~w\n", [ClientID]),
			io:format("Code is ~s\n",[Code]),
			io:format("HashCode is ~s\n",[HashCode]),
			server_print()
		end.