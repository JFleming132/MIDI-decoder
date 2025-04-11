# Introduction
This project is a Python script written to turn a raw MIDI file and its events into a text file containing only the relevant events. It accomplishes this with the MIDIFile library. The text file is formatted specifically to be read by control.lua,
which runs in the popular sandbox game Minecraft via the ComputerCraft: Tweaked mod.

# Explanation
The decoder.py parses the MIDI file into its MIDI events, stripping all meta events and ignoring the header for the sake of simplicity. Then, it parses each event, clamping all to fit within 3 octaves, since that is the range of the Create mod's pipe organ.
It places all the parsed events in an array and sorts them by their timestamp. Finally, it prints them all in order to output.txt.

control.lua reads output.txt line by line. If it's internal clock time does not match the timestamp of the next event, it waits. control.lua cannot send events at the exact same time, but since Minecraft game ticks are 1/20th of a second, there is plenty of time
to send all the events that could occur at any one timestamp. The events are sent via a table to a computer that is running receiveNote. Which computer the message is sent to depends on the octave, and is defined in octaveDNS at the top of control.lua. 

receiveNote first looks for all devices linked via router to it and places them in a table keyed by device name. This is so that it can later look up these devices by in constant time instead of in linear time, and improves the readability of the code.
Then, receiveNote enters a loop waiting for messages from control.lua. When it receives one, it parses the note, channel, and event type. If the event type is a noteOn event, it adds the channel to an array representing all the channels playing a certain note.
If and only if a note's array is not empty will the note play. This way, multiple channels of the midi file can queue the same note, and the same channel can queue multiple notes, at the same timestamp without conflict.

# Tutorial
To recreate this project, you will need Python, the MIDIFile python library, Minecraft, the Create mod, and the ComputerCraft: Tweaked mod. Links to those mods are here:
Create: https://www.curseforge.com/minecraft/mc-mods/create
ComputerCraft: Tweaked: https://modrinth.com/mod/cc-tweaked
Both of these mods include extensive documentation, either in-game or via their website.

Included in this repository is also an example MIDI file of Song of Storms from The Legend of Zelda: Ocarina of Time. I found it to be a really good example to show off the project. It was sourced from https://bitmidi.com/the-legend-of-zelda-ocarina-of-time-song-of-storms-mid.
Expect an example world file and a video demonstration in future builds.

To create your own steam pipe organ:
1. Run "decoder.py [pathname]" where pathname points to a MIDI file
2. Place the generated output.txt and control.lua in your Minecraft world's save file in [worldname]/computercraft/computers/[id], where [worldname] is your world's name and [id] is the ID of the computer you want to run control.lua.
3. Place the receiveNote.lua file the 3 [worldname]/computercraft/computers/[id] folders, where id is one of 3 computer ID that will be running receiveNote.lua. These computers will not need access to the output.txt file.
4. In your world, use wired modems and cables from Computercraft to connect the control computer with the 3 other computers. Ensure the modems are enabled.
5. For each receiveNote computer, place and connect via wired modems an array of 12 named Redstone Integrators. Each integrator should have a unique name corresponding to a musical note between and including F# and F.
6. On the front face of each integrator, build a Create mod steam engine by placing a fluid tank on top of a campfire, lava, active blaze burner, or similar heat source. Any will do, and lava is quieter than campfires.
7. Into each fluid tank, pipe water using the pump block and the pipe block. If at any point you need help, refer to the in-game Create mod's documentation by holding the ponder key on a block or item in the inventory ("W" by default). You will need to continuously pipe the water for the organ to work.
8. On top of each fluid tank, place a steam whistle. Keep right clicking the steam whistle with more steam whistles until the note it plays when powered via redstone matches the name of the Redstone Integrator it is connected to. Using Create's Engineer's Goggles can help see which note will play.
9. While holding the Create mod's wrench, right click each steam whistle until its octave matches the octave of the receiving computer it is associated with. Fatter pipes with an "sadder" face are the lowest octave, and thinner pipes with an "angrier" face are the highest.
10. On each receiving computer, run "receiveNote". Then on the control computer, run "control output.txt."

# Limitations
All instruments will be converted to a steam organ.
Due to the speed at which Minecraft runs, songs are automatically slowed down so that the clock counter on the controller computer can be in game ticks instead of microseconds.
All notes are clamped between octaves 4 and 6 by default. This behavior is defined in clampOctave in decoder.py.
In order to transfer the files directly into your save folder, you need access to the save folder, meaning it cannot be implemented on multiplayer servers. Utilizing pastebin to move the scripts and output.txt files onto the ComputerCraft computer is a viable workaround.
