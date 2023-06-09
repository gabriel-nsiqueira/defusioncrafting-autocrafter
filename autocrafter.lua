local json = require("json")
local inputChestIds = {}

local craftingInput, craftingOutput, craftingCore, activator, recipes

local modem = peripheral.wrap("bottom")

function load_config()
    sr = fs.open("config.json", "r")
    settings = json.parse(sr.readAll())
    recipes = settings.recipes
    craftingInput = settings.craftingInput
    craftingOutput = settings.craftingOutput
    sr.close()
end

if fs.exists("config.json") then
    load_config()
else
    error("No config file was found.")
end

for i, name in pairs(modem.getNamesRemote()) do
    if #inputChestIds == 0 and modem.hasTypeRemote(name, "draconicevolution:crafting_injector") then
        table.insert(inputChestIds, name)
    elseif (not craftingCore) and modem.hasTypeRemote(name, "draconicevolution:crafting_core") then
        craftingCore = name
    elseif (not activator) and modem.hasTypeRemote(name, "redstoneIntegrator") then
        activator = name
    end
end

if #inputChestIds == 0 then
    error("No fusion crafting injectors were found.")
elseif not craftingCore then
    error("No fusion crafting cores were found.")
elseif not activator then
    error("No redstone injectors were found.")
end

function moveItems(from, to, fromSlot, amount)
    modem.callRemote(from, "pushItems", to, fromSlot, amount)
end

function listItems(inventory)
    return modem.callRemote(inventory, "list")
end

function checkForItem(check, items)
    local count = 0
    for _, item in pairs(items) do
        if check.name == item.name then
            count = count + item.count
        end
    end
    return count >= check.count
end

function getSlot(check, items)
    for slot, item in pairs(items) do
        if check.name == item.name then
            return slot
        end
    end
end

function setSignal(signal)
    modem.callRemote(activator, "setOutput", "front", signal)
end

function run(recipe)
    print(("Currently crafting %s"):format(recipe.recipeName))
    local currentInjector = 1
    for _, item in pairs(recipe.sideInputs) do
        local inputItems = listItems(craftingInput)
        local slot = getSlot(item, inputItems)
        for i = 1, item.count do
            moveItems(craftingInput, inputChestIds[currentInjector], slot, 1)
            slot = getSlot(item, inputItems)
            currentInjector = currentInjector + 1
        end
    end
    for i = 1, recipe.mainInput.count do
        moveItems(craftingInput, craftingCore,
            getSlot(recipe.mainInput, listItems(craftingInput)), 1)
    end
    os.sleep(2)
    setSignal(true)
    local hasOutput = false
    while not hasOutput do
        local items = listItems(craftingCore)
        hasOutput = items ~= nil and items[2] ~= nil
    end
    moveItems(craftingCore, craftingOutput, 2)
    setSignal(false)
    print("Finished crafting")
end

function getRecipe()
    for _, recipe in pairs(recipes) do
        local inputItems = listItems(craftingInput)
        local isValid = true
        for _, item in pairs(recipe.sideInputs) do
            if not checkForItem(item.name == recipe.mainInput and { name = item.name, count = item.count +
                    recipe.mainInput.count } or item, inputItems) then
                isValid = false
                break
            end
        end
        isValid = isValid and checkForItem(recipe.mainInput, inputItems)
        if isValid then
            return recipe
        end
    end
end

while true do
    local recipe = getRecipe()
    if recipe ~= nil then
        for _, injector in pairs(inputChestIds) do
            for slot, _ in pairs(listItems(injector)) do
                moveItems(injector, craftingInput, slot)
            end
        end

        moveItems(craftingCore, craftingInput, 1)
        run(recipe)
    end
end
