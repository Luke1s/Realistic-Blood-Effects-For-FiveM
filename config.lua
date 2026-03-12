Config = {}

-- Forced on for everyone when the resource starts
Config.DefaultEnabled = true

-- Admin ACE permission required to toggle it
-- Give this with: add_ace group.admin bloodcleanup.toggle allow
Config.AdminAce = "bloodcleanup.toggle"

-- Blood cleanup settings
Config.ScanRadius = 80.0
Config.CleanupRadius = 0.9
Config.IntervalMs = 250

-- Command + keybind
Config.ToggleCommand = "bloodcleanup"
Config.DefaultKey = "F10"

-- Notifications
Config.NotifyEnabled = "Blood pool cleanup enabled"
Config.NotifyDisabled = "Blood pool cleanup disabled"