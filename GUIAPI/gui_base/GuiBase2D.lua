local MetaUtils = require("GUIAPI/utils/MetaUtils")
local Vector2 = require("GUIAPI/datatype/Vector2")
local Instance = require("GUIAPI/Instance")


local GB2D, GB2D_meta = MetaUtils.newSelfIndexedMetatable()
local GB2D_objMeta = MetaUtils.newSelfIndexedTable()


local function new_GB2D()
  local newObj = Instance.new()
  newObj:subType(GB2D_objMeta, "GUIBase2d")

  newObj.absolutePosition = Vector2()
  newObj.absoluteSize = Vector2()

  newObj.needsUpdate = true

  return newObj
end
GB2D_meta.new = new_GB2D


function GB2D_meta.update(GB2D_obj)
  GB2D_obj.needsUpdate = false
  for _, child in pairs(GB2D_obj.children) do
    child:update()
  end
end
GB2D_objMeta.update = GB2D_meta.update


function GB2D_meta.draw(GB2D_obj)
  for _, child in pairs(GB2D_obj.children) do
    child:draw()
  end
end
GB2D_objMeta.draw = GB2D_meta.draw


return GB2D