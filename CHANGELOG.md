# Changelog

## 0.1.0

Initial release:

- `draw(origin, direction, result, options)` draws a cast that hit, or one that missed when `result` is nil
- `ray(origin, direction, options)` draws a ray with no result
- `line(from, to, options)` draws between two points
- `box`, `sphere`, `cone`, and `cylinder` are for shape casts and volumes
- `onDraw(callback)` runs a render loop callback, clearing the previous frame first
- `clear()` removes everything and stops the loop
- Adornments are pooled per class and reused across draws
- Defaults: 8 second lifetime, orange, XRay shading, draws through geometry
- Out of range options error with the field and the value in the message