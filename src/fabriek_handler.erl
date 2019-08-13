-module(fabriek_handler).

-export([init/2]).

init(Req0, Opts) ->
  demo1:init(),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"Factory createdd">>, Req0),
	{ok, Req, Opts}.
