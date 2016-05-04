do

function run(msg, matches)
  return [[ 🤖AviraGP🤖
➖➖➖➖➖➖➖➖➖➖
🆕A new bot for manage your Supergroups.🆕
➖➖➖➖➖➖➖➖➖➖
@Avirateam #Channel
➖➖➖➖➖➖➖➖➖➖
@Mrunusuall #Developer
➖➖➖➖➖➖➖➖➖➖
@Mohammadarak #Developer
➖➖➖➖➖➖➖➖➖➖
⚡️Bot version : 1⚡️ ]]
end

return {
  description = "Shows bot version", 
  usage = "version: Shows bot version",
  patterns = {
    "^[#!/]version$"
  }, 
  run = run 
}

end
