# Huz's 'the Overlays

A script for Mesen that adds overlays containing additional information and functionality for the romhack 'the (2025 ver).

# Usage

To use the script, open Mesen and go to the *Debug* dropdown menu, then *Script Window*. This will open a new window, on which you can either paste the script and then press the run button, or go to the *File* dropdown menu, then *Open*, and open the script file saved on your computer, which should then automatically run.

Inside the game, holding the **START** key will display the overlay menus, which can be cycled through with the **L** and **R** keys.

While **START** is being held, all other inputs will blocked from the going to the game, except for the **START** key itself, otherwise it would be impossible to send any **START** inputs to the game at all.

# Functionalities

## No Overlay

The first overlay, and the default when the script is loaded. It is a simple overlay designed to be completely hidden when inactive, so the player can focus entirely on the game.

## Warp Overlay

This allows the player to override what level the player will go to when the game tries to load another level.

It can be navigated with the **LEFT** and **RIGHT** keys, and it's options can be set with the **UP**, **DOWN**, **A** and **B** keys.

The player can turn the warp functionality on or off, and set the level ID to warp to on level change.

## Info Overlay

This overlay displays additional information about the game state.

Currently, it displays the current level, along with it's ID, and the music track that is currently playing.

# Future Updates

I would like to add the following updates in the future:

- A *ONCE* option, alternative to ON and OFF, that only warps the player once and then switches back to OFF. I tried to implement this, but it did not work due to the specifics of the level warping mechanism.
- An option to choose the *Target Entrypoint* for the level to warp to. Currently, I believe the entrypoint is decided based on the original level change destination, and can cause weird behavior when the overriden target level does not have said entrypoint, or if it is in a weird position. Figuring out the code that reads the entrypoint to be used would make this possible.
- A *Jukebox* overlay, where the player can change which music track is currently playing. While technically possible, it would be unsatisfying to implement as is, due to the game music files having multiple songs in each, that play at different moments, but on the same screen. The ability to choose which part of the track to play would make this feature fully possible.
- Add pictures and gifs to this page. My laptop battery is almost dead and I gotta wrap it up soon!!!!

# Known Issues

- There seems to be some issue with loading save states that causes the emulator to pause, possibly related to the memory execution hook related to the warp functionality. I don't know how to fix this but trying to load state again when the emulator pauses seems to work.
- The script might cause some lag, I'm not sure. Mesen itself has more lag than other emulators due to it's great debugging functionalities. If it really seems like the script itself is causing lag, please report.
