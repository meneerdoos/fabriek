-module(switchOnPump_handler).

-export([init/2]).

init(Req0, Opts) ->
  {ok, _Value, Req1} = cowboy_req:read_body(Req0),
  S1 = binary_to_list(_Value) ,
  PipePID = list_to_pid(S1),
  pumpInst:switch_on(PipePID),
  Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"ok">>, Req1),
	{ok, Req, Opts}.
