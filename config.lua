Config = {}
Config.EnableFade = true -- Enable black fade transition after camera ends
Config.CameraDuration = 10000 -- how many seconds the view will be seen after each transition
Config.EnableMusic = true -- Enable Music, put a MusicFile aswell under webfiles/sounds
Config.RandomizedPositions = true -- enable to randomize all cameras
Config.EnableWarningLights = true -- currently no use
Config.EnableHeadLights = true -- currently no use
Config.EnableHeadLightsOnlyNights = true -- currently no use

Config.Cameras = {}
Config.Cameras.CameraPositions = {
    -- Needs atleast 2 entries to work!


    -- [[!!!]] EXPLANATION [[!!!]]
    -- distance = the camera distance to the vehicle, the player is in
    -- fovFrom = the fov at the start
    -- fovTo = the fov at the end
    -- from = use any of these:

    -- "front-left"             = Front-left corner
    -- "front-middle"           = Directly in front of the car
    -- "front-right"            = Front-right corner

    -- Back positions
    -- "back-left"              = Back-left corner
    -- "back-middle"            = Directly behind the car
    -- "back-right"             = Back-right corner

    -- Side positions
    -- "left"                   = Directly to the left of the car
    -- "right"                  = Directly to the right of the car

    -- Top positions
    -- "top-left"               = Top-left corner
    -- "top-middle"             = Directly above the car
    -- "top-right"              = Top-right corner

    -- Center (top of the vehicle or close to the ground)
    -- "center"                 = Position right above the vehicle (for overview shots)
    
    -- Intermediate or diagonal positions
    -- "front-left-diagonal"    = Diagonal between front-left and middle
    -- "front-right-diagonal"   = Diagonal between front-right and middle
    -- "back-left-diagonal"     = Diagonal between back-left and middle
    -- "back-right-diagonal"    = Diagonal between back-right and middle



    -- to = see above (from)

    -- Front-to-Left Side
    {
        distance = 4.0,
        fovFrom = 20.0,
        fovTo = 35.0,
        from = "front-middle",
        to = "front-left"
    },
    -- Left-to-Back
    {
        distance = 5.0,
        fovFrom = 30.0,
        fovTo = 40.0,
        from = "front-left",
        to = "left"
    },
    -- Back-to-Right Side
    {
        distance = 6.0,
        fovFrom = 40.0,
        fovTo = 35.0,
        from = "back-middle",
        to = "back-right"
    },
    -- Right Side Sweep
    {
        distance = 5.0,
        fovFrom = 30.0,
        fovTo = 30.0,
        from = "back-right",
        to = "right"
    },
    -- Right-to-Front
    {
        distance = 5.0,
        fovFrom = 35.0,
        fovTo = 40.0,
        from = "right",
        to = "front-right"
    },
    -- Top-down Front
    {
        distance = 8.0,
        fovFrom = 50.0,
        fovTo = 50.0,
        from = "top-middle",
        to = "front-middle"
    },
    -- Left-to-Top
    {
        distance = 7.0,
        fovFrom = 30.0,
        fovTo = 50.0,
        from = "left",
        to = "top-middle"
    },
    -- Back Sweep
    {
        distance = 4.5,
        fovFrom = 40.0,
        fovTo = 35.0,
        from = "back-left",
        to = "back-right"
    },
    -- Low Side Sweep (right)
    {
        distance = 3.5,
        fovFrom = 25.0,
        fovTo = 30.0,
        from = "right",
        to = "back-right"
    },
    -- Back-to-Top Transition
    {
        distance = 6.5,
        fovFrom = 45.0,
        fovTo = 50.0,
        from = "back-middle",
        to = "top-middle"
    }
}
