function download_file(filename, name)
    name = name or filename
    request = http.get("https://raw.githubusercontent.com/gabriel-nsiqueira/defusioncrafting-autocrafter/master/" ..
        filename)
    stream = fs.open(name, "w")
    stream.write(request.readAll())
    stream.close()
end

download_file("json.lua")
download_file("autocrafter.lua", "startup")
if not fs.exists("config.json") then
    download_file("config.json")
end
