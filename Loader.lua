print("=== SKRIPT WIRD GESTARTET ===")

local validKeys = {
    "TEST-KEY-456",
    "KEY-ABC-123"
}

-- Wir simulieren hier einfach einen Key zum Testen
local inputKey = "TEST-KEY-456" 

print("1. Text steht auf: Prüfe...")
task.wait(1)
print("2. 1 Sekunde ist vorbei. Starte Suche...")

local keyIsValid = false

for _, validKey in ipairs(validKeys) do
    print("Vergleiche: " .. inputKey .. " mit " .. validKey)
    if string.lower(inputKey) == string.lower(validKey) then
        keyIsValid = true
        print("3. KEY GEFUNDEN!")
        break
    end
end

if keyIsValid then
    print("4. ✅ ERFOLG! Das System funktioniert!")
else
    print("4. ❌ FEHLER! Key war falsch.")
end

print("=== SKRIPT IST FINISH ===")
