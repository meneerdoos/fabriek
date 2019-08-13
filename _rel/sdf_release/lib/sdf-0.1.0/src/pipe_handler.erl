-module(pipe_handler).

-export([init/2]).

init(Req0, Opts) ->
  {ok, _Value, Req1} = cowboy_req:read_body(Req0),
  S1 = binary_to_list(_Value) ,
  _PipePID = list_to_pid(S1),
  {ok, L} = resource_instance:list_locations(_PipePID),
  {ok, C} = resource_instance:list_connectors(_PipePID),

  _Conn1 = lists:nth(1,C),
  _Conn2 = lists:nth(2,C),
  _LocJSON = lists:nth(1,L),
  _Conn1JSON = demo1:pid_to_binary(_Conn1),
  _Conn2JSON = demo1:pid_to_binary(_Conn2),


  RSJSON =
    [{[
        {<<"ID">>,                  0},
        {<<"resource_type">>,       <<"Connector1">>},
        {<<"resource_PID">>,        demo1:pid_to_binary(_Conn1)}
    ]},
    {[
       {<<"ID">>,                  1},
       {<<"resource_type">>,       <<"Connector2">>},
       {<<"resource_PID">>,        demo1:pid_to_binary(_Conn2)}
    ]},
    {[
       {<<"ID">>,                  2},
       {<<"resource_type">>,       <<"Location">>},
       {<<"resource_PID">>,        demo1:pid_to_binary(_LocJSON)}
    ]}

    ],



  Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"application/json">>
	}, jiffy:encode(RSJSON) , Req1),
	{ok, Req, Opts}.
