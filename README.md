# CapsLockLED for Antigravity 💡

**Turn your MacBook's or Keychron's Caps Lock light into a status indicator for the Antigravity AI CLI (`agy`).**

While Antigravity works on your code, the Caps Lock key's light blinks. When it needs your input or finishes, it signals differently — so you can look away from the screen and still know what's happening at a glance!

| The Caps Lock light does this… | …when |
| --- | --- |
| 🔵 **Slow blink** | Antigravity is working on your request |
| 🟠 **Fast blink** | Antigravity is waiting for you (a permission prompt, a question, or it's idle) |
| 🟢 **Two quick flashes, then off** | Antigravity finished responding |

> Your actual Caps Lock software state stays off the whole time — only the *light* is used. The app never reads what you type.

---

## 🌟 Credits & Acknowledgements
This project is a modified and enhanced version of an incredible original idea:
* **Original Idea & Concept:** [@escutarian on X/Twitter](https://x.com/escutarian/status/2078041595882922361?s=46)
* **Original Source Code (Claude version):** [devkriter/capsOS-Agent-Tracker](https://github.com/devkriter/capsOS-Agent-Tracker)

**Enhancements in this version:**
This version was adapted by the repository owner with the help of **Antigravity AI**. Key modifications made by Antigravity AI include:
1. **Antigravity (`agy`) Integration:** Completely rewrote the hook system to inject into `~/.zshrc`, replacing the old `~/.claude/settings.json` logic, so it works perfectly with the Antigravity CLI.
2. **Keychron & External Keyboard Support:** Enhanced the IOKit HID matching logic to flawlessly detect and control the Caps Lock LED on 3rd-party external keyboards (like Keychron K2 Max) via both 2.4GHz wireless dongles and wired USB connections.
3. **UI & Code Refactoring:** Rebranded menus, dialogs, and cleaned up the codebase to serve the Antigravity ecosystem.

---

## 🚀 Install (the easy way)

1. **Build the app:** Run `./build.sh` in the terminal to compile `CapsLockLED.app`.
2. **Move to Applications:** Move `CapsLockLED.app` to your `/Applications` folder and open it.
3. **Grant permission:** The first time it runs, click the menu bar icon → **"Open Input Monitoring Settings…"**, turn **CapsLockLED** on in the list.
   * *Note: If macOS bugs out and still says no LED is found, use the minus (`-`) button to remove the app from Input Monitoring, then use the plus (`+`) button to add it back, and restart the app.*
4. **Connect to Antigravity:** Click the menu bar icon → **"Set Up Antigravity Hooks"**. This will add a tiny wrapper to your `~/.zshrc`.
5. **Start a new terminal session**, type `agy`, and watch the Caps Lock light react! 🎉

---

## ⚙️ How it fits together (For Developers)

- `CapsLockLED.app` — a menu bar app (`LSUIElement`). Talks to the keyboard's HID LED element via IOKit (`IOHIDDeviceSetValue`) to toggle the Caps Lock light without changing the software Caps Lock state.
- `caps-signal` — a tiny CLI inside the bundle (`Contents/MacOS/caps-signal`). The `.zshrc` hooks call it to post a `DistributedNotificationCenter` message that the running app reacts to.
- `HookInstaller.swift` — The logic behind "Set Up Antigravity Hooks". It reads your `~/.zshrc` and appends a bash function wrapper for `agy` that calls `caps-signal working` before the agent runs, and `caps-signal done` when it exits.
