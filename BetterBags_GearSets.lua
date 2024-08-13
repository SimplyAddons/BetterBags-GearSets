---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
---@class Categories: AceModule
local categories = addon:GetModule('Categories')
---@class Localization: AceModule
local L = addon:GetModule('Localization')
-------------------------------------------------------
local debug = false
-------------------------------------------------------
local function printChat(message)
   if debug then
      print("[BetterBags Gearsets] "..message)
   end
end
-------------------------------------------------------
local function UpdateGearsets()
   local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()

   for _, i in pairs(equipmentSetIDs) do
      printChat("Set " .. i)
      local itemIDs = C_EquipmentSet.GetItemIDs(i)
      if itemIDs then
         for _, itemID in pairs(itemIDs) do
            printChat("ID: " .. itemID)
            categories:AddItemToCategory(itemID, "Sets")
         end
      else
         printChat("Missing Set " .. i .. ".")
      end
   end
end

-- Register player login and equipment change events
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
frame:SetScript("OnEvent", function(self, event, ...)
   printChat("Event Fired: " .. event)
   UpdateGearsets()
end)