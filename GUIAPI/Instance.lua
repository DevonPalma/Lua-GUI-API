local MetaUtils = require("GUIAPI/utils/MetaUtils")

local Instance, Instance_meta = MetaUtils.newSelfIndexedMetatable()
local Instance_objMeta = MetaUtils.newSelfIndexedTable()

function Instance_meta.new()
  local obj = {}
  Instance_meta.insertMeta(obj, Instance_objMeta)

  obj.children = {}
  obj.parent = nil
  obj.types = {}

  obj:addType("Instance")

  return obj
end


function Instance_meta.insertMeta(obj, meta)
  MetaUtils.newSelfIndexedMetatable(obj)
  MetaUtils.metatableToMetatable(obj, meta, true)
end
Instance_objMeta.insertMeta = Instance_meta.insertMeta

function Instance_meta.addType(obj, type)
  table.insert(obj.types, type)
end
Instance_objMeta.addType = Instance_meta.addType


function Instance_meta.subType(obj, metatable, type)
  Instance_meta.insertMeta(obj, metatable)
  Instance_meta.addType(obj, type)
end
Instance_objMeta.subType = Instance_meta.subType

function Instance_meta.isA(obj, type)
  for _, v in pairs(obj.types) do
    if v == type then
      return true
    end
  end
  return false
end
Instance_objMeta.isA = Instance_meta.isA

function Instance_meta.addChild(obj, child)
  if not child:isA("Instance") then
    error("Child is not of type Instance")
  end

  table.insert(obj.children, child)
end
Instance_objMeta.addChild = Instance_meta.addChild

function Instance_meta.removeChild(obj, child)
  if not child:isA("Instance") then
    error("Child is not of type Instance")
  end

  for i, v in pairs(obj.children) do
    if v == child then
      table.remove(obj.children, i)
      return true
    end
  end
  return false
end
Instance_objMeta.removeChild = Instance_meta.removeChild

function Instance_meta.setParent(obj, parent)
  if parent == nil or (not parent:isA("Instance")) then
    error("Parent is not of type Instance")
  end

  if obj.parent ~= nil then
    obj.parent:removeChild(parent, obj)
  end

  obj.parent = parent
  parent:addChild(obj)
end
Instance_objMeta.setParent = Instance_meta.setParent

function Instance_meta.getChildren(obj, typeFilter)
  if typeFilter == nil then
    return obj.children
  end

  local filteredChildren = {}

  for _, child in pairs(obj.children) do
    if child:isA(typeFilter) then
      table.insert(filteredChildren, child)
    end
  end

  return filteredChildren
end
Instance_objMeta.getChildren = Instance_meta.getChildren

return Instance