{application, 'sdf', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['connector','demo1','errorGenerator_handler','errorGetter_handler','fabriek_handler','flowMeterInst','flowMeterTyp','fluidumInst','fluidumTyp','heatExchangeLink','heatExchangerInst','heatExchangerTyp','hello_handler','index_handler','location','msg','pipeInst','pipeTyp','pipe_handler','pumpInst','pumpTyp','realPumpOff_handler','realPumpOn_handler','resource_instance','resource_type','sdf_app','sdf_sup','survivor','survivor2','switchOffPump_handler','switchOnPump_handler','updateFlow_handler','updateMargin_handler']},
	{registered, [sdf_sup]},
	{applications, [kernel,stdlib,cowboy,jiffy]},
	{mod, {sdf_app, []}},
	{env, []}
]}.