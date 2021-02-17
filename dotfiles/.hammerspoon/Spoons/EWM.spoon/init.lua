-- Copyright (c) 2018 Miro Mannino
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge,
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

--- === MiroWindowsManager ===
---
--- With this script you will be able to move the window in halves and in corners using your keyboard and mainly using arrows. You would also be able to resize them by thirds, quarters, or halves.
--- 
--- Official homepage for more info and documentation: [https://github.com/miromannino/miro-windows-manager](https://github.com/miromannino/miro-windows-manager)
---
--- Download: [https://github.com/miromannino/miro-windows-manager/raw/master/MiroWindowsManager.spoon.zip](https://github.com/miromannino/miro-windows-manager/raw/master/MiroWindowsManager.spoon.zip)
---

function table_print (tt, indent, done)
  if tt == nil then
    print('NIL')
  else
    done = done or {}
    indent = indent or 0
    if type(tt) == "table" then
      for key, value in pairs (tt) do
        if type (value) == "table" and not done [value] then
          done [value] = true
          print(string.rep (" ", indent) .. string.format("[%s] => table", tostring (key)));
          print(string.rep (" ", indent+4) .. "(") -- indent it
          table_print (value, indent + 7)
          print(string.rep (" ", indent+4) .. ")") -- indent it
        else
          print(string.rep (" ", indent) .. string.format("[%s] => %s", tostring (key), tostring(value)))
        end
      end
    else
      print("(" .. tt .. ")")
    end
  end
end


local obj={}
obj.__index = obj


-- Metadata
obj.name = "EWM"
obj.version = "0.1"
obj.author = "Ed Vul <edwardvul@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"



obj.GRID = {X = 3, Y = 3}

obj._pressed = {X = {}, Y = {}}
for dim, size in pairs(obj.GRID) do
  for i=1,size,1 do
    obj._pressed[dim][i] = false
  end
end


obj._pressedGrid = {} -- [X][Y]
for i=1,obj.GRID.X,1 do
  obj._pressedGrid[i] = {}
  for j=1,obj.GRID.Y,1 do
    obj._pressedGrid[i][j] = false
  end
end

obj.specialLocations = {
  fullScreen = {x=0, y=0, w=1, h=1},
  streamCorner = {x=0, y=0, w=1280, h=720}
}


function obj:_setPosition(cell)
  if hs.window.focusedWindow() then 
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()
    win:move(cell, screen)
  end
end



function obj:_setCell(cell)
  if hs.window.focusedWindow() then 
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local screen = win:screen()
    current = hs.grid.get(win)
    for key,value in pairs(cell) do
      current[key] = value
    end
    hs.grid.set(win, current, screen)
  end
end


function obj:_doDimension(dim)
  if (dim == 'X' or dim == 'Y') then
    -- first, get region
    local min_i = nil
    local max_i = nil
    for index, value in ipairs(self._pressed[dim]) do 
      if value then
        max_i = index
        if min_i == nil then
          min_i = index
        end
      end
    end
    -- next, update cell
    local cell = {}

    if dim == 'X' then
        cell.x = min_i - 1
        cell.w = max_i - min_i + 1
      elseif dim == 'Y' then
        cell.y = min_i - 1
        cell.h = max_i - min_i + 1
    end

    -- finally, set win to desired cell.
    self:_setCell(cell)
  end
end

function obj:_doGrid()
  -- first find extent of pressed.
  local X = {min = nil, max = nil}
  local Y = {min = nil, max = nil}
  for x=1,self.GRID.Y,1 do
    for y=1,self.GRID.Y,1 do
      if self._pressedGrid[x][y] then
        if X.max == nil or x > X.max then
          X.max = x
        end
        if Y.max == nil or y > Y.max then
          Y.max = y
        end
        if X.min == nil or x < X.min then
          X.min = x
        end
        if Y.min == nil or y < Y.min then
          Y.min = y
        end
      end
    end
  end
  -- set cell
  self:_setCell({x = X.min - 1,
                 y = Y.min - 1,
                 w = X.max - X.min + 1,
                 h = Y.max - Y.min + 1})
end



function obj:bindHotkeys(hyper, mapping)
  hs.inspect(mapping)
  print("Bind Hotkeys for Eds window manager")
  -- first bind x dim and y dim separately
  for dim, size in pairs(self.GRID) do
    for i=1,(size),1 do
      if mapping[dim][i] then
        hs.hotkey.bindSpec({hyper, mapping[dim][i]}, 
                       function()
                        self._pressed[dim][i] = true
                        self:_doDimension(dim)
                       end,
                       function()
                        self._pressed[dim][i] = false
                       end)
      else
        print('!! No mapping found for: ' .. dim .. tostring(i))
      end
    end
  end

  -- bind grid based keys (convenient grid is [y][x])
  for x=1,self.GRID.X,1 do
    for y=1,self.GRID.Y,1 do
      if mapping.GRID[y][x] then
        hs.hotkey.bindSpec({hyper, mapping.GRID[y][x]}, 
                       function()
                        self._pressedGrid[x][y] = true
                        self:_doGrid()
                       end,
                       function()
                        self._pressedGrid[x][y] = false
                       end)
      else
        print('!! No mapping found for GRID: (' .. x .. ',' .. y .. ')')    
      end
    end
  end

  -- bind specialty designations
  for name, cell in pairs(self.specialLocations) do
    if mapping[name] then
      hs.hotkey.bindSpec({hyper, mapping[name]}, 
                     function()
                      self:_setPosition(cell)
                     end)
    else
        print('!! No mapping found for: ' .. name)
    end
  end

  hs.hotkey.bindSpec({hyper, mapping['screenEast']},
    function()
      hs.window.focusedWindow():moveOneScreenEast()
    end)
  hs.hotkey.bindSpec({hyper, mapping['screenWest']},
    function()
      hs.window.focusedWindow():moveOneScreenWest()
    end)
end

function obj:init()
  print("Initializing Ed's Windows Manager")
  hs.grid.setGrid(self.GRID.X .. 'x' .. self.GRID.Y)
  hs.grid.MARGINX = 0
  hs.grid.MARGINY = 0
end

return obj
