
local GB2D = require "GUIAPI/gui_base/GUIBase2d"
local MathUtils = require "GUIAPI/utils/MathUtils"
local MetaUtils = require "GUIAPI/utils/MetaUtils"
local Vector2 = require "GUIAPI/datatype/Vector2"
local UDim2 = require "GUIAPI/datatype/UDim2"

local GuiObject, GuiObject_meta = MetaUtils.newSelfIndexedMetatable()
local GuiObject_objMeta = MetaUtils.newSelfIndexedTable()

function GuiObject_meta.new()
  local obj = GB2D.new()
  obj:subType(GuiObject_objMeta, "GuiObject")

  obj.active = true
  obj.anchorPoint = Vector2()
  obj.position = UDim2()
  obj.size = UDim2()
  obj.visible = true
  obj.ZIndex = 0

  return obj
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