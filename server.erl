-module(server).
-export([loop/0,randomize/0]).

randomize() ->
	hashFunction:encode(string:concat("xizhe",binary_to_list(crypto:strong_rand_bytes(16)))).

loop() ->
	Code = string:concat("xizhe",base64:encode_to_string(crypto:strong_rand_bytes(16))),
	Temp = hashFunction:encode(Code),
	KSubStr= string:substr(Temp,1,5),
	DuplicateZero = lists:concat(lists:duplicate(5, "0")),
	if 
		KSubStr == DuplicateZero ->
			io:format("Code is ~s\n",[Code]),
			io:format("HashCode is ~s\n",[Temp]),
			loop();
		true ->
			loop()
		end.
	