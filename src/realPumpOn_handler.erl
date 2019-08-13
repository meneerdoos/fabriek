-module(realPumpOn_handler).

-export([init/2]).

init(Req0, Opts) ->
  demo1:switchOnRealPump(),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"Pump Off">>, Req0),
	{ok, Req, Opts}.
