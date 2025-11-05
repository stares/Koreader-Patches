local FileManagerShortcuts = require("apps/filemanager/filemanagershortcuts")
local UIManager = require("ui/uimanager")
local InfoMessage = require("ui/widget/infomessage")
local lfs = require("libs/libkoreader-lfs")
local _ = require("gettext")

if not FileManagerShortcuts.onGotoNamedShortcut then
    function FileManagerShortcuts:onGotoNamedShortcut(shortcut_name)
        for folder, item in pairs(self.folder_shortcuts) do
            if item.text == shortcut_name then
                if lfs.attributes(folder, "mode") == "directory" then
                    if self.ui.file_chooser then
                        self.ui.file_chooser:changeToPath(folder)
                    else 
                        self.ui:onClose()
                        self.ui:showFileManager(folder .. "/")
                    end
                    return true
                else
                    UIManager:show(InfoMessage:new{
                        text = _("Shortcut folder no longer exists."),
                    })
                    return false
                end
            end
        end
        UIManager:show(InfoMessage:new{
            text = _("Shortcut not found."),
        })
        return false
    end
end


local original_run = UIManager.run
UIManager.run = function(self)
    local Dispatcher = require("dispatcher")
    Dispatcher:init()
    
    -- Register your shortcuts
    Dispatcher:registerAction("goto_Screenshots_shortcut",
        {category="none", event="GotoNamedShortcut", arg="Screenshots", title=_("Screenshots"), filemanager=true})
    -- Add as much as you want
	
    return original_run(self)
end
