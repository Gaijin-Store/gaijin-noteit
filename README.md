# 📌 NoteIt – Sticky Notes for FiveM

**NoteIt** is a lightweight and customizable sticky note system for FiveM, allowing players to place interactive notes anywhere in the world. Perfect for immersive RP scenarios, announcements, or marking important spots on the map.

---

## ✨ Features
- 📍 Place notes anywhere on the map
- ✏️ Customizable text with a configurable character limit
- ⚡ Optimized and lightweight for performance
- 🔄 Works with **ox_inventory** and **ox_target**
- 🔧 Fully configurable via `config.lua`

---

## 📦 Requirements
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target)

---

## 📂 Installation
1. Download and extract the `gaijin-noteit` folder into your server’s `resources` directory.
2. Ensure all dependencies are installed and started **before** this resource.
3. Add the following to your `server.cfg`:
    ```cfg
    ensure ox_lib
    ensure ox_inventory
    ensure ox_target
    ensure gaijin-noteit
    ```
4. **Add the item to ox_inventory**  
   In `ox_inventory/data/items.lua`, add:
    ```lua
    ['noteit'] = {
        label = 'Note-it',
        weight = 0,
        stack = true,
        close = true,
        description = 'A small sticky note for writing down messages.',
        client = { export = 'gaijin-noteit.useItem' }
    },
    ```
5. **Add the item image**  
   - Inside the `assets` folder of this resource, locate `noteit.png`.  
   - Copy it to:
     ```
     ox_inventory/web/images
     ```
   - Restart your server or refresh ox_inventory to apply.

---

## ⚙️ Configuration
All settings are inside `config.lua`:
- `DebugDev` → Enables extra developer logs
- `ItemName` → Item name in ox_inventory
- `TargetRadius` → Interaction radius for notes
- `TargetIcon` / `TargetLabel` → Icon and label for reading notes
- `PlaceLabel` → Label when placing notes
- `MaxTextLength` → Max characters per note