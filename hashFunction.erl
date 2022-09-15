-module(hashFunction).
-export([encode/1]).
hashit(String)->
	<<Integer:256>> = crypto:hash(sha256, String),
	Integer.
encode(String)->
	HexStr = string:right(integer_to_list(hashit(String),16),64,$0),
	string:to_lower(HexStr).
