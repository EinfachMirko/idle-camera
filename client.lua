LocalData = {}
LocalData.CurrentPlayerCamera = nil
LocalData.IsInVehicle = false

inactive = false  -- Variable to indicate if the player is inactive
lastInputTime = GetGameTimer()  -- Get the current game time in milliseconds



LocalData.CurrentPlayerCamera_CameraTo = nil
LocalData.CurrentPlayerCamera_CameraToPosition = {
    x = 0.0,
    y = 0.0,
    z = 0.0
}


function StartIdleCam(vehicle)
    if #Config.Cameras.CameraPositions < 2 then
        print("No valid camera positions found in config. Please add at least 2 positions.")
        return
    end
    if Config.EnableMusic == true then
        SendNUIMessage({
            type = "NUISound",
            payload = { Config.MusicFile }
        })
    end
    DoScreenFadeOut(1000)
    Wait(1000)
    CreateThread(function()

        local cameraIndex = 1
        if Config.RandomizedPositions == true then
            cameraIndex = math.random(1, #Config.Cameras.CameraPositions)
        end
        while inactive do
            if inactive == false then 
                StopCamera()
                return
            end
            -- Get the current camera config
            local cameraConfig = Config.Cameras.CameraPositions[cameraIndex]

            -- Calculate the "from" and "to" positions based on the vehicle's current position
            local fromPos = GetRelativePosition(vehicle, cameraConfig.from, cameraConfig.distance)
            local toPos = GetRelativePosition(vehicle, cameraConfig.to, cameraConfig.distance)
            
            -- Get the current rotation of the vehicle to set the camera direction
            local rot = GetEntityRotation(vehicle, 2)
            DoScreenFadeIn(1000)
            -- Start the camera transition, passing the vehicle to ensure the camera looks at it
            StartCameraTransition(fromPos, rot, toPos, rot, Config.CameraDuration, cameraConfig.fovFrom, cameraConfig.fovTo, vehicle)
            SendNUIMessage({
                type = "EnableCamera",
                payload = { true }
            })
            -- Wait for the transition duration
            Wait(Config.CameraDuration - 3000)
            DoScreenFadeOut(3000)
            if LocalData.CurrentPlayerCamera == nil then
                StopCamera()
                return
            end
            Wait(3000)
            if LocalData.CurrentPlayerCamera == nil then
                StopCamera()
                return
            end
            -- Move to the next camera index, loop back if at the end of the list
            cameraIndex = cameraIndex + 1
            if Config.RandomizedPositions == true then
                cameraIndex = math.random(1, #Config.Cameras.CameraPositions)
            end
            if cameraIndex > #Config.Cameras.CameraPositions then
                cameraIndex = 1
            end
        end
    end)
end

function StartCameraTransition(pos1, rot1, pos2, rot2, transitionTime, fov1, fov2, vehicle)
    -- Destroy any existing cameras
    if LocalData.CurrentPlayerCamera then
        DestroyCam(LocalData.CurrentPlayerCamera)
    end
    if LocalData.CurrentPlayerCamera_CameraTo then
        DestroyCam(LocalData.CurrentPlayerCamera_CameraTo)
    end
    -- Create the two cameras for the transition
    LocalData.CurrentPlayerCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos1.x, pos1.y, pos1.z, rot1.x, rot1.y, rot1.z, fov1, true, 2)
    LocalData.CurrentPlayerCamera_CameraTo = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos2.x, pos2.y, pos2.z, rot2.x, rot2.y, rot2.z, fov2, true, 2)

    -- Make both cameras point at the vehicle
    PointCamAtEntity(LocalData.CurrentPlayerCamera, vehicle, 0.0, 0.0, 0.0)
    PointCamAtEntity(LocalData.CurrentPlayerCamera_CameraTo, vehicle, 0.0, 0.0, 0.0)

    -- Activate the first camera and start the transition to the second camera
    SetCamActive(LocalData.CurrentPlayerCamera, true)
    RenderScriptCams(true, false, 0, true, true)

    SetCamActiveWithInterp(LocalData.CurrentPlayerCamera_CameraTo, LocalData.CurrentPlayerCamera, transitionTime, 100, 50)

    -- Wait for the transition to complete before moving on

end

function GetRelativePosition(vehicle, positionName, distance)
    local coords = GetEntityCoords(vehicle) -- Get the vehicle's current position
    local forward = GetEntityForwardVector(vehicle) -- Forward direction of the vehicle
    local up = vector3(0.0, 0.0, 1.0) -- Up direction (Z axis)

    -- Calculate the right vector by rotating the forward vector 90 degrees around the Z axis
    local right = vector3(-forward.y, forward.x, 0.0)

    -- Get vehicle dimensions to avoid clipping
    local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))
    local vehicleHeight = (maxDim.z - minDim.z) * 2  -- Verdopple die Höhe
    local vehicleWidth = (maxDim.x - minDim.x) * 2   -- Verdopple die Breite
    local vehicleLength = (maxDim.y - minDim.y)    -- Verdopple die Länge

    -- Define the offsets for each position relative to the vehicle
    local offsets = {
        -- Front positions, adjusted by vehicle width/length
        ["front-left"] = forward * distance - right * (vehicleWidth * 0.5 + distance * 0.5), -- Front-left corner
        ["front-middle"] = forward * distance, -- Directly in front of the car
        ["front-right"] = forward * distance + right * (vehicleWidth * 0.5 + distance * 0.5), -- Front-right corner
    
        -- Back positions, adjusted by vehicle width/length
        ["back-left"] = -forward * distance - right * (vehicleWidth * 0.5 + distance * 0.5), -- Back-left corner
        ["back-middle"] = -forward * distance, -- Directly behind the car
        ["back-right"] = -forward * distance + right * (vehicleWidth * 0.5 + distance * 0.5), -- Back-right corner
    
        -- Side positions, adjusted by vehicle width
        ["left"] = -right * (distance + vehicleWidth * 0.5), -- Directly to the left of the car
        ["right"] = right * (distance + vehicleWidth * 0.5), -- Directly to the right of the car
    
        -- Top positions, considering the height of the vehicle
        ["top-left"] = forward * distance - right * (vehicleWidth * 0.5 + distance * 0.5) + up * (vehicleHeight + distance), -- Top-left corner
        ["top-middle"] = up * (vehicleHeight + distance), -- Directly above the car
        ["top-right"] = forward * distance + right * (vehicleWidth * 0.5 + distance * 0.5) + up * (vehicleHeight + distance), -- Top-right corner
    
        -- Center (top of the vehicle or close to the ground)
        ["center"] = vector3(0.0, 0.0, vehicleHeight), -- Position right above the vehicle (for overview shots)
        
        -- Intermediate or diagonal positions
        ["front-left-diagonal"] = forward * distance * 0.7 - right * (vehicleWidth * 0.5 + distance * 0.7), -- Diagonal between front-left and middle
        ["front-right-diagonal"] = forward * distance * 0.7 + right * (vehicleWidth * 0.5 + distance * 0.7), -- Diagonal between front-right and middle
        ["back-left-diagonal"] = -forward * distance * 0.7 - right * (vehicleWidth * 0.5 + distance * 0.7), -- Diagonal between back-left and middle
        ["back-right-diagonal"] = -forward * distance * 0.7 + right * (vehicleWidth * 0.5 + distance * 0.7) -- Diagonal between back-right and middle
    }

    -- Return the calculated position based on the requested positionName
    return coords + offsets[positionName]
end

CreateThread(function()
    while true do
        Wait(1)
        if inactive == true then
        -- Get the player's vehicle and start the idle camera
            plvehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if plvehicle then
                if LocalData.CurrentPlayerCamera == nil and LocalData.IsInVehicle == false then
                    LocalData.IsInVehicle = true
                    StartIdleCam(plvehicle)
                    Wait(2000)
                    SetVehicleIndicatorLights(plvehicle, 0, true) -- Left indicator
                    SetVehicleIndicatorLights(plvehicle, 1, true) -- Right indicator
                end
            end
        else 
            if LocalData.CurrentPlayerCamera ~= nil and LocalData.IsInVehicle == true then
                StopCamera()
                LocalData.IsInVehicle = false
            end
        end
    end
end)

function StopCamera()
    if LocalData.CurrentPlayerCamera ~= nil then
        DestroyCam(LocalData.CurrentPlayerCamera)
    end
    if LocalData.CurrentPlayerCamera_CameraTo ~= nil then
        DestroyCam(LocalData.CurrentPlayerCamera_CameraTo)
    end
    LocalData.CurrentPlayerCamera_CameraTo = nil
    LocalData.CurrentPlayerCamera = nil
    SetVehicleIndicatorLights(plvehicle, 0, false) -- Left indicator
    SetVehicleIndicatorLights(plvehicle, 1, false) -- Right indicator
    DoScreenFadeIn(1000)
    RenderScriptCams(false, true, 1500, true, true)
    SendNUIMessage({
        type = "StopSound"
    })
    SendNUIMessage({
        type = "EnableCamera",
        payload = { false }
    })
end


-- Function to check for inactivity
CreateThread(function()
    while true do
        Citizen.Wait(1000)  -- Check every second

        -- Check for any input (movement or any other key)
        local playerPed = PlayerPedId()
        local playerIsInVehicle = IsPedInAnyVehicle(playerPed, false)
        
        -- Check keyboard inputs
        local isInputActive = IsControlPressed(0, 32) or  -- W key (move forward)
                              IsControlPressed(0, 33) or  -- S key (move back)
                              IsControlPressed(0, 34) or  -- A key (move left)
                              IsControlPressed(0, 35) or  -- D key (move right)
                              IsControlPressed(0, 44) or  -- Space key (jump)
                              IsControlPressed(0, 20) or  -- Shift key (sprint)
                              IsControlPressed(0, 29)      -- Tab key (cover)

        -- Check mouse movement (horizontal and vertical)
        local mouseX, mouseY = GetMouseDelta() -- Get mouse movement
        local isMouseMoving = (mouseX ~= 0 or mouseY ~= 0)

        if isInputActive or isMouseMoving then
            lastInputTime = GetGameTimer()  -- Reset the input timer
            if inactive then
                inactive = false  -- Player is active again
                print("Player is active again")
            end
        else
            -- Check for inactivity duration
            if (GetGameTimer() - lastInputTime) >= 10000 then  -- 5000 ms = 5 seconds
                if playerIsInVehicle and not inactive then
                    inactive = true  -- Set inactive to true if in a vehicle
                    print("Player is inactive for 5 seconds in a vehicle.")
                end
            end
        end
    end
end)

function GetMouseDelta()
    local mouseX = GetControlNormal(0, 1) -- Mouse X movement (horizontal)
    local mouseY = GetControlNormal(0, 2) -- Mouse Y movement (vertical)
    return mouseX, mouseY
end




-- Add Exports for:
-- IsPlayerInIdleCam(), reads out LocalData.CurrentPlayerCamera ~= nil then return true, else false
-- OnIdleCamStop(), gets called when LocalData.CurrentPlayerCamera gets changed to not nil
-- OnIdleCamStart(), gets called when LocalData.CurrentPlayerCamera gets changed to nil
-- StartIdleCam(), is a function to FadeOut the Screen and set LocalData.CurrentPlayerCamera to the specific created camera
-- StopIdleCam(), is a function to FadeOut the current Camera, set  LocalData.CurrentPlayerCamera to nil 