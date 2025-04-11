octaveDNS = {0, 1, 2, 0, 0, 0}
f = fs.open(arg[1], "r")
line = f.readLine()
clktime = 0
function parse(str)
    print(str)
    words = {}
    for word in string.gmatch(str, "[^:]+") do
        words[#words + 1] = word
        --print(word)
    end
    msg = {}
    msg["time"] = tonumber(words[1])
    if words[2]=="1" then
        msg["event"] = true
    else
        msg["event"] = false
    end
    msg["channel"] = tonumber(words[3])
    msg["note"] = words[4]
    msg["octave"] = tonumber(words[5])
    --print(msg["time"])
    return msg
end

while line do
    msg = parse(line)
    --print(msg["note"])
    --print(msg["time"])
    while clktime < msg["time"] do
        sleep(.05)
        --print(clktime)
        clktime = clktime + 1
    end
    octave = msg["octave"]
    msg["octave"] = nil
    rednet.send(octaveDNS[octave], msg)
    line = f.readLine() 
end
