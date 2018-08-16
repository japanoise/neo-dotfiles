-- WORDGRINDER.LUA SETTINGS FILE
-- Written with 0.7.1 in mind

-- Global settings (For pre-patch versions)
-- Always enable widescreen mode
GlobalSettings.lookandfeel.enabled = true
-- Nice and wide!
GlobalSettings.lookandfeel.maxwidth = 100
-- Non-dense paragraphs (these are easier to read imo)
GlobalSettings.lookandfeel.denseparagraphs = false
-- Save and update global settings
SaveGlobalSettings()
UpdateDocumentStyles()

-- Emacs-ish bindings
-- Note that wg doesn't support meta-bindings, so these are a bit gimped.
OverrideKey("^C", "FQ") -- quit
OverrideKey("^Y", "EP") -- paste
OverrideKey("^W", "ZDW") -- delete word
OverrideKey("^_", "Eundo") -- undo
OverrideKey("^N", "ZD") -- Movement
OverrideKey("^P", "ZU")
OverrideKey("^F", "ZR")
OverrideKey("^B", "ZL")
OverrideKey("^A", "ZH") -- BOL
OverrideKey("^E", "ZE") -- EOL
OverrideKey("^V", "ZPGDN") -- Page Down
OverrideKey("^Z", "ZPGUP") -- Page Up

-- Goofy bindings
-- Close to C-c on dvorak; which is CUA's copy.
OverrideKey("^R", "EC") -- Copy
OverrideKey("^L", "ET") -- Cut
-- On dvorak, it's the same as qwerty ^B
OverrideKey("^X", "SB") -- Bold
-- ^J is known behaviour relating to newlines (e.g. indented newlines in uemacs & gomacs)
OverrideKey("^J", "SP") -- Paragraph settings
