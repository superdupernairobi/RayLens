---
sidebar_position: 1
---
# Intro
# Getting started
RayLens draws raycasts. You do the casting, it does the picture.

Example:
```lua
local rayLens = require(game.ReplicatedStorage.raylens)

local origin = Vector3.new(0, 5, 0)
local direction = Vector3.new(0, -50, 0)

rayLens.draw(origin, direction, workspace:Raycast(origin, direction))
```

## It draws and it does not cast
`draw` takes a `RaycastResult` you already have, if you have not cast one yet, pass `nil` and RayLens draws the ray at full length with no hit marker.

## One shot / per frame
Call `draw` once and you get one ray that expires after the `lifetime` you set (in seconds), the default is `8`. If you already draw something that moves, the suggested way is using `onDraw`. The callback runs on every frame and anything drawn inside it is cleared before the next call so you get a new picture each frame.

Example:
```lua
rayLens.onDraw(function()
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = camera.CFrame.LookVector * 100

    rayLens.draw(origin, direction, workspace:Raycast(origin, direction))
end)
```
To stop it, just run `rayLens.onDraw(nil)` and `rayLens.clear()`, these drop everything and stops the loop.

## Styling
Every draw takes an unrequired options table, so anything you leave out uses the default values.
| field            | default | notes                                    |
|------------------|---------|------------------------------------------|
| color            | orange  | none                                     |
| transparency     | 0.2     | none                                     |
| thickness        | 0.05    | lines only                               |
| radius           | 0.15    | marker and spheres                       |
| lifetime         | 8       | seconds, one shot draws                  |
| alwaysOnTop      | true    | draws through geometry                   |
| zIndex           | 1       | must be 1 or more to sit above parts     |
| shading          | XRay    | volume shapes                            |
| adornCullingMode | Never   | stops long rays fading out with distance |

## Install
Wally:
```toml
[dependencies]
raylens = "superdupernairobi/raylens@0.1.0"
```
Studio users: grab `RayLens.rbxm` from the latest release and insert it into ReplicatedStorage (or your packages folder).