-module(errorGenerator_handler).

-export([init/2]).

init(Req0, Opts) ->

  {ok, _Value, Req1} = cowboy_req:read_body(Req0),
  demo1:addTest(_Value),

	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"Error added">>, Req1),
	{ok, Req, Opts}.
