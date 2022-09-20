-module(client).
-export([start/1]).

start(Address) ->
	{getK, Address} ! {self()},
	receive {K, ClientID} ->
		mine_process(K,ClientID,Address)
	end.

mine_process(K, ClientID, Address) ->
	
	Code = randomizer(),
	HashCode = hashFunction:encode(Code),
	KSubStr= string:substr(HashCode,1,K),
	DuplicateZero = lists:concat(lists:duplicate(K, "0")),
	if 
		KSubStr == DuplicateZero ->
			
			{print,Address} ! {ClientID, Code, HashCode},
			mine_process(K, ClientID, Address);
		true ->
			mine_process(K, ClientID, Address)
		end.

randomizer() ->
	Random_Str = string:concat("xizhe",
		base64:encode_to_string(crypto:strong_rand_bytes(9))),
	Random_Str.