---@type string
local addonName = ...

---@type boolean
local isLoaded = false

---@class BetterBags: AceAddon
local BetterBags = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
assert(BetterBags, addonName .. " requires BetterBags")

---@class Categories: AceModule
local Categories = BetterBags:GetModule('Categories')

---@class Config: AceModule
local Config = BetterBags:GetModule('Config')

---@class Localization: AceModule
---@field G fun(self: AceModule, key: string): string
local L = BetterBags:GetModule('Localization')

-- Localization
local i18n = {
   enUS = {
      ["Gear Sets"] = "Gear Sets",
      ["GearSetsDescription"] = "This plugin categorizes all items that are a part of an equipment set into a single category named \"Gear Sets\".\n\nThere are currently no configurable options for this plugin."
   },
   frFR = {
      ["Gear Sets"] = "Ensembles",
      ["GearSetsDescription"] = "Ce plugin catégorise tous les objets faisant partie d'un ensemble d'équipement dans une seule catégorie nommée \"Ensembles\".\n\nIl n'y a actuellement aucune option configurable pour ce plugin."
   },
   ptBR = {
      ["Gear Sets"] = "Conjuntos",
      ["GearSetsDescription"] = "Este plugin categoriza todos os itens que fazem parte de um conjunto de equipamentos em uma única categoria chamada \"Conjuntos\".\n\nAtualmente, não há opções configuráveis para este plugin."
   },
   esES = {
      ["Gear Sets"] = "Conjuntos",
      ["GearSetsDescription"] = "Este plugin categoriza todos los elementos que forman parte de un conjunto de equipo en una sola categoría llamada \"Conjuntos\".\n\nActualmente, no hay opciones configurables para este plugin."
   },
   esMX = {
      ["Gear Sets"] = "Conjuntos",
      ["GearSetsDescription"] = "Este plugin categoriza todos los elementos que forman parte de un conjunto de equipo en una sola categoría llamada \"Conjuntos\".\n\nActualmente, no hay opciones configurables para este plugin."
   },
}
function L:G(key)
   local locale = GetLocale()
   local translation = i18n[locale] and i18n[locale][key]
   return translation or key
end

-- Add all items in equipment sets to the "Gear Sets" category
local function UpdateGearsets()
   if not isLoaded then return end

   Categories:WipeCategory(L:G("Gear Sets"))

   local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs()

   for _, i in pairs(equipmentSetIDs) do
      local itemIDs = C_EquipmentSet.GetItemIDs(i)
      if itemIDs then
         for _, itemID in pairs(itemIDs) do
            if itemID and itemID > 0 then
               Categories:AddItemToCategory(itemID, L:G("Gear Sets"))
            end
         end
      end
   end
end

-- Register event triggers
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
frame:SetScript("OnEvent", function(self, event, arg1, ...)
   if event == "ADDON_LOADED" and arg1 == addonName then
      isLoaded = true
      frame:UnregisterEvent("ADDON_LOADED")
      UpdateGearsets()
   elseif isLoaded and (event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "EQUIPMENT_SETS_CHANGED") then
      UpdateGearsets()
   end
end)

-- Register plugin with BetterBags
local options = {
   GearSetsOptions = {
      type = "group",
      name = L:G("Gear Sets"),
      order = 0,
      inline = true,
      args = {
         description = {
            type = "description",
            order = 0,
            name = L:G("GearSetsDescription"),
            fontSize = "large",
         },
      }
   }
}
Config:AddPluginConfig(L:G("Gear Sets"), options)
