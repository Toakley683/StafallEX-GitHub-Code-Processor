--@name Code Processor
--@author
--@shared

if SERVER then

    local Programs = {}

    wire.adjustInputs( { "Text", "User" }, { "String", "Entity" } )

    local Entry = prop.createSent( chip():getPos() + Vector( 0, 0, 30 ), Angle( 0, 0, 0 ), "gmod_wire_textentry", true )
    Entry:setParent( chip() )
    
    wire.create( chip(), Entry, "Text", "Text", 0 )
    
    local Distance = 15

    hook.add( "think", "", function()
    
        for Index, Starfall in pairs( Programs ) do
        
            local Origin = chip():getPos() + Vector( 0, 0, 10 )
        
            local Yaw = ( 360 / table.count( Programs ) * Index ) + ( timer.curtime() * 5 )
            
            local Position = localToWorld( Vector( Distance, 0, 0 ), Angle(), Origin, Angle( 0, Yaw, 0 ) )
            
            Starfall:setFrozen( true )
            Starfall:getPhysicsObject():setPos( Position )
            Starfall:getPhysicsObject():setAngles( Angle() )
        
        end
    
    end)
    
    hook.add( "input", "", function( Input, Value )
        
        if not Value then return end
        if Input != "Text" then return end
        
        getCode( Value )
    
    end)

    function getCode( URL )
    
        try( function()
        
            local Found = string.find( URL, "github.com", 0 )
            
            if Found != nil then
            
                print( "Not a RAW Github file!" )
                return
            
            end
            
            http.get( URL, function( Body, Length, Headers, Code )
            
                local Information = {
                    
                    Code = Body
                    
                }
            
                C = prop.createSent( chip():getPos() + Vector( 0, 0, 10 ), Angle( 0 ), "starfall_processor", true, Information )
                
                Programs[ table.count( Programs ) + 1 ] = C
                
            end, nil )
        
        end, function( ErrorTable )
        
        
        
        end)
    
    end

end
