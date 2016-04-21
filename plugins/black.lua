do

function run(msg, matches)
  return [[Astro Super GP
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
  description = ".", 
  usage = "use black command",
  patterns = {
    "^/astro$",
    "^!astro$",
    "^%astro$",
    "^$astro$",
   "^#astro$",
   "^#astro",
   "^/astro$",
   "^#astro$",

  },
  run = run
}
end
