-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
CombatIndicatorTest = {}
 
-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
CombatIndicatorTest.name = "CombatIndicatorTest"
 
-- Next we create a function that will initialize our addon
function CombatIndicatorTest:Initialize()
    self.inCombat = IsUnitInCombat("player") 
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState) 
    self.savedVariables = ZO_SavedVars:New("CombatIndicatorSavedVariables", 1, nil, {}) 
    self:RestorePosition()
    d('Combat Indicator Test Addon loaded!')
end


-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function CombatIndicatorTest.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == CombatIndicatorTest.name then
    CombatIndicatorTest:Initialize()
  end
end

function CombatIndicatorTest.OnPlayerCombatState(event, inCombat)
  -- The ~= operator is "not equal to" in Lua.
  if inCombat then
    d("Entering combat.")
  else
    d("Exiting combat.")
  end
  if inCombat ~= CombatIndicatorTest.inCombat then
    -- The player's state has changed. Update the stored state...
    CombatIndicatorTest.inCombat = inCombat
    -- ...and then update the control.
    CombatIndicatorTestUI:SetHidden(not inCombat)
  end
end

function CombatIndicatorTest.OnIndicatorMoveStop()
  CombatIndicatorTest.savedVariables.left = CombatIndicatorTestUI:GetLeft()
  CombatIndicatorTest.savedVariables.top = CombatIndicatorTestUI:GetTop()
end

function CombatIndicatorTest:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  CombatIndicatorTestUI:ClearAnchors()
  CombatIndicatorTestUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(CombatIndicatorTest.name, EVENT_ADD_ON_LOADED, CombatIndicatorTest.OnAddOnLoaded)
