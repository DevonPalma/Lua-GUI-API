--------------
-- Overview --
--------------

--[[
Instance Class
Used as base to help define 'Classes'

has a node structure allowing for children/parents

allows for "types" to be defined alongside provideding
  a check to see if an instance is of a certain type
]]

-------------
-- Imports --
-------------
local MetaUtils = require("GUIAPI/utils/MetaUtils")

---------------
-- Class Def --
---------------
local Instance, Instance_meta = MetaUtils.newSelfIndexedMetatable()
local Instance_objMeta = MetaUtils.newSelfIndexedTable()

-----------------
-- Constructor --
-----------------

function Instance_meta.new()
  local newInstance = {}
  Instance_meta.insertMeta(newInstance, Instance_objMeta)

  newInstance.children = {}
  newInstance.parent = nil
  newInstance.types = {}

  newInstance:addType("Instance")

  return newInstance
end

-------------
-- Methods --
-------------


--[[ insertMeta(obj, metatable)
Copies the functions from arg[metatable] to
the metatable of arg[obj], will create a new
metatable if necessary
]]
function Instance_meta.insertMeta(obj, metatable)
  MetaUtils.newSelfIndexedMetatable(obj)
  MetaUtils.metatableToMetatable(obj, metatable, true)
end
-- allows obj:insertMeta(metatable)
Instance_objMeta.insertMeta = Instance_meta.insertMeta


--[[ addType(obj, type)
Adds arg[type] to the list of types in
arg[obj]
types are used for isA() function
]]
function Instance_meta.addType(obj, type)
  table.insert(obj.types, type)
end
-- allows obj:addType(type)
Instance_objMeta.addType = Instance_meta.addType


--[[ subType(obj, metatable, type)
-- a utility function to call insertMeta and addType
]]
function Instance_meta.subType(obj, metatable, type)
  Instance_meta.insertMeta(obj, metatable)
  Instance_meta.addType(obj, type)
end
-- allows obj:subType(metatable, type)
Instance_objMeta.subType = Instance_meta.subType


--[[ isA(obj, type)
-- checks if arg[obj] has arg[type] in its list
-- of types
]]
function Instance_meta.isA(obj, type)
  for _, v in pairs(obj.types) do
    if v == type then
      return true
    end
  end
  return false
end
-- allows obj:isA(type)
Instance_objMeta.isA = Instance_meta.isA


--[[ addChild(obj, child)
-- adds arg[child] to arg[obj]'s list of children
-- does not affect arg[obj]'s parent arg
]]
function Instance_meta.addChild(obj, child)
  if not child:isA("Instance") then
    error("Child is not of type Instance")
  end

  table.insert(obj.children, child)
end
-- allows obj:addChild(child)
Instance_objMeta.addChild = Instance_meta.addChild


--[[ removeChild(obj, child)
-- removes arg[child] from arg[obj]'s list of children
-- does not affect arg[obj]'s parent arg
]]
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
-- allows obj:removeChild(child)
Instance_objMeta.removeChild = Instance_meta.removeChild


--[[ setParent(obj, parent)
-- sets the parent of arg[obj] to arg[parent]
-- will also add arg[obj] to arg[parent]'s list of children
-- if a parent already exist's for arg[obj] will remove
-- arg[obj] from that parent's list of children
]]
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
-- allows obj:setParent(parent)
Instance_objMeta.setParent = Instance_meta.setParent


--[[ getChildren(obj, typeFilter)
-- returns arg[obj] list of children
-- if typeFilter is provided, it will return a
-- filtered list of children using obj:isA()
]]
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
-- allows obj:getChildren(typeFilter)
Instance_objMeta.getChildren = Instance_meta.getChildren

return Instance