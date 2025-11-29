# 📦 Animated Container Textures Proof of Concept

A simple resource pack demonstrating the use of standard Minecraft animation files (`.mcmeta`) to animate container GUI textures (e.g., the inventory or chest screens).

This pack is intended as a silly and quick proof of concept to test if container GUI textures located in `assets/minecraft/textures/gui/container/` can be animated in the same way as item or block textures.

---

## 🛠️ How it Works

1.  The resource pack contains a texture file (e.g., `inventory.png`) and its corresponding animation instruction file (`inventory.png.mcmeta`) inside the `gui/container` directory.
2.  The `.mcmeta` file defines the frames, frametime, and other properties for the animation, just like an animated block or item. I very literally copied and pasted the `magma_block`'s default animation file and just renamed it.

---

## 📂 Included Files (Example Structure)

* `pack.mcmeta` (Standard resource pack descriptor)
* `assets/minecraft/textures/gui/container/inventory.png` (The animated texture strip) - note this is `256x768` as it contains three (probably poorly aligned because I both did this in paint and spent no more than seven seconds aligning them vertically)
* `assets/minecraft/textures/gui/container/inventory.png.mcmeta` (The animation instructions)

---

## 🧪 To Test

1.  Download and install the resource pack.
2.  Open your Inventory or a chest.
3.  Observe the background texture to see if the texture is animated by displaying different crude smiley faces I drew.
