-module(demo1).
-export([init/0, do/0, mkC/0,update_error/1,get_digital_flowMeter/0, get_error_JSON/0, updateFlow/1, updateMargin/1, addTest /1, get_digital_pump /0, get_real_pump /0, checkErrors/0, switchOnRealPump/0, switchOffRealPump/0, get_test/0 , get_error/0 ,  get_real_system/0,pid_to_binary/1, get_digital_twin/0,get_real_system_JSON/0, get_digital_twin_JSON/0, get_type/1]).
-export([pipeCircuit/0]).

%%%%%%%%%%%%%%%%%START%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init() ->
	% observer:start(),
	survivor:start(),
	mkC().

do() -> ok.

mkC() -> PID = spawn(?MODULE, pipeCircuit, []),
				register ( systemPipez, PID ).


pipeCircuit() ->
				{ok, RealSystem} = realSystem(),
			  {ok, DigitalTwin} = digitalTwin(),
				{ok, Tests} = tests(),
				{ok, Errors } = errors(),
			  loop(RealSystem,DigitalTwin, Tests, Errors ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JSON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_digital_twin_JSON()->
				{ok, DT } = get_digital_twin(),
			 	#{<<"PipeTyp_PID">> := _DT_PipeTyp_PID } = DT,
			 	#{<<"Pipe_1">> := _DT_Pipe_1_PID} = DT,
			 	#{<<"Pipe_2">> := _DT_Pipe_2_PID} = DT,
			 	#{<<"Pipe_3">> := _DT_Pipe_3_PID} = DT,
			 	#{<<"Pipe_4">> := _DT_Pipe_4_PID} = DT,
				#{<<"Pump_PID">> := _DT_Pump_PID} = DT,
				#{<<"PumpTyp_PID">> := _DT_PumpTyp_PID} = DT,
				#{<<"FlowMeterTyp_PID">> := _DT_FlowMeterTyp_PID} = DT,
				#{<<"FlowMeter_PID">> := _DT_FlowMeter_PID} = DT,
				#{<<"Fluidum_PID">> := _DT_Fluidum_PID} = DT,
				#{<<"FluidumTyp_PID">> := _DT_FluidumTyp_PID} = DT,

				{ok, State } = pumpInst:is_on(_DT_Pump_PID),
				{ok, Flow } = flowMeterInst:estimate_flow(_DT_FlowMeter_PID),


			 DTJSON =
				 [{[
						 {<<"ID">>,                  0},
						 {<<"resource_type">>,       <<"Pipe">>},
						 {<<"resource_type_PID">>,   pid_to_binary(_DT_PipeTyp_PID)},
						 {<<"resource_PID">>,        pid_to_binary(_DT_Pipe_1_PID)}
				 ]},
				 {[
						{<<"ID">>,                  1},
						{<<"resource_type">>,       <<"Pipe">>},
						{<<"resource_type_PID">>,   pid_to_binary(_DT_PipeTyp_PID)},
						{<<"resource_PID">>,        pid_to_binary(_DT_Pipe_2_PID)}
				 ]},
				 {[
						{<<"ID">>,                  2},
						{<<"resource_type">>,       <<"Pipe">>},
						{<<"resource_type_PID">>,   pid_to_binary(_DT_PipeTyp_PID)},
						{<<"resource_PID">>,        pid_to_binary(_DT_Pipe_3_PID)}
				 ]},
				 {[
						{<<"ID">>,                  3},
						{<<"resource_type">>,       <<"Pipe">>},
						{<<"resource_type_PID">>,   pid_to_binary(_DT_PipeTyp_PID)},
						{<<"resource_PID">>,        pid_to_binary(_DT_Pipe_4_PID)}
				 ]},
				 {[
						{<<"ID">>,                  4},
						{<<"resource_type">>,       <<"Pump">>},
						{<<"resource_type_PID">>,   pid_to_binary(_DT_PumpTyp_PID)},
						{<<"resource_PID">>,        pid_to_binary(_DT_Pump_PID)},
						{<<"status">>, 							State}
				 ]},
				 {[
					 {<<"ID">>,                  5},
					 {<<"resource_type">>,       <<"FlowMeter">>},
					 {<<"resource_type_PID">>,   pid_to_binary(_DT_FlowMeterTyp_PID)},
					 {<<"resource_PID">>,        pid_to_binary(_DT_FlowMeter_PID)},
					 {<<"flow">>, 							 Flow }
				]},
				{[
					{<<"ID">>,                  6},
					{<<"resource_type">>,       <<"Fluidum">>},
					{<<"resource_type_PID">>,   pid_to_binary(_DT_FluidumTyp_PID)},
					{<<"resource_PID">>,        pid_to_binary(_DT_Fluidum_PID)},
					{<<"flow">>, 							 Flow }
			 ]}
				 ],
				 jiffy:encode(DTJSON).
				 % flowMeterInst:estimate_flow(_DT_FlowMeter_PID).
% flowMeterInst:measure_flow(_DT_FlowMeter_PID).
			  % jiffy:encode(DTJSON).

% get_pipe_details_JSON(PID)->
%
%
% 	ok.

get_error_JSON()->
			checkErrors(),
			{ok, Error} = get_error(),
			#{<<"FlowDifference">> := Var1 } = Error ,
			#{<<"PumpDifference">> := Var2 } = Error ,
			#{<<"WaterError">> := Var3 } = Error ,
			#{<<"PumpError">> := Var4 } = Error ,

			ErrorJSON =
				[{[
						{<<"PumpError">>,             	     	Var4},
						{<<"FlowDifference">>,       					Var1},
						{<<"PumpDifference">>,   							Var2},
						{<<"WaterError">>,        						Var3}
				]}
				],

		 jiffy:encode(ErrorJSON).


get_real_system_JSON()->
 				{ok, RS } = get_real_system(),

			 #{<<"PipeTyp_PID">> := _RS_PipeTyp_PID} = RS,
			 #{<<"Pipe_1">> := _RS_Pipe_1_PID} = RS,
			 #{<<"Pipe_2">> := _RS_Pipe_2_PID} = RS,
			 #{<<"Pipe_3">> := _RS_Pipe_3_PID} = RS,
			 #{<<"Pipe_4">> := _RS_Pipe_4_PID} = RS,


			 % Type = resource_instance:get_type(RS_Pipe_1_PID) ,
			 RSJSON =
		     [{[
		         {<<"ID">>,                  0},
		         {<<"resource_type">>,       <<"Pipe1">>},
		         {<<"resource_type_PID">>,   pid_to_binary(_RS_PipeTyp_PID)},
		         {<<"resource_PID">>,        pid_to_binary(_RS_Pipe_1_PID)}
		     ]},
				 {[
				 		{<<"ID">>,                  1},
				 		{<<"resource_type">>,       <<"Pipe2">>},
				 		{<<"resource_type_PID">>,   pid_to_binary(_RS_PipeTyp_PID)},
				 		{<<"resource_PID">>,        pid_to_binary(_RS_Pipe_2_PID)}
				 ]},
				 {[
						{<<"ID">>,                  2},
						{<<"resource_type">>,       <<"Pipe3">>},
						{<<"resource_type_PID">>,   pid_to_binary(_RS_PipeTyp_PID)},
						{<<"resource_PID">>,        pid_to_binary(_RS_Pipe_3_PID)}
				 ]},
				 {[
						{<<"ID">>,                  3},
						{<<"resource_type">>,       <<"Pipe4">>},
						{<<"resource_type_PID">>,   pid_to_binary(_RS_PipeTyp_PID)},
						{<<"resource_PID">>,        pid_to_binary(_RS_Pipe_4_PID)}
				 ]}
				 ],
			jiffy:encode(RSJSON).

%%%%%%%%%%% Getters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_real_system () ->
			systemPipez ! {get_real_system , self()},
			receive
				L -> {ok, L}
				after 5000 -> {error, timed_out}
			end.

get_test () ->
				systemPipez ! {get_test , self()},
				receive
					L -> {ok, L}
					after 5000 -> {error, timed_out}
				end.

get_error () ->
				systemPipez ! {get_error , self()},
				receive
					L -> {ok, L}
					after 5000 -> {error, timed_out}
				end.

update_test(Test) ->
				systemPipez ! {update_test , Test },
				receive
					L -> {ok, L}
					after 5000 -> {error, timed_out}
				end.

update_error(Error) ->
				systemPipez ! {update_error , Error },
				receive
					L -> {ok, L}
					after 5000 -> {error, timed_out}
				end.

get_digital_twin () ->
			systemPipez ! {get_digital_twin , self()},
			receive
				L -> {ok, L}
				after 5000 -> {error, timed_out}
			end.

get_type({ok, [ RI | _ ]}) -> resource_instance:get_type(RI).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_digital_pump() -> 		{ok, DT} = get_digital_twin(),
													#{<<"Pump_PID">> := Pump_PID} = DT,
 													{ok, Pump_PID}.

get_real_pump() -> 					{ok, RS} = get_real_system(),
														#{<<"Pump_PID">> := Pump } = RS,
 														{ok, Pump}.

get_digital_flowMeter() ->	{ok, DT} = get_digital_twin(),
														#{<<"FlowMeter_PID">> := FlowM } = DT,
														{ok, FlowM }.


%%%%%%%%%%%%%%%%%%%%%%%%% LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



loop(RS,DT,Test, Errors) ->
	receive
		{get_real_system, Pid} ->
			Pid ! RS, loop(RS,DT,Test, Errors);
		{get_digital_twin, Pid} ->
			Pid ! DT, loop(RS,DT,Test, Errors );
		{get_test, Pid} ->
			Pid ! Test, loop(RS, DT, Test, Errors);
		{get_error, Pid} ->
			Pid ! Errors, loop(RS, DT, Test, Errors);
		{update_test, TestU } ->
		  	loop(RS,DT, TestU, Errors);
		{update_error, ErrorU}	->
				loop(RS, DT, Test, ErrorU );

		stop -> ok
	end.




%%%%%%%%%%%%%%%%%%%%%%%%%CREATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

realSystem()->
	% We beginnen met het opzetten van de echte machine

	% Create Pipe Type
	{ok, PipeTyp_PID} = resource_type:create(pipeTyp, []),

	% Create 4 pipes
	{ok, Pipe_1_PID}  = resource_instance:create(pipeInst, [self(), PipeTyp_PID]),
	{ok, Pipe_2_PID}  = resource_instance:create(pipeInst, [self(), PipeTyp_PID]),
	{ok, Pipe_3_PID}  = resource_instance:create(pipeInst, [self(), PipeTyp_PID]),
	{ok, Pipe_4_PID}  = resource_instance:create(pipeInst, [self(), PipeTyp_PID]),

	% Create the connectors
	{ok, [Connector_Pipe_1_In, Connector_Pipe_1_Out]} = resource_instance:list_connectors(Pipe_1_PID),
	{ok, [Connector_Pipe_2_In, Connector_Pipe_2_Out]} = resource_instance:list_connectors(Pipe_2_PID),
	{ok, [Connector_Pipe_3_In, Connector_Pipe_3_Out]} = resource_instance:list_connectors(Pipe_3_PID),
	{ok, [Connector_Pipe_4_In, Connector_Pipe_4_Out]} = resource_instance:list_connectors(Pipe_4_PID),

	% Connect the pipes
	connector:connect(Connector_Pipe_1_Out, Connector_Pipe_2_In),
	connector:connect(Connector_Pipe_2_Out, Connector_Pipe_3_In),
	connector:connect(Connector_Pipe_3_Out, Connector_Pipe_4_In),
	connector:connect(Connector_Pipe_4_Out, Connector_Pipe_1_In),
	%
	% {ok, DT_FluidumTyp_PID} = resource_type:create(fluidumTyp, []),
	% {ok, DT_Fluidum_PID}    = resource_instance:create(fluidumInst, [RS_Connector_Pipe_0_In, RS_FluidumTyp_PID]),

	%{ok, DT_HeatExchangerTyp_PID} = resource_type:create(heatExchangerTyp, []),


	% Create a pump
	{ok, PumpTyp_PID} = resource_type:create(pumpTyp, []),
	{ok, Pump_PID}    = resource_instance:create(pumpInst, [self(), PumpTyp_PID, Pipe_1_PID, fun(_Command) -> none end]),

		% {ok, PumpTyp_PID, Pump_PID} = addPump( DT_Pipe_1_PID ),

		% Fluidium
	{ok, FluidumTyp_PID} = resource_type:create(fluidumTyp, []),
	% {ok, [Root_ConnectorPid | _ ]} = resource_instance:list_connectors(DT_Pipe_1_PID),
	{ok, Fluidum_PID}    = resource_instance:create(fluidumInst, [Connector_Pipe_1_In , FluidumTyp_PID]),

		% {ok, DT_FluidumTyp_PID} = resource_type:create(fluidumTyp, []),

	% Create a flowmeter
	{ok, FlowMeterTyp_PID}    = resource_type:create(flowMeterTyp, []),
	{ok, [Location_Pipe_2|_]} = resource_instance:list_locations(Pipe_2_PID),
	location:arrival(Location_Pipe_2, Fluidum_PID),

	{ok, FlowMeter_PID} = resource_instance:create(flowMeterInst, [self(), FlowMeterTyp_PID, Pipe_2_PID, fun() -> no_data end]),


	% Create a heatexchagner (not included in new version )
	% {ok, DT_HeatExchangerTyp_PID} = resource_type:create(heatExchangerTyp, []),
	% Link = #{delta => 15},
	% {ok, DT_HeatExchanger_PID} = resource_instance:create(heatExchangerInst, [self(), DT_HeatExchangerTyp_PID, DT_Pipe_3_PID, Link, fun()-> no_data end]),
	% DT_HeatExchanger_PID,
	% Create HeatExchanger


		% {ok, FluidumTyp_PID, Fluidum_PID} = addFluidum( DT_Connector_Pipe_1_In),
		% Dit zijn de dingen die we met testen willen aanpassen

	RealSystem= #{
				<<"Pump_PID">>     						=> Pump_PID,
				<<"FlowMeter_PID">>      			=> FlowMeter_PID
	},
	{ ok, RealSystem}.

tests()->
	Tests= #{
		 				<<"WaterError">>						=> false,
		 				<<"PumpError">>							=> false,
						<<"Margin">>								=> 0,
						<<"Flow">>									=> 0
},
{ok, Tests}.


errors()->
	Errors = #{
						<<"FlowDifference">>						=> false,
						<<"PumpDifference">>						=> false,
						<<"WaterError">>								=> false,
						<<"PumpError">>									=> false
	},

	{ok, Errors}.


digitalTwin()->
	  % We beginnen met het opzetten van de echte machine

	  % Create Pipe Type
	  {ok, DT_PipeTyp_PID} = resource_type:create(pipeTyp, []),

	  % Create 4 pipes
	  {ok, DT_Pipe_1_PID}  = resource_instance:create(pipeInst, [self(), DT_PipeTyp_PID]),
	  {ok, DT_Pipe_2_PID}  = resource_instance:create(pipeInst, [self(), DT_PipeTyp_PID]),
	  {ok, DT_Pipe_3_PID}  = resource_instance:create(pipeInst, [self(), DT_PipeTyp_PID]),
	  {ok, DT_Pipe_4_PID}  = resource_instance:create(pipeInst, [self(), DT_PipeTyp_PID]),

	  % Create the connectors
	  {ok, [DT_Connector_Pipe_1_In, DT_Connector_Pipe_1_Out]} = resource_instance:list_connectors(DT_Pipe_1_PID),
	  {ok, [DT_Connector_Pipe_2_In, DT_Connector_Pipe_2_Out]} = resource_instance:list_connectors(DT_Pipe_2_PID),
	  {ok, [DT_Connector_Pipe_3_In, DT_Connector_Pipe_3_Out]} = resource_instance:list_connectors(DT_Pipe_3_PID),
	  {ok, [DT_Connector_Pipe_4_In, DT_Connector_Pipe_4_Out]} = resource_instance:list_connectors(DT_Pipe_4_PID),

	  % Connect the pipes
	  connector:connect(DT_Connector_Pipe_1_Out, DT_Connector_Pipe_2_In),
	  connector:connect(DT_Connector_Pipe_2_Out, DT_Connector_Pipe_3_In),
	  connector:connect(DT_Connector_Pipe_3_Out, DT_Connector_Pipe_4_In),
	  connector:connect(DT_Connector_Pipe_4_Out, DT_Connector_Pipe_1_In),
		%
		% {ok, DT_FluidumTyp_PID} = resource_type:create(fluidumTyp, []),
	 	% {ok, DT_Fluidum_PID}    = resource_instance:create(fluidumInst, [RS_Connector_Pipe_0_In, RS_FluidumTyp_PID]),

		%{ok, DT_HeatExchangerTyp_PID} = resource_type:create(heatExchangerTyp, []),


		% Create a pump
		{ok, DT_PumpTyp_PID} = resource_type:create(pumpTyp, []),
		{ok, DT_Pump_PID}    = resource_instance:create(pumpInst, [self(), DT_PumpTyp_PID, DT_Pipe_1_PID, fun(_Command) -> none end]),

			% {ok, PumpTyp_PID, Pump_PID} = addPump( DT_Pipe_1_PID ),

			% Fluidium
		{ok, DT_FluidumTyp_PID} = resource_type:create(fluidumTyp, []),
		% {ok, [Root_ConnectorPid | _ ]} = resource_instance:list_connectors(DT_Pipe_1_PID),
		{ok, DT_Fluidum_PID}    = resource_instance:create(fluidumInst, [DT_Connector_Pipe_1_In , DT_FluidumTyp_PID]),

			% {ok, DT_FluidumTyp_PID} = resource_type:create(fluidumTyp, []),

		% Create a flowmeter
		{ok, DT_FlowMeterTyp_PID}    = resource_type:create(flowMeterTyp, []),
		{ok, [DT_Location_Pipe_2|_]} = resource_instance:list_locations(DT_Pipe_2_PID),
		location:arrival(DT_Location_Pipe_2, DT_Fluidum_PID),

		{ok, DT_FlowMeter_PID} = resource_instance:create(flowMeterInst, [self(), DT_FlowMeterTyp_PID, DT_Pipe_2_PID, fun() -> no_data end]),


		% Create a heatexchagner (not included in new version )
 		% {ok, DT_HeatExchangerTyp_PID} = resource_type:create(heatExchangerTyp, []),
 		% Link = #{delta => 15},

 		% {ok, DT_HeatExchanger_PID} = resource_instance:create(heatExchangerInst, [self(), DT_HeatExchangerTyp_PID, DT_Pipe_3_PID, Link, fun()-> no_data end]),
 		% DT_HeatExchanger_PID,
		% Create HeatExchanger


			% {ok, FluidumTyp_PID, Fluidum_PID} = addFluidum( DT_Connector_Pipe_1_In),

	  _DT= #{
					<<"FluidumTyp_PID">>					=> DT_FluidumTyp_PID,
					<<"Fluidum_PID">>							=> DT_Fluidum_PID,

					<<"PipeTyp_PID">>      				=> DT_PipeTyp_PID,
	        <<"Pipe_1">>      						=> DT_Pipe_1_PID,
	        <<"Pipe_2">>      						=> DT_Pipe_2_PID,
	        <<"Pipe_3">>      						=> DT_Pipe_3_PID,
	        <<"Pipe_4">>      						=> DT_Pipe_4_PID,
					<<"Pump_PID">>     						=> DT_Pump_PID,
					<<"PumpTyp_PID">>     				=> DT_Pump_PID,
					<<"FlowMeterTyp_PID">>    		=> DT_FlowMeterTyp_PID,
					<<"FlowMeter_PID">>      			=> DT_FlowMeter_PID


	  },
	  { ok, _DT}.


%%%%%%%%%%%%%ù Helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pid_to_binary(PID) ->
  list_to_binary(pid_to_list(PID)).



%%%%%%%%%%%%%%%%%%%%%%%%% Real commands PUMP %%%%%%%%%%%%%%%%%%%%%%%%%
switchOnRealPump()->
	{ok, RS} = get_real_system(),
	#{<<"Pump_PID">> := Pump } = RS,
	pumpInst:switch_on(Pump),

	erlang:display("Real pump has been switched on "),
	ok.


switchOffRealPump()->
	{ok, RS} = get_real_system(),
	#{<<"Pump_PID">> := Pump } = RS,
	pumpInst:switch_off(Pump),

	erlang:display("Real pump has been switched off "),
	ok.






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% API %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Moet je nog updaten

%error processing
addTest(Value)->
	{ok, Test } = get_test(),
	Test2 = maps:update( Value,true ,Test ),
	update_test(Test2),
	{ok, Test2}.

% %These are the errors displayed on the web page
checkErrors()->
	{ok, RealPump } = get_real_pump() ,
	{ok, DigitalPump } = get_digital_pump(),
	{ok, _StateRealPump } = pumpInst:is_on(RealPump),
	{ok, _StateDigitalPump } = pumpInst:is_on(DigitalPump),

	{ok, FlowMeter } = get_digital_flowMeter(),
	{ok, _FlowD } = flowMeterInst:estimate_flow(FlowMeter),

	{ok, Test } = get_test(),
	#{<<"PumpError">> := _PumpError } = Test ,
	#{<<"WaterError">> := _WaterError } = Test ,
	#{<<"Margin">> := _Margin } = Test ,
	#{<<"Flow">> := _FlowR } = Test ,
	% {NumberFlow, <<>> }= string:to_integer(_FlowR),
	% {NumberMargin, <<>> } = string:to_integer(_Margin),
	% erlang:display(abs(NumberFlow-_FlowD)),

	{ok, Error} = get_error(),
	_Error2 = maps:update( <<"WaterError">>,_WaterError ,Error ),
	_Error3 = maps:update( <<"PumpError">>,_PumpError ,_Error2 ),
	_Error4 = maps:update( <<"PumpDifference">>,(_StateRealPump /= _StateDigitalPump ) ,_Error3 ),
	_Error5 = maps:update( <<"FlowDifference">>,( abs(_FlowR - _FlowD) > _Margin ) ,_Error4 ),

	% #{<<"Flow">> := _Flow } = Test ,
	% erlang:display("2"),
	% {ok, Error} = get_error(),
	% _Error2 = maps:update( <<"WaterError">>,true ,Error ),
	% _Error3 = maps:update( <<"PumpError">>,true ,_Error2 ),
	% _Error4 = maps:update( <<"PumpDifference">>,(StateRealPump == StateDigitalPump ) ,_Error3 ),
	% _Error5 = maps:update( <<"FlowDifference">>,( _Flow - Flow < _Margin ) ,_Error4 ),
	update_error(_Error5),

	ok.


updateMargin(Value)->
	{ok, Test } = get_test(),
	{Number, <<>> }= string:to_integer(Value),

	Test2 = maps:update( <<"Margin">>,Number ,Test ),

	update_test( Test2),
	 {ok, Test2} .


updateFlow(Value)->
	{ok, Test } = get_test(),
	{Number, <<>> }= string:to_integer(Value),

	Test2 = maps:update( <<"Flow">>,Number ,Test ),
	update_test( Test2 ),
	{ok, Test2}.
