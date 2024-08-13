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
      print("[BetterBags: Gear Sets] "..message)
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
            if itemID and itemID > 0 then
               printChat("ID: " .. itemID)
               categories:AddItemToCategory(itemID, "Sets")
            else
               printChat("Invalid or missing item in Set " .. i .. ". ItemID: " .. tostring(itemID))
            end
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
