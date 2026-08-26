# 🥚 Egg Hatcher

An enhanced Roblox GUI script for automated egg placing and hatching with proper game integration.

## Features

✨ **User Interface**
- Searchable egg dropdown with 50+ egg types
- Customizable delays for pacing
- Position mode toggle (Line Left / Stacked)
- Auto-place and auto-hatch toggles
- Start/Stop button with keyboard shortcut (Press **P**)

🎮 **Game Integration**
- Safe remote function/event calling with error handling
- Configurable remote paths for any game
- Automatic fallback between RemoteFunction and RemoteEvent
- Detailed console logging for debugging

⚙️ **Automation**
- Batch place multiple eggs with custom delays
- Sequential hatching with timing control
- Real-time status updates

## Setup Instructions

### 1. **Find Your Game's Remote Events/Functions**

Open the game's **LocalScript** or **Module** that handles egg placement/hatching. Look for:
- `PlaceEgg` remote (usually in `ReplicatedStorage.Remotes`)
- `HatchEgg` remote (usually in `ReplicatedStorage.Remotes`)

Example:
```lua
-- Your game might have:
game.ReplicatedStorage.Remotes.PlaceEgg:InvokeServer(eggName)
game.ReplicatedStorage.Remotes.HatchEgg:InvokeServer(eggName)
```

### 2. **Update the Configuration**

Edit lines 8-9 in `EggHatcher.lua`:

```lua
-- ====== CONFIGURATION ======
local REMOTES_PATH = game.ReplicatedStorage:WaitForChild("Remotes") -- Adjust path as needed
local PLACE_EGG_REMOTE = REMOTES_PATH:WaitForChild("PlaceEgg") -- RemoteFunction or RemoteEvent
local HATCH_EGG_REMOTE = REMOTES_PATH:WaitForChild("HatchEgg") -- RemoteFunction or RemoteEvent
```

**If your remotes are elsewhere:**
- ServerStorage: `game:GetService("ServerStorage")`
- Custom folder: Adjust the path accordingly

### 3. **Inject the Script**

Run this in your Roblox game console (F9 or Ctrl+Shift+L):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/c2mdr4yg4p-spec/egg-hatcher/main/EggHatcher.lua"))()
```

Or paste `EggHatcher.lua` directly into a **LocalScript** in `StarterPlayer > StarterPlayerScripts`.

## Usage

### GUI Controls

| Control | Action |
|---------|--------|
| 🔍 Search Box | Filter eggs by name |
| ▼ Dropdown | Select an egg type |
| # Number of Eggs | How many eggs to place (1-13) |
| ⏱️ Place Delay | Seconds between each placement |
| ⏱️ Hatch Delay | Seconds between hatches |
| Position Toggle | Switch between "Line Left" or "Stacked" |
| ☐ Auto Place Eggs | Enable/disable auto-placing |
| ☐ Auto Hatch Eggs | Enable/disable auto-hatching |
| ▶ START / ⏹ STOP | Start/stop automation |

### Keyboard Shortcut

Press **P** to toggle automation on/off (when in-game).

## Examples

### Example 1: Place 5 eggs with 2-second delays
1. Select an egg from dropdown
2. Set "Number of Eggs" to `5`
3. Set "Place Delay" to `2`
4. Enable ☑ Auto Place Eggs
5. Click ▶ START (or press P)

### Example 2: Auto-hatch every 3 seconds
1. Enable ☑ Auto Hatch Eggs
2. Set "Hatch Delay" to `3`
3. Click ▶ START

## Troubleshooting

### "Remote not found" error
- ❌ Check that the remote exists in your game
- ❌ Verify the path is correct (use **Roblox Studio** to inspect the game's structure)
- ❌ Try printing available remotes:
  ```lua
  for _, v in ipairs(game.ReplicatedStorage.Remotes:GetChildren()) do
      print(v.Name)
  end
  ```

### Script doesn't place/hatch eggs
- ❌ Confirm remotes accept the parameters you're passing
- ❌ Check the game's console (F9) for error messages
- ❌ Look at the game's source to see the exact function signature

### GUI appears off-screen
- The script centers the GUI. Try resizing your game window or reloading.

## Customization

### Change keyboard shortcut (currently P)
Find this line and change `Enum.KeyCode.P` to another key:
```lua
if input.KeyCode == Enum.KeyCode.P then
```

### Add more eggs to the list
Edit the `eggs` table at the top:
```lua
local eggs = {
    "Egg", "Uncommon Egg", "Rare Egg", -- existing eggs
    "My Custom Egg",  -- add here
    -- ...
}
```

### Adjust GUI size
Modify the main frame dimensions:
```lua
main.Size = UDim2.fromOffset(360, 570)  -- width, height
```

## Security Notes

⚠️ **Anti-Cheat Risk**: Some games detect rapid automation. To avoid detection:
- Use realistic delays (2-5 seconds between actions)
- Don't place 1000 eggs instantly
- Vary the timing slightly
- Use "Stacked" position mode if it's less obvious

## License

Public domain. Use, modify, and distribute freely.

## Support

If you encounter issues:
1. Check the console (F9) for error messages
2. Verify the remote paths match your game
3. Try adjusting delays
4. Contact the game's developer for API documentation

---

**Happy egg hatching!** 🐣✨
