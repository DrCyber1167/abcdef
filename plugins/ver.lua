do

function run(msg, matches)
  return [[ Astro Super GP
-----------------------------------
A new bot for manage your Supergroups.
-----------------------------------
@AstroTEam #Channel
-----------------------------------
@Mrunusuall #Developer
-----------------------------------
@@Keiranlee #Manager
-----------------------------------
Bot number : +1 760 767 9054
-----------------------------------
Bot version : 1 ]]
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
