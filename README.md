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

---

## 💡 Inspiration

This project was **inspired by an existing note system** that served as a creative reference during development.  
All code, logic, and structure were **entirely rewritten from scratch** to ensure better performance, optimization, and maintainability while preserving the original idea of immersive in-game notes.

---

## 📜 License & Terms of Use

This resource is **100% free** and provided for educational and creative use within the FiveM community.  
Commercial resale, redistribution behind paywalls, or inclusion in paid script bundles is **strictly prohibited**.

You are allowed to:
- ✅ Use and modify this resource for personal or server use.
- ✅ Share it publicly **with proper credit** to **Gaijin Store**.
- ✅ Include it in open-source projects (with attribution).

You are **not** allowed to:
- ❌ Sell, rent, or offer this resource (or modified versions) for money.
- ❌ Re-upload it under a different name or author.
- ❌ Claim ownership or remove original credits.

By using this resource, you agree to follow the [Cfx.re Platform License Agreement](https://runtime.fivem.net/legal/) and the [Rockstar Community Guidelines](https://www.rockstargames.com/community-guidelines).

---

🖋️ **Author:** [Gaijin Store](https://github.com/Gaijin-Store)  
📅 **Version:** 1.1.2  
💬 For feedback or issues: open an [Issue](https://github.com/Gaijin-Store/gaijin-noteit/issues)

---
