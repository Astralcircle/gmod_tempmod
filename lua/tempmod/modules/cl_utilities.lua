hook.Add("AddToolMenuCategories", "TemperatureModCategory", function()
    spawnmenu.AddToolCategory("Utilities", "Temperature Mod", "Temperature Mod")

    spawnmenu.AddToolCategory("Main", "Temperature Mod", "Temperature Mod")
end)

hook.Add("PopulateToolMenu", "TemperatureModSettings", function()
    spawnmenu.AddToolMenuOption("Utilities", "Temperature Mod", "tempmodserver", "#tempmod.tempmod_servercategory", "", "", function(panel)
        panel:ClearControls()
        panel:Help( "#tempmod.tempmod_serversideoptions" )
        panel:Help( "#tempmod.tempmod_temperature" )
        panel:NumSlider( "#tempmod.tempmod_normaltemperature", "tempmod_normal_temperature", 0, 500, 1 )
        panel:ControlHelp( "#tempmod.tempmod_normalobjecttemperature" )
        panel:Help( "#tempmod.tempmod_damagefromtemperature" )
        panel:CheckBox( "#tempmod.tempmod_propdamage", "tempmod_damageprops" )
        panel:ControlHelp( "#tempmod.tempmod_propdamagedesc" )
        panel:NumSlider( "#tempmod.tempmod_tempfordamage", "tempmod_tempfordamage", 50, 1000, 0 )
        panel:ControlHelp( "#tempmod.tempmod_tempfordamagedesc" )
        --
        panel:Help( "#tempmod.tempmod_valuestitle" )
		panel:NumSlider( "#tempmod.tempmod_decreasevalue", "tempmod_tempdecrease_value", 0, 50, 0 )
        panel:ControlHelp( "#tempmod.tempmod_decreasevaluedesc" )
        panel:NumSlider( "#tempmod.tempmod_increasevalue", "tempmod_tempincrease_value", 3, 50, 1 )
        panel:ControlHelp( "#tempmod.tempmod_increasevaluedesc" )
        panel:NumSlider( "#tempmod.tempmod_spreadvalue", "tempmod_tempspread_value", 0.05, 0.1, 2 )
        panel:ControlHelp( "#tempmod.tempmod_spreadvaluedesc" )
        --
        panel:Help( "#tempmod.tempmod_realismtitle" )
		panel:CheckBox( "#tempmod.tempmod.temperaturespread", "tempmod_tempspread" )
        panel:ControlHelp( "#tempmod.tempmod.temperaturespreaddesc" )
        --
        panel:Help( "Time" )
		panel:NumSlider( "Decrease Temp Update", "tempmod_tempdecrease_updatetime", 1, 60, 0 )
        panel:ControlHelp( "Update Time for temperature decrease. Affects optimization" )

        panel:NumSlider( "Spread Temp Update", "tempmod_tempspread_updatetime", 2, 60, 0 )
        panel:ControlHelp( "Update Time for temperature spread. Affects optimization" )
    end)

    spawnmenu.AddToolMenuOption("Utilities", "Temperature Mod", "tempmodclient", "#tempmod.tempmod_clientcategory", "", "", function(panel)
        panel:ClearControls()
        panel:Help( "#tempmod.tempmod_clienttitle" )
        panel:Help( "#tempmod.tempmod_optimizationtitle" )
        panel:CheckBox( "#tempmod.tempmod_clientglow", "tempmod_glow_enabled" )
        panel:ControlHelp( "#tempmod.tempmod_clientglowdesc" )
        panel:NumSlider( "#tempmod.tempmod_clientglowcount", "tempmod_glow_max", 0, 7, 0 )
        panel:ControlHelp( "#tempmod.tempmod_clientglowdesc2" )
	end )

    spawnmenu.AddToolMenuOption("Utilities", "Temperature Mod", "tempmodabout", "#tempmod.tempmod_aboutaddon", "", "", function(panel)

        panel:ClearControls()
        panel:Help("#tempmod.tempmod_abouttempmod")
        
        panel:Help("#tempmod.tempmod_creatortitle")
        
        panel:Help("#tempmod.tempmod_testertitle")

        panel:Help("Cool dude: AstralCircle")
        
        local urlButton = vgui.Create("DButton", panel)
        urlButton:SetText("Workshop")
        urlButton:SizeToContents()
        urlButton:SetTall(30)
        urlButton:SetWide(200)
        urlButton.DoClick = function()
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3259220540")
        end
        
        panel:AddItem(urlButton)

        local urlButton = vgui.Create("DButton", panel)
        urlButton:SetText("Addon Updates")
        urlButton:SizeToContents()
        urlButton:SetTall(20)
        urlButton:SetWide(200)
        urlButton.DoClick = function()
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/changelog/3259220540")
        end
        
        panel:AddItem(urlButton)
        
    end)
end)