-module(sdf_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [

				{"/hello", hello_handler, []},
				{"/", cowboy_static, {priv_file, sdf, "static/index.html"}},
				{"/createFactory", fabriek_handler, []},
				{"/getAll", index_handler, []},
				{"/pipe", pipe_handler, []},
				{"/switchOnPump", switchOnPump_handler, []},
				{"/switchOffPump", switchOffPump_handler, []},
				{"/switchOnRealPump", realPumpOn_handler, []},
				{"/switchOffRealPump", realPumpOff_handler, []},
				{"/updateMargin", updateMargin_handler, []},
				{"/updateFlow", updateFlow_handler, []},
				{"/addError", errorGenerator_handler, []},
				{"/getError", errorGetter_handler, []}






				]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    sdf_sup:start_link().
stop(_State) ->
	ok.
