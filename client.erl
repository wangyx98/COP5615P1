-module(client).
-export([start/0]).

start() ->
	{getK, earth@QSmbp} ! {self()},
	receive {K, ClientID} ->
		mine_process(K, ClientID)
	end.


mine_process(K, ClientID) ->
	Code = randomizer(),
	HashCode = hashFunction:encode(Code),
	KSubStr= string:substr(HashCode,1,K),
	DuplicateZero = lists:concat(lists:duplicate(K, "0")),
	if 
		KSubStr == DuplicateZero ->
			{print,earth@QSmbp} ! {ClientID, Code, HashCode},
			mine_process(K, ClientID);
		true ->
			mine_process(K, ClientID)
		end.

randomizer() ->
	Random_Str = string:concat("xizhe",
		base64:encode_to_string(crypto:strong_rand_bytes(9))),
	Random_Str.