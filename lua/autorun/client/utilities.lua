hook.Add("AddToolMenuCategories", "TemperatureModCategory", function()
    spawnmenu.AddToolCategory("Utilities", "Temperature Mod", "Temperature Mod")

    spawnmenu.AddToolCategory("Main", "Temperature Mod", "Temperature Mod")
end)

hook.Add("PopulateToolMenu", "TemperatureModSettings", function()
    spawnmenu.AddToolMenuOption("Utilities", "Temperature Mod", "tempmodserver", "Server", "", "", function(panel)
        panel:ClearControls()
        panel:Help( "Serverside options for Temperature mod" )
        panel:Help( "Temperature:" )
        panel:NumSlider( "Normal Temperature", "tempmod_normal_temperature", 0, 500, 1 )
        panel:ControlHelp( "Normal object temperature" )
        panel:Help( "Damage from temperature:" )
        panel:CheckBox( "Prop Damage", "tempmod_damageprops" )
        panel:ControlHelp( "Enable/Disable props damage by high or low temperature" )
        panel:NumSlider( "Temp For Damage", "tempmod_tempfordamage", 50, 1000, 0 )
        panel:ControlHelp( "What temperature is needed for damage props" )
        --
        panel:Help( "Values" )
		panel:NumSlider( "Decrease value", "tempmod_tempdecrease_value", 1, 50, 1 )
        panel:ControlHelp( "Temperature decrease value \nHow many degrees per second will it decrease" )
        panel:NumSlider( "Increase value", "tempmod_tempincrease_value", 3, 50, 1 )
        panel:ControlHelp( "Temperature increase value \nHow many degrees per second will it increase" )
        panel:NumSlider( "Spread value", "tempmod_tempspread_value", 0.05, 0.1, 2 )
        panel:ControlHelp( "Temperature spread value \nHow many degrees per 2 seconds will it decrease" )
        --
        panel:Help( "Realism" )
		panel:CheckBox( "Temp Spread", "tempmod_tempspread" )
        panel:ControlHelp( "Enable/Disable temperature spread to others props" )
    end)

    spawnmenu.AddToolMenuOption("Utilities", "Temperature Mod", "tempmodclient", "Client", "", "", function(panel)
        panel:ClearControls()
        panel:Help( "Clientside options for Temperature mod" )
        panel:Help( "Optimization" )
		panel:CheckBox( "Effects", "tempmod_effects_enabled" )
        panel:ControlHelp( "Enable/Disable Props effects on high or low temperature. \nDisable - More FPS" )
        panel:CheckBox( "Glow", "tempmod_glow_enabled" )
        panel:ControlHelp( "Enable/Disable Props glow on high temperature. \nDisable - More FPS" )
        panel:NumSlider( "Glow count", "tempmod_glow_max", 0, 5, 0 )
        panel:ControlHelp( "How many objects can there be with glow" )
	end )

    spawnmenu.AddToolMenuOption("Utilities", "Temperature Mod", "tempmodabout", "About Addon", "", "", function(panel)
        panel:ClearControls()
        panel:Help( "About Temperature Mod" )
        
        panel:Help( "Creator: [KWR] Ty4a" )
        panel:Help( "Tester: [KWR] Dr. Robalt Furgen" )

        panel:Help( "Link to addon - https://steamcommunity.com/sharedfiles/filedetails/?id=3259220540" )
        
	end )
end)