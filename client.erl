-module(client).
-export([start/1, askForString/3]).

start(Address) ->
	{getK, Address} ! {self()},
	receive {K, ClientID} ->
		register(talkserver, spawn(client, askForString, [K,ClientID, Address])),
		talkserver! {K, ClientID}
	end.

askForString(K, ClientID, Address) ->
	receive 
		{List} ->
			
			mine_process(K, ClientID,List, Address),
			askForString(K,ClientID, Address);
		{K, ClientID} ->
			
			{string_gen, Address} ! {self()},
			askForString(K, ClientID, Address)
	end.
mine_process(K, ClientID, [],Address) ->

	talkserver! {K, ClientID};
	
mine_process(K, ClientID, [Head | Tail],Address) ->
	Code = Head,
	
	HashCode = hashFunction:encode(Code),
	KSubStr= string:substr(HashCode,1,K),
	DuplicateZero = lists:concat(lists:duplicate(K, "0")),
	if 
		KSubStr == DuplicateZero ->
			try 
				{print,Address} ! {Code, HashCode}
			catch
				error:badarg -> exit(self(),kill)
			end;
		true ->
			mine_process(K, ClientID, Tail, Address)
		end.
