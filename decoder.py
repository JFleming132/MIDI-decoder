from MIDI import MIDIFile, Events
from sys import argv
from math import ceil
f = open("output.txt", "w")

def clampOctave(octave):
    if octave <= 3:
        return 1
    elif octave >= 7:
        return 3
    else:
        return octave - 3

class ParsedEvent:
    time = 0
    event = 0
    track = 0
    note = 0
    octave = 0
    def setRawNote(self, rawNote):
        self.octave = clampOctave(rawNote.octave)
        self.note = rawNote.note
        if self.note == 0:
            print(rawNote)
        #take a raw note as a string, parse it, and set self.note and self.octave
        return
    def printEvent(self):
        #print event in format time:event:track:note:octave to a file
        str = "{}:{}:{}:{}:{}".format(self.time, self.event, self.track, self.note, self.octave)
        f.write(str + "\n")
        #print(str)

def getTime(n):
    return n.time

def parse(file):
    pe = []
    c=MIDIFile(file)
    c.parse()
    
    for idx, track in enumerate(c):
        track.parse()
        for event in track:
            if type(event) is Events.MIDIEvent:
                #print(event)
                if event.command == 0x80 or event.command == 0x90:
                    tempevent = ParsedEvent()
                    tempevent.time = ceil(event.time * .02)
                    tempevent.track = idx
                    print(event.message)
                    if event.message.onOff == "ON":
                        tempevent.event = 1
                    else:
                        tempevent.event = 0
                    tempevent.setRawNote(event.message.note)
                    pe.append(tempevent)
    #print(str(c))
    pe.sort(key=getTime)
    while(len(pe) > 0):
        temp=pe.pop(0)
        temp.printEvent()
    #add ALL events across ALL tracks to a heap of ParsedEvents, keyed and sorted by timestamp
    #while the heap is not empty
    #  pop the next ParsedEvent as p and call p.printEvent

parse(argv[1])