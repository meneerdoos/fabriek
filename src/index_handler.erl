-module(index_handler).
-behavior(cowboy_handler).
-export([init/2 ]).

% -export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([hello_to_json/2]).

  init(Req, Opts) ->
      {cowboy_rest, Req, Opts}.

  % allowed_methods(Req, State) ->
  %   	{[<<"GET">>], Req, State}.

  content_types_provided(Req, State) ->
        {[
            {<<"application/json">>, hello_to_json }
        ], Req, State}.


hello_to_json(Req, State) ->
         Body = demo1:get_digital_twin_JSON(),
      	 % Body = <<"{\"rest\": \"Hello World!\"}">>,
      	{Body, Req, State}.

 % index_JSON(Req, State) ->
 %   {ok, Req, State}.
 %
 % index()->
 %   JSON = demo1:get_digital_twin_JSON(),
 %   {JSON}.
        % JSON = demo1:get_digital_twin_JSON(),
        % {JSON, Req, State}.
