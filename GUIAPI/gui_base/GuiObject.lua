
local GB2D = require "GUIAPI/gui_base/GUIBase2d"
local MathUtils = require "GUIAPI/utils/MathUtils"
local MetaUtils = require "GUIAPI/utils/MetaUtils"
local Vector2 = require "GUIAPI/datatype/Vector2"
local UDim2 = require "GUIAPI/datatype/UDim2"




local GuiObject, GuiObject_meta = MetaUtils.newSelfIndexedMetatable()
local GuiObject_objMeta = MetaUtils.newSelfIndexedTable()


function GuiObject_meta.new()
  local newObject = GB2D.new()
  newObject:subType(GuiObject_objMeta, "GuiObject")

  newObject.active = true
  newObject.anchorPoint = Vector2()
  newObject.position = UDim2()
  newObject.size = UDim2()
  newObject.visible = true
  newObject.ZIndex = 0

  return newObject
end

local vec0 = Vector2()
local vec1 = Vector2(1, 1)

function GuiObject_meta.update(obj)
  local needsUpdate = obj.needsUpdate
  if needsUpdate then
    local parent = obj.parent
    if parent == nil or (not parent:isA("GUIBase2d")) then
      error("No GUIBase2d parent was found, could not fix GuiObject's coordinates")
    end

    local pSize = parent.absoluteSize
    local pPos = parent.absolutePosition

    obj.absoluteSize = MathUtils.map(
      obj.size:getScaleVector(),
      vec0, vec1,
      vec0, pSize
    ) + obj.size:getOffsetVector()

    local anchorOffset = obj.absoluteSize * obj.anchorPoint

    obj.absolutePosition = MathUtils.map(
      obj.position:getScaleVector(),
      vec0, vec1,
      pPos, pPos + pSize
    ) + obj.position:getOffsetVector() - anchorOffset + pPos
  end

  -- Super function call
  GB2D.update(obj)

  if needsUpdate then
    obj.absoluteSize = obj.absoluteSize:floor()
    obj.absolutePosition = obj.absolutePosition:floor()
  end
end
GuiObject_objMeta.update = GuiObject_meta.update


function GuiObject_meta.draw(obj)
  if obj.active then
    GB2D.draw(obj)
  end
end
GuiObject_objMeta.draw = GuiObject.draw

return GuiObject