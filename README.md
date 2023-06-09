# Draconic Evolution Fusion Crafting AutoCrafter

## Requirements

This program requires AdvancedPeripherals to work. You will need the following items:

-   `(3 + (injector count))` wired modems
-   1 advanced computer
-   1 redstone injector
-   Enough network cable to connect between the modems
-   A Fusion Crafting setup

## Setting up

1. Place the redstone injector 2 blocks below the crafting core, with the front of the injector facing the crafting core. Make sure that there is a block that can transfer a redstone signal under the crafting core. (Recommended: place the redstone injector before the crafting core to make sure it faces the crafting core after it is placed)
2. Connect a modem each fusion crafting injector, one to the redstone injector, one any side of the crafting core (except the bottom block), and one to the computer (Make sure to right click each modem and that it turns red so that you know that it's connected to the network)
3. Join the modems with network cables
4. Run the following commands to install the program:

```
pastebin get LRBGKcyG install.lua
install
```

5. Edit the config performing the following changes (Just run `edit config.json` and press control to save changes or exit):

-   Change the `input inventory` to your input inventory's network id.
-   Change the `output inventory` to your output inventory's network id.
    (It tells you the network id in chat when you right clicked the modem to connect it into the network. You can click to copy it from chat)
-   (Optional) Add any additional recipe you may want to have.

6. Run the following command to start the program:

```
startup
```

## Updating the program

1. Press the terminate button on the top left of the computer's screen
2. Run the following commands:

```
install
startup
```
