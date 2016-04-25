local function tophoto(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/photos/'..msg.from.id..'.png'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_photo(get_receiver(msg), file, ok_cb, false)
    redis:del("sticker:png")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function run(msg,matches)
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'document' and redis:get("sticker:png") then
        if redis:set("sticker:png", "waiting") then
        end
       end
    
      if matches[1] == "topng" then
     redis:get("sticker:png")  
        load_document(msg.reply_id, tophoto, msg)
    end
end
end
return {
  patterns = {
 "^[#!/](topng)$",
 "%[(document)%]",
  },
  run = run,
  }
