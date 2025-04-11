rednet.open("left")
redprs = { peripheral.find("redstoneIntegrator") }
dns = {}
activeNotes = {}
for _, redpr in pairs(redprs) do
    print(redpr.getName())
    dns[redpr.getName()] = redpr
    redpr.setOutput("front", false)
end

function handleEvent(msg)
    if msg["event"] == true then
        --print("turning on note")
        if activeNotes[msg["note"]] == nil then
            activeNotes[msg["note"]] = {msg["channel"]}
            --print(msg["note"])
            
        else
            table.insert(activeNotes[msg["note"]], msg["channel"])
        end
        if #activeNotes[msg["note"]] >= 1 then
            dns[msg["note"]].setOutput("front", true)
        end
    else
        if activeNotes[msg["note"]] == nil then
            --print("nil active notes. adding channel.")
            activeNotes[msg["note"]] = {}
            activeNotes[msg["note"]][1] = msg["channel"]
            --print(activeNotes[msg["note"]])
        end
        for i = 1, #(activeNotes[msg["note"]]) do
            if activeNotes[msg["note"]][i] == msg["channel"] then
                table.remove(activeNotes[msg["note"]], i)
                break
            end
        end
        if #activeNotes[msg["note"]] == 0 then
            dns[msg["note"]].setOutput("front", false)
        end
    end
end

while true do
    id, msg = rednet.receive()
    --print(msg["event"])
    --print(msg["note"])
    --print(msg["channel"])
    handleEvent(msg)
end
