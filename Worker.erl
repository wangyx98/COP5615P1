%%%-------------------------------------------------------------------
%%% @author zhaolida
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 9月 2022 10:18 AM
%%%-------------------------------------------------------------------
-module('Worker').
-import(hashFunction,[encode/1]).
-import(string,[substr/3,equal/2]).

%% API
-export([start/1,while/2]).
while(ifloop,String)->
  if
    ifloop == true ->
      Str1 = substr(encode(String),1,3),
      ifloop = not equal(Str1,"000"),
      while(ifloop,String);
    true -> io:fwrite("~p~n",[String])
  end.

start(String)->
  ifloop = true,
  while(ifloop,String).
