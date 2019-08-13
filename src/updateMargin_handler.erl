-module(updateMargin_handler).

-export([init/2]).

init(Req0, Opts) ->

  {ok, _Value, Req1} = cowboy_req:read_body(Req0),
  demo1:updateMargin(_Value),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"Margin updated">>, Req1),
	{ok, Req, Opts}.
