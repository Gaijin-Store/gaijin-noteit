Config = {}

-- 🔧 Debug
Config.DebugDev = true -- Enable extra logs and test features (disable in production)

-- 📦 Item used to activate NoteIt (ox_inventory)
Config.ItemName = 'noteit'

-- 🎯 Placement and reading settings
Config.PlaceRadius   = 10.5   -- Radius for the "paste" zone (ox_target)
Config.ReadDistance  = 12.0   -- Maximum distance to read a note
Config.MaxLocalNotes = 200    -- Limit of locally stored notes

-- 🖼 Appearance in ox_target
Config.TargetIcon  = 'fas fa-sticky-note'   -- Icon shown in third-eye
Config.TargetLabel = 'Read note'            -- Label when interacting to read
Config.PlaceLabel  = 'Paste the note here'  -- Label when choosing placement

-- ✏️ Note text
Config.MaxTextLength = 160 -- Maximum number of characters per note
