# uptime
api for uptime.is site for time work
# Example
```nim
import asyncdispatch, uptime, json, strutils
let data = waitFor get_complex_reverse_sla("1h", @[8, 8, 8, 8, 8, 0, 0])
echo data
```

# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
