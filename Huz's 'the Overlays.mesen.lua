-- 'the script set by Huzzy.

-- Startup

if emu.getState()['consoleType'] ~= 'Snes' then
    emu.displayMessage("ERROR", "This script is for the romhack 'the on the Super Nintendo!")
    return
end

---- Validate rom.
local ROM_NAME = ""

for address = 0x80FFC0, 0x80FFD4 do
    ROM_NAME = ROM_NAME .. string.char(emu.read(address, emu.memType.snesDebug, false))
end

if ROM_NAME ~= "CORONATION DAY       " and ROM_NAME ~= "ABDICATION DAY       " then
    emu.displayMessage("WARNING", "Rom name is not CORONATION DAY or ABDICATION DAY. This script is meant for the romhack 'the (2025) only!")
end

-- Config

local UIButtons = {
    -- Input keys for UI-specific actions.
    Activate    = "start",
    ScreenLeft  = "l",
    ScreenRight = "r",
    UIConfirm   = "a",
    UICancel    = "b",
    UIUp        = "up",
    UIDown      = "down",
    UILeft      = "left",
    UIRight     = "right"
}

local UIFrames = {
    -- Number of frames for UI elements' related stuff.
    BlinkFastShow   = 25,
    BlinkFastHide   = 25,
    BlinkSlowShow   = 50,
    BlinkSlowHide   = 50,
    DelayFastInit   = 30,
    DelayFastAuto   =  7,
    DelayMediumInit = 30,
    DelayMediumAuto = 10,
    DelaySlowInit   = 40,
    DelaySlowAuto   = 20,
}

-- Constants

local LEVEL_NAMES = {
    -- ID to level name.
    [0x001] = "The Forest (\"I Believe\")",
    [0x002] = "Limbo",
    [0x003] = "The Forest (\"I Know\")",
    [0x004] = "Peach Forest (Tainted)",
    [0x006] = "Icy Forest (A)",
    [0x007] = "Red Forest",
    [0x008] = "The Forest (\"There's Nothing\")",
    [0x009] = "Icy Forest Cabin",
    [0x00C] = "Underwater (from Icy Forest Cabin)",
    [0x00D] = "Peach Forest (Clear w/ Shop)",
    [0x00E] = "The Forest (\"I Have\")",
    [0x010] = "The Heart (Door)",
    [0x011] = "Peach Forest (Tainted w/ Shop)",
    [0x012] = "The Heart",
    [0x013] = "Icy Forest (B)",
    [0x014] = "Peach Forest (Clear)",
    [0x015] = "Pink Forest",
    [0x016] = "Pages Forest",
    [0x017] = "Peach Forest Cabin (Weeds)",
    [0x018] = "Peach Forest Cabin (Walls)",
    [0x019] = "Peach Forest Cabin (Roof)",
    [0x01A] = "Peach Forest Cabin (End)",
    [0x01B] = "Burning Forest",
    [0x01C] = "For HE is King",
    [0x01E] = "Peaceful Forest",
    [0x01F] = "The Forest (\"Dear God\")",
    [0x028] = "Icy Forest (from Study)",
    [0x029] = "Icy Forest (from Treetops)",
    [0x035] = "Oracle Forest (2nd Time)",
    [0x040] = "Underground Lake (Ghost)",
    [0x04B] = "Oracle Forest (3rd Time)",
    [0x067] = "Oracle's Hut (2nd Time)",
    [0x072] = "Cabin Milk Bar (2nd Time)",
    [0x077] = "Dark Cabin (Both Locked Up)",
    [0x078] = "Oracle's Hut (3rd Time)",
    [0x0A3] = "Doorways Maze",
    [0x0A4] = "Doorways Maze (Language)",
    [0x0A5] = "Doorways Maze (Orange)",
    [0x0B7] = "Bloody Tower",
    [0x0B9] = "Oracle Forest (from Right)",
    [0x0C2] = "SNES",
    [0x0C3] = "Oracle Forest (1st Time)",
    [0x0C4] = "OurOS",
    [0x0C5] = "again?",
    [0x0C9] = "Burned Lab",
    [0x0CA] = "again? (Peach)",
    [0x0D3] = "Oracle Forest (Glitchy)",
    [0x0FB] = "Cabin Milk Bar (4th Time)",
    [0x103] = "Underground Lake",
    [0x105] = "The Forest (\"Are You Lost?\")",
    [0x108] = "Oracle's Basement",
    [0x10E] = "Return to Dust",
    [0x117] = "The Forest (\"My Last Day\")",
    [0x118] = "The Forest (Above)",
    [0x119] = "Gray Mario Forest",
    [0x128] = "Oracle's Hut (Glitchy)",
    [0x12A] = "Oracle's Hut (Gone)",
    [0x12E] = "Graves",
    [0x12F] = "Fridge",
    [0x132] = "Oracle's Hut (1st Time)",
    [0x137] = "Oracle Forest (Hug)",
    [0x138] = "Bloody Tower (Obscured Room)",
    [0x13E] = "Bloody Tower (Top)",
    [0x145] = "The Halo",
    [0x147] = "Big Mario Shadow House (Page)",
    [0x148] = "Cabin Milk Bar (1st Time)",
    [0x149] = "Cave Story (Isles)",
    [0x14A] = "Cave Story (Note Building)",
    [0x14B] = "Cave Story (Lake)",
    [0x14C] = "Big Mario Shadow House",
    [0x14D] = "Outside Study (Slopes)",
    [0x14E] = "The Mirror (Bookcase)",
    [0x14F] = "Weeds Maze (Bookcase)",
    [0x150] = "Cave Story (Climb)",
    [0x151] = "Weeds Maze",
    [0x152] = "Cave Story",
    [0x153] = "The Mirror",
    [0x154] = "The Mirror (Reflection)",
    [0x155] = "The Mirror (Building)",
    [0x156] = "Outside Study (Icy Forest)",
    [0x157] = "Study",
    [0x158] = "Monty Mole Hill",
    [0x159] = "Monty Mole Hill (Lake)",
    [0x15A] = "Monty Mole Hill (Black)",
    [0x15B] = "Peach Forest (Pure)",
    [0x15C] = "Monty Mole Hill (Bookcase)",
    [0x15D] = "Study (Hidden Room)",
    [0x15E] = "Abandoned Lab",
    [0x15F] = "Awakened Lab",
    [0x160] = "Awakened Lab (Above)",
    [0x161] = "The Lake",
    [0x163] = "It's Not Your Fault (Green)",
    [0x164] = "Abandoned Lab (Utensils)",
    [0x165] = "Awakened Lab (Utensils)",
    [0x166] = "Abandoned Lab (Clock)",
    [0x167] = "Awakened Lab (Clock)",
    [0x168] = "Abandoned Lab (Heart)",
    [0x169] = "Awakened Lab (Heart)",
    [0x16A] = "Awakened Lab (Grinder)",
    [0x16B] = "Cabin Milk Bar (3rd Time)",
    [0x174] = "Cabin Milk Bar (Stock)",
    [0x17A] = "Court Case",
    [0x17E] = "Cabin Milk Bar (from Stock)",
    [0x187] = "Dark Cabin (Pure Route)",
    [0x188] = "Pages Forest (Handbook)",
    [0x18B] = "Cabin Milk Bar (5th Time)",
    [0x190] = "Peach Forest Cabin (Stock)",
    [0x191] = "Peach Forest Cabin (Shortcut)",
    [0x19D] = "Milk Carton Forest (Red)",
    [0x1AB] = "Dark Cabin (from Treetops; Exit)",
    [0x1AC] = "Dark Cabin (from Treetops)",
    [0x1AD] = "End of Credits",
    [0x1AE] = "TV Ending (Peach)",
    [0x1AF] = "TV Ending (Mario)",
    [0x1B0] = "Waiting Room",
    [0x1B1] = "Cycles",
    [0x1B2] = "Cycles (Fucked Up)",
    [0x1B3] = "Cycles (Above)",
    [0x1B4] = "Treetops",
    [0x1B6] = "Dark Halls",
    [0x1B7] = "Underground Milk Bar",
    [0x1B8] = "The Last Gate",
    [0x1B9] = "Dark Cabin (from Dark Halls)",
    [0x1BA] = "Burning Forest (from Dark Halls)",
    [0x1BB] = "Limbo (from Dark Halls)",
    [0x1BC] = "Beginning of the End",
    [0x1BD] = "Ending Forest (Mario)",
    [0x1BE] = "Credits",
    [0x1BF] = "The House (after Sleep)",
    [0x1C0] = "The House",
    [0x1C1] = "Lighter Ending (Mario)",
    [0x1C2] = "Raining Forest",
    [0x1C3] = "Underground Cavern",
    [0x1C4] = "Flooded Desert",
    [0x1C5] = "Underground Cavern (from Milk Bar)",
    [0x1C6] = "Underground Cavern (Tape Recorder)",
    [0x1C7] = "Underground Cavern (from Right)",
    [0x1C8] = "Underground Cavern (Shop Voucher)",
    [0x1C9] = "Flooded Desert (Power Building)",
    [0x1CA] = "The House (Fireplace)",
    [0x1CB] = "The House (from Fireplace)",
    [0x1CC] = "Beginning of the End (w/ True Heart)",
    [0x1CD] = "Desert Village (Above)",
    [0x1CE] = "Underwater (from Desert Village; Blue)",
    [0x1CF] = "Outside White Lab / The Desert",
    [0x1D0] = "Desert Village",
    [0x1D1] = "Desert Village (Cave)",
    [0x1D2] = "Old King's Castle (Entrance)",
    [0x1D3] = "White Lab",
    [0x1D4] = "White Lab (Upper)",
    [0x1D5] = "Ending Forest (Peach)",
    [0x1D6] = "Burned Lab (Upper)",
    [0x1D7] = "Lighter Ending (Peach)",
    [0x1D8] = "White Lab (Peach Ending)",
    [0x1D9] = "Old King's Castle (Pits)",
    [0x1DA] = "Beginning of the End (Peach)",
    [0x1DB] = "Credits (Mario Lighter Ending)",
    [0x1DC] = "Waiting Room (Marios)",
    [0x1E2] = "Peach Shadow House (Page)",
    [0x1E3] = "Peach Shadow House",
    [0x1E4] = "Old King's Castle (Hallway)",
    [0x1E5] = "Old King's Castle (Purple)",
    [0x1EC] = "Old King's Castle (End)",
    [0x1FF] = "D3A's Computer Room"
}

local SONG_NAMES = {
    -- ID to song name.
    [0x03] = "3. The Crawl",
    [0x04] = "1. The Leap",
    [0x05] = "2. The World",
    [0x06] = "4. The Cellar",
    [0x07] = "8. The Dark",
    [0x08] = "9. The Beginning",
    [0x09] = "11. The Memory",
    [0x0A] = "6. The Death / 7. The Demise",
    [0x0B] = "5. The Ladder",
    [0x0C] = "13. The Mistake",
    [0x0D] = "12. The Rage",
    [0x0E] = "14. The End",
    [0x0F] = "18. The Sky",
    [0x10] = "10. The Inception",
    [0x11] = "19. The Halo",
    [0x12] = "20. The Trial",
    [0x13] = "25. The Betrayal",
    [0x14] = "21. The Cabin",
    [0x15] = "27. The Climb",
    [0x16] = "28. The Stare",
    [0x17] = "24. The Calm",
    [0x18] = "15. The Oracle",
    [0x19] = "16. The Anguish / 17. The Comfort",
    [0x1A] = "29. The Denial",
    [0x1B] = "39. The Continuation",
    [0x1C] = "33. The Addiction",
    [0x1D] = "34. The Crash",
    [0x1E] = "35. The Withdrawal",
    [0x1F] = "23. The Grasp",
    [0x20] = "31. The Time",
    [0x21] = "41. The Labyrinth",
    [0x22] = "43. The Vacancy",
    [0x23] = "30. The Change",
    [0x24] = "44. The Calling",
    [0x25] = "22. The Face",
    [0x26] = "40. The Furnace",
    [0x27] = "49. The Credits",
    [0x28] = "26. The Breakdown",
    [0x29] = "37. The Hill",
    [0x2A] = "45. The Freeze",
    [0x2B] = "36. The Study",
    [0x2C] = "32. The Cave",
    [0x2D] = "38. The Bait",
    [0x2E] = "46. The Stranding",
    [0x2F] = "47. The Noise",
    [0x30] = "50. The Dog",
    [0x31] = "51. The Revival",
    [0x32] = "52. The Radio",
    [0x33] = "42. The Laboratory",
    [0x34] = "48. The Mirror",
    [0x35] = "53. The Cycle",
    [0x36] = "54. The Repeat",
    [0x37] = "55. The Broadcast / 56. The Transmission",
    [0x38] = "55. The Broadcast / 56. The Transmission",
    [0x39] = "57. The Dreamer",
    [0x3A] = "58. The House",
}

local SCRIPT_VER = "v1.0 by Huz"

-- Enums

local UIStd = {
    -- Values for stardardization of UI elements.
    LineHeightShort = 8,
    LineHeightFull  = 12,
    ---- Positioning
    EdgeRight  = 256,
    EdgeBottom = 224,
    EdgeMargin = 5,
    ---- Colors
    MainColor       = 0xFFFFFF,
    SelectableColor = 0x8080FF,
    SelectedColor   = 0xFFFF00,
    ConfirmColor    = 0x00FF00,
    CancelColor     = 0xFF0000,
    OutlineColor    = 0x000000,
}

local UIScreens = {
    -- Enum of UI screens to navigate through.
    Hidden    = 1,
    Warp      = 2,
    LevelInfo = 3,
    LENGTH    = 3
}

local UIWarpOptions = {
    -- Enum of Warp screen options to navigate through.
    Mode   = 1,
    Digit1 = 2,
    Digit2 = 3,
    Digit3 = 4,
    LENGTH = 4
}

local UIWarpModes = {
    -- Enum of settings for warp functionality.
    Off    = 1,
    -- Once   = 2,
    On     = 2,
    LENGTH = 2
}

-- Global Variables

local G_ui_active   = false               -- Whether to fully display the UI or not.
local G_ui_pos      = UIScreens.Hidden    -- The currently selected UI screen.
local G_ui_warp_pos = UIWarpOptions.Mode  -- The currently selected option on the warp screen.

local G_warp_mode = UIWarpModes.Off  -- Setting to warp or not on level change.
local G_warp_id   = 0x001            -- Setting of ID of level to warp to.

local G_input_frames = {}  -- Number of frames that each input has been pressed for.

-- Functions

local function min(...)
    -- Simple min to avoid importing libraries.
    local minimum = select(1, ...)
    
    for index = 2, select('#', ...) do
        value = select(index, ...)
        
        if value < minimum then
            minimum = value
        end
    end
    
    return minimum
end

local function max(...)
    -- Simple max to avoid importing libraries.
    local maximum = select(1, ...)
    
    for index = 2, select('#', ...) do
        value = select(index, ...)
        
        if value > maximum then
            maximum = value
        end
    end
    
    return maximum
end

local function abs(value)
    -- Simple abs to avoid importing libraries.
    if value < 0 then
        return - value
    else
        return value
    end
end

local function drawStringEx(x, y, text, textColor, outlineColor, duration, delay)
    -- Draws text while faking an outline through 9 drawString calls.
    -- Also returns the X position the draw ended at, does not work with line wraps.
    textColor    = textColor    or 0xFFFFFF
    outlineColor = outlineColor or 0x000000
    duration     = duration     or 1
    delay        = delay        or 0

    emu.drawString(x + 1, y + 1, text, outlineColor, 0xFF000000, 0, duration, delay)
    emu.drawString(x + 1, y,     text, outlineColor, 0xFF000000, 0, duration, delay)
    emu.drawString(x + 1, y - 1, text, outlineColor, 0xFF000000, 0, duration, delay)
    emu.drawString(x,     y + 1, text, outlineColor, 0xFF000000, 0, duration, delay)
    emu.drawString(x,     y - 1, text, outlineColor, 0xFF000000, 0, duration, delay)
    emu.drawString(x - 1, y - 1, text, outlineColor, 0xFF000000, 0, duration, delay)
    emu.drawString(x - 1, y,     text, outlineColor, 0xFF000000, 0, duration, delay)
    emu.drawString(x - 1, y + 1, text, outlineColor, 0xFF000000, 0, duration, delay)

    emu.drawString(x,     y,     text, textColor,    0xFF000000, 0, duration, delay)

    return x + emu.measureString(text, maxWidth)['width']
end

local function displayBlink(frame, num_frames_show, num_frames_hide)
    -- Calculates if a blinking display should blink or not on a given frame.
    -- Starting on frame 1, a display will show for num_frames_show, then hide for num_frames_hide, and cycle between that.
    return ((frame - 1) % (num_frames_show + num_frames_hide)) < num_frames_show
end

local function pressWithDelay(frame, init_delay, auto_delay)
    -- Calculates if a button press should occur or not in a given frame.
    -- A press occurs on frame 1. If it's held, then it will occur again after init_delay frames and then again every auto_delay frames.
    return frame == 1 or frame > init_delay and (frame - (init_delay + 1)) % auto_delay == 0
end

-- Callbacks

local function uiDisplay()
    -- Draw active UI elements.
    if G_ui_active then
        -- Prepare text.
        local screen_name
        
        if G_ui_pos == UIScreens.Hidden then
            screen_name = "No Overlay"
        elseif G_ui_pos == UIScreens.Warp then
            screen_name = "Warp Overlay"
        else
            screen_name = "Info Overlay"
        end
        
        local l_msg = "<L"
        local r_msg = "R>"

        -- Draw text.
        local x_screen = (UIStd.EdgeRight - emu.measureString(screen_name)['width']) // 2
        local y        = 2 * UIStd.EdgeMargin + UIStd.LineHeightShort
        
        drawStringEx(x_screen, y, screen_name, UIStd.MainColor, UIStd.OutlineColor)
        
        if displayBlink(G_input_frames[UIButtons.Activate], UIFrames.BlinkSlowShow, UIFrames.BlinkSlowHide) then
            local xl = 2 * UIStd.EdgeMargin
            local xr = UIStd.EdgeRight - 2 * UIStd.EdgeMargin

            local r_align = emu.measureString(r_msg)["width"]

            drawStringEx(xl, y, l_msg, UIStd.MainColor, UIStd.OutlineColor)
            drawStringEx(xr - r_align, y, r_msg, UIStd.MainColor, UIStd.OutlineColor)
        end
    end

    -- Draw current UI screen.
    if G_ui_pos == UIScreens.Warp then
        -- Prepare text.
        local level_id_msg = string.format("%03X", G_warp_id)
        local level_msg    = string.format("→ %s", LEVEL_NAMES[G_warp_id] or "???")

        local oo_text, oo_color

        if G_warp_mode == UIWarpModes.Off then
            oo_text = "OFF"
            oo_color = UIStd.CancelColor
        -- elseif G_warp_mode == UIWarpModes.Once then
        --     oo_text = "ONCE"
        --     oo_color = UIStd.ConfirmColor
        else
            oo_text = "ON"
            oo_color = UIStd.ConfirmColor
        end

        local d1_color = UIStd.MainColor
        local d2_color = UIStd.MainColor
        local d3_color = UIStd.MainColor

        if G_ui_active then
            if displayBlink(abs(min(1, max(G_input_frames[UIButtons.UIRight], G_input_frames[UIButtons.UILeft]))), UIFrames.BlinkFastShow, UIFrames.BlinkFastHide) then
                -- Cursor blink.
                if G_ui_warp_pos == UIWarpOptions.Mode then
                    oo_color = UIStd.SelectedColor
                elseif G_ui_warp_pos == UIWarpOptions.Digit1 then
                    d1_color = UIStd.SelectedColor
                elseif G_ui_warp_pos == UIWarpOptions.Digit2 then
                    d2_color = UIStd.SelectedColor
                else
                    d3_color = UIStd.SelectedColor
                end
            end
        end

        -- Draw text.
        local x_level = UIStd.EdgeMargin
        local y_level = UIStd.EdgeBottom - UIStd.EdgeMargin
            
        local x_warp = UIStd.EdgeMargin
        local y_warp = y_level - UIStd.LineHeightFull

        x_warp = drawStringEx(x_warp, y_warp, "Warp ", UIStd.MainColor, UIStd.OutlineColor)
        drawStringEx(x_warp, y_warp, oo_text, oo_color, UIStd.OutlineColor)
        
        if G_ui_active or G_warp_mode ~= UIWarpModes.Off then
            x_warp = x_warp + emu.measureString("OFF")["width"]
        
            x_warp = drawStringEx(x_warp, y_warp, " ID ",                 UIStd.MainColor,  UIStd.OutlineColor)
            x_warp = drawStringEx(x_warp, y_warp, level_id_msg:sub(1, 1), d1_color,         UIStd.OutlineColor)
            x_warp = drawStringEx(x_warp, y_warp, level_id_msg:sub(2, 2), d2_color,         UIStd.OutlineColor)
            x_warp = drawStringEx(x_warp, y_warp, level_id_msg:sub(3, 3), d3_color,         UIStd.OutlineColor)

            drawStringEx(x_level, y_level, level_msg, UIStd.MainColor, UIStd.OutlineColor)
        end
    elseif G_ui_pos == UIScreens.LevelInfo then
        -- Prepare text.
        local level_id = emu.read16(0x00010B, emu.memType.snesDebug, false)
        local song_id  = emu.read(0x7E1DFB, emu.memType.snesDebug, false)

        local level_name = LEVEL_NAMES[level_id] or "???"
        local song_name  = SONG_NAMES[song_id] or "???"

        local level_msg = string.format("Level %03X: %s", level_id, level_name)
        local song_msg  = string.format("♪ %s", song_name)

        -- Draw text.
        local x_level = UIStd.EdgeMargin
        local y_level = UIStd.EdgeBottom - UIStd.EdgeMargin

        drawStringEx(x_level, y_level, level_msg, UIStd.MainColor, UIStd.OutlineColor)

        local x_song = x_level
        local y_song = y_level - UIStd.LineHeightFull

        drawStringEx(x_song, y_song, song_msg, UIStd.MainColor, UIStd.OutlineColor)
    end
end

local function uiInput()
    -- Processes inputs and updates the UI state.
    local input_state = emu.getInput(0)

    -- Update button frame counts.
    for button, pressed in pairs(input_state) do
        local button_frames = G_input_frames[button]

        if pressed then
            if button_frames ~= nil and button_frames > 0 then
                G_input_frames[button] = button_frames + 1
            else
                G_input_frames[button] = 1
            end
        else
            if button_frames ~= nil and button_frames < 0 then
                G_input_frames[button] = button_frames - 1
            else
                G_input_frames[button] = -1
            end
        end
    end

    -- Process UI inputs.
    if G_input_frames[UIButtons.Activate] > 0 then
        -- UI is active.
        G_ui_active = true

        -- Update screen.
        if G_input_frames[UIButtons.ScreenRight] > 0 then
            if pressWithDelay(G_input_frames[UIButtons.ScreenRight], UIFrames.DelaySlowInit, UIFrames.DelaySlowAuto) then
                G_ui_pos = ((G_ui_pos + 1) - 1) % UIScreens.LENGTH + 1
            end
        elseif G_input_frames[UIButtons.ScreenLeft] > 0 then
            if pressWithDelay(G_input_frames[UIButtons.ScreenLeft], UIFrames.DelaySlowInit, UIFrames.DelaySlowAuto) then
                G_ui_pos = ((G_ui_pos - 1) - 1) % UIScreens.LENGTH + 1
            end
        end

        -- Process current screen.
        if G_ui_pos == UIScreens.Warp then
            -- Process option selection.
            if G_input_frames[UIButtons.UIRight] > 0 then
                if pressWithDelay(G_input_frames[UIButtons.UIRight], UIFrames.DelayMediumInit, UIFrames.DelayMediumAuto) then
                    G_ui_warp_pos = ((G_ui_warp_pos + 1) - 1) % UIWarpOptions.LENGTH + 1
                end
            elseif G_input_frames[UIButtons.UILeft] > 0 then
                if pressWithDelay(G_input_frames[UIButtons.UILeft], UIFrames.DelayMediumInit, UIFrames.DelayMediumAuto) then
                    G_ui_warp_pos = ((G_ui_warp_pos - 1) - 1) % UIWarpOptions.LENGTH + 1
                end
            end

            -- Process screen options.
            if G_ui_warp_pos == UIWarpOptions.Mode then
                if G_input_frames[UIButtons.UIConfirm] == 1 or G_input_frames[UIButtons.UIUp] == 1 then
                    G_warp_mode = ((G_warp_mode + 1) - 1) % UIWarpModes.LENGTH + 1
                elseif G_input_frames[UIButtons.UICancel] == 1 or G_input_frames[UIButtons.UIDown] == 1 then
                    G_warp_mode = ((G_warp_mode - 1) - 1) % UIWarpModes.LENGTH + 1
                end
            else
                local digit_multiplier
                
                if G_ui_warp_pos == UIWarpOptions.Digit1 then
                    digit_multiplier = 0x100
                elseif G_ui_warp_pos == UIWarpOptions.Digit2 then
                    digit_multiplier = 0x010
                else
                    digit_multiplier = 0x001
                end
                
                if G_input_frames[UIButtons.UIUp] > 0 or G_input_frames[UIButtons.UIConfirm] > 0 then
                    if pressWithDelay(max(G_input_frames[UIButtons.UIUp], G_input_frames[UIButtons.UIConfirm]), UIFrames.DelayFastInit, UIFrames.DelayFastAuto) then
                        G_warp_id = (G_warp_id + digit_multiplier) % 0x200
                    end
                elseif G_input_frames[UIButtons.UIDown] > 0 or G_input_frames[UIButtons.UICancel] > 0 then
                    if pressWithDelay(max(G_input_frames[UIButtons.UIDown], G_input_frames[UIButtons.UICancel]), UIFrames.DelayFastInit, UIFrames.DelayFastAuto) then
                        G_warp_id = (G_warp_id - digit_multiplier) % 0x200
                    end
                end
            end
        end

        -- Discard other inputs to game while UI is active.
        for button, _ in pairs(input_state) do
            if button ~= UIButtons.Activate then
                input_state[button] = false
            end
        end

        emu.setInput(input_state, 0)
    else
        G_ui_active = false
    end
end

local function warpHandler()
    -- Called when level warp code is run, changing it to desired level instead.
    if G_warp_mode == UIWarpModes.Off then
        return
    end
    
    -- if G_warp_mode == UIWarpModes.Once then
    --     G_warp_mode = UIWarpModes.Off
    -- end
    
    local level_id = G_warp_id % 0x200 -- Safeguard.
    local level_code = (214013 * (level_id ~ (level_id >> 5)) + 492851) % 0xFFFFFD

    emu.write16(0x00000E, level_id, emu.memType.snesDebug)
    emu.write(0x70037D, (level_code      ) % 0x100, emu.memType.snesDebug)
    emu.write(0x70037E, (level_code >>  8) % 0x100, emu.memType.snesDebug)
    emu.write(0x70037F, (level_code >> 16) % 0x100, emu.memType.snesDebug)
end

-- Register callbacks.
emu.addEventCallback(uiDisplay, emu.eventType.startFrame)
emu.addEventCallback(uiInput, emu.eventType.inputPolled)
emu.addMemoryCallback(warpHandler, emu.callbackType.exec, 0xB0FDB0)

-- Startup message.
emu.displayMessage("INFO", string.format("'the script set %s loaded.", SCRIPT_VER))
emu.displayMessage("INFO", string.format("Press %s to activate UI.", string.upper(UIButtons.Activate)))
