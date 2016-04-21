package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("./bot/utils")

local f = assert(io.popen('/usr/bin/git describe --tags', 'r'))
VERSION = assert(f:read('*a'))
f:close()

-- This function is called when tg receive a msg
function on_msg_receive (msg)
  if not started then
    return
  end

  msg = backward_msg_format(msg)

  local receiver = get_receiver(msg)
  print(receiver)
  --vardump(msg)
  --vardump(msg)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
      if redis:get("bot:markread") then
        if redis:get("bot:markread") == "on" then
          mark_read(receiver, ok_cb, false)
        end
      end
    end
  end
end

function ok_cb(extra, success, result)

end

function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)
  -- See plugins/isup.lua as an example for cron

  _config = load_config()

  -- load plugins
  plugins = {}
  load_plugins()
end

function msg_valid(msg)
  -- Don't process outgoing messages
  if msg.out then
    print('\27[36mNot valid: msg from us\27[39m')
    return false
  end

  -- Before bot was started
  if msg.date < os.time() - 5 then
    print('\27[36mNot valid: old msg\27[39m')
    return false
  end

  if msg.unread == 0 then
    print('\27[36mNot valid: readed\27[39m')
    return false
  end

  if not msg.to.id then
    print('\27[36mNot valid: To id not provided\27[39m')
    return false
  end

  if not msg.from.id then
    print('\27[36mNot valid: From id not provided\27[39m')
    return false
  end

  if msg.from.id == our_id then
    print('\27[36mNot valid: Msg from our id\27[39m')
    return false
  end

  if msg.to.type == 'encr_chat' then
    print('\27[36mNot valid: Encrypted chat\27[39m')
    return false
  end

  if msg.from.id == 777000 then
    --send_large_msg(*group id*, msg.text) *login code will be sent to GroupID*
    return false
  end

  return true
end

--
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end
  return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        print(warning)
        send_msg(receiver, warning, ok_cb, false)
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)

  -- Go over patterns. If one matches it's enough.
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("msg matches: ", pattern)

      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
  send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Sudo user: " .. user)
  end
  return config
end

-- Create a basic config.json file and saves it.
function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
    "plugins",
    "antiSpam",
    "antiArabic",
    "banHammer",
    "broadcast",
    "inv",
    "password",
    "welcome",
    "toSupport",
    "me",
    "toStciker_By_Reply",
    "invSudo_Super",
    "invSudo",
    "cpu",
    "badword",
    "aparat",
    "calculator",
    "antiRejoin",
    "pmLoad",
    "inSudo",
    "blackPlus",
    "toSticker(Text_to_stick)",
    "toPhoto_By_Reply",
    "inPm",
    "autoleave_Super",
    "black",
    "terminal",
    "sudoers",
    "time",
    "toPhoto",
    "toPhoto_Txt_img",
    "toSticker",
    "toVoice",
    "ver",
    "start",
    "whitelist",
    "plist",
    "inSuper",
    "inRealm",
    "onservice",
    "inGroups",
    "updater",
    "qrCode",
    "groupRequest_V2_Test",
    "inAdmin"

    },
    sudo_users = {114307641,183991347,0,tonumber(120395246)},--Sudo users
    moderation = {data = 'data/moderation.json'},
    about_text = [[Astro v1
An advanced administration bot based on TeleSeed written in Lua

https://github.com/MRnobodyTG/AstroSuperGroup.git

Admins
@Mrunusuall[Developer]
@@Keiranlee [Admin]
@@al1nm [Admin]

Our channels
@AstroTeam 
Our Bot
@AstroTGbot	
Support
@AstroSuppport
]],
    help_text_realm = [[
Realm Commands:
••!creategroup [Name]
ساخت گروه
______________________
••!createrealm [Name]
ساخت اتاق کنترل
______________________
••!setname [Name]
تعیین نام اتاق کنترل
______________________
••!setabout [group|sgroup] [GroupID] [Text]
تعیین متن درباره گروه
______________________
••!setrules [GroupID] [Text]
تعیین قوانین گروه
______________________
••!lock [GroupID] [setting]
فعال کردن قفل تنظیمات گروه
______________________
••!unlock [GroupID] [setting]
غیر فعال کردن قفل تنظیمات گروه
______________________
••!settings [group|sgroup] [GroupID]
تعیین تنظیمات برای گروپ ایدی
______________________
••!wholist
دریافت لیست اعضای گروه یا اتاق کنترل
______________________
••!who
دریافت فایل اعضای گروه یا اتاق کنترل
______________________
••!type
دریافت نوع گروه
______________________
••!kill chat [GroupID]
حذف تمام اعضای گروه و پاک کردن آن
______________________
••!kill realm [RealmID]
حذف تمام اعضای اتاق کنترل و پاک کردن آن
______________________
••!addadmin [id|username]
ارتقا مقام به ادمینی *فقط مخصوص سودو
______________________
••!removeadmin [id|username]
حذف ادمین *فقط مخصوص سودو
______________________
••!list groups
دریافت لیست گروه ها
______________________
••!list realms
دریافت لیست اتاق های کنترل
______________________
••!support
ارتقا مقام به ساپورت
______________________
••!-support
حذف ساپورت
______________________
••!log
دریافت فایل گزارش از گروه یا اتاق کنترل
______________________
••!broadcast [text]
••!broadcast Hello !
ارسال متن به همه ی گروه ها
فقط مخصوص سودو ها می باشد
______________________
••!bc [group_id] [text]
••!bc 123456789 Hello !
این دستور متن را به گروه مورد نظر میفرستد
______________________
developer: @mrunusuall
channel: @astroteam
G00D LUCK ^_^
]],
    help_text = [[
Commands list :
••!kick [username|id]
شما میتوانید با ریپلی انجام دهید
______________________
••!ban [ username|id]
شما میتوانید با ریپلی انجام دهید
______________________
••!unban [id]
شما میتوانید با ریپلی انجام دهید
______________________
••!who
لیست اعضا
______________________
••!modlist
لیست مدیران
______________________
••!promote [username]
ارتقا فرد مورد نظر
______________________
••!demote [username]
حذف مقام فرد مورد نظر
______________________
••!kickme
خارج شدن از گروه
______________________
••!about
دریافت متن ،درباره گروه
______________________
••!setphoto
تغییر یا تعیین عکس گروه
______________________
••!setname [name]
تغییر یا تعیین نام گروه
______________________
••!rules
قوانین گروه
______________________
••!id
دریافت ایدی گروه یا ایدی فرد مورد نظر
______________________
••!help
دریافت متن راهنما
______________________
••!lock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]
فعال کردن قفل تنظیمات گروه
______________________
••!unlock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]
غیر فعال کردن قفل تظیمات گروه
______________________
••!mute [all|audio|gifs|photo|video]
بی صدا کردن کردن هر نوع فایل
______________________
••!unmute [all|audio|gifs|photo|video]
با صدا کردن
______________________
••!set rules <text>
تعیین قوانین گروه
______________________
••!set about <text>
تعیین متن درباره گروه
______________________
••!settings
دریافت تنظیمات گروه
______________________
••!muteslist
دریافت لیست بی صدا شده ها
______________________
••!muteuser [username]
بی صدا کردن فرد در چت
*اگر فرد چت کن اخراج میشود
______________________
••!mutelist
دریافت لیست کاربران بی صدا شده
______________________
••!newlink
ایجاد یا تغییر لینک
______________________
••!link
دریافت لینک گروه
______________________
••!owner
دریافت ایدی مدیر گروه
______________________
••!setowner [id]
تنظیم فرد مورد نظر بعنوان مدیر
______________________
••!setflood [value]
تنظیم حساسیت اسپم
______________________
••!stats
وضعیت
______________________
••!save [value] <text>
ذخیره متن 
______________________
••!get [value]
دریافت متن مورد نظر
______________________
••!clean [modlist|rules|about]
را پاک میکند [modlist|rules|about] این دستور 
______________________
••!res [username]
دریافت ایدی و یوزرنیم
"!res @username"
______________________
••!log
دریافت گزارشات گروه
______________________
••!banlist
دریافت لیست اعضا بن شده در گروه
______________________
developer: @mrunusuall
channel: @astroteam
based on Teleseed 
G00D LUCK ^_^
]],
	help_text_super =[[
SuperGroup Commands:
••!info
مشاهده اطلاعات عمومی سوپر گروه
______________________
••!admins
دریافت لیست ادمین های سوپرگروه
______________________
••!owner
دریافت  ایدی مدیر کل گروه
______________________
••!modlist
دریافت لیست مدیران
______________________
••!bots
لیست بات های سوپر گروه
______________________
••!who
دریافت لیست اعضای سوپر گروه
______________________
••!block
اخراج فرد از سوپر گروه
فرد را به لیست بلاک اضافه میکند
______________________
••!ban
بن کرد فرد از سوپر گروه
______________________
••!unban
ان بن کرد فرد سوپر گروه
______________________
••!id
دریافت ایدی فرد یا سوپر گروه
______________________
••!id from
دریافت ایدی از پیغام فوروارد شده
______________________
••!kickme
لفت از سوپر گروه
______________________
••!setowner
تعیین کردن مدیر اصلی برای سوپر گروه
______________________
••!promote [username|id]
ارتقا فرد به مدیر
______________________
••!demote [username|id]
حذف مقام فرد مورد نظر
______________________
••!setname
تعیین یا تغییر نام سوپر گروه
______________________
••!setphoto
تعیین یا تغییر عکس سوپر گروه
______________________
••!setrules
تعیین یا تغیرر قوانین گروه
______________________
••!setabout
تعیین متن در باره در قسمت ممبر اینفو
______________________
••!save [value] <text>
ذخیره متن 
______________________
••!get [value]
دریافت متن مورد نظر
______________________
••!newlink
تغییر یا ایجاد لینک جدید
______________________
••!link
دریافت لینک گروه
______________________
••!rules
دریافت قوانین گروه
______________________
••!lock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]
قفل تنظیمات گروه
______________________
••!unlock [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict]
غیر فعال کردن قفل تنظیمات گروه
______________________
••!mute [all|audio|gifs|photo|video|service]
بی صدا کردن انواع فایل
______________________
••!unmute [all|audio|gifs|photo|video|service]
با صدا کردن انواع فایل
______________________
••!setflood [value]
تعیین حساسیت ضد اسپم
______________________
••!settings
دریافت تنظیمات گروه
______________________
••!muteslist
دریافت لیست بی صدا ها
______________________
••!muteuser [username]
بی صدا کردن فرد در چت
______________________
••!mutelist
دریافت لیست افراد بی صدا شده
______________________
••!banlist
دریافت لیست  افراد بن شده در سوپرگروه
______________________
••!clean [rules|about|modlist|mutelist]
را پاک میکند [rules|about|modlist|mutelist] این دستور 
______________________
••!del
پاک کردن پیام با ریپلی
______________________
••!public [yes|no]
______________________
••!res [username]
دریافت یوزرنیم و ایدی فرد
______________________
••!log
دریافت گزارشات سوپرگروه
______________________
••!tools
لیست ابزار
______________________
developer: @mrunusuall
channel: @astroteam
G00D LUCK ^_^
]],
  }
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)
  --vardump (chat)
end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.json
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)

    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
	  print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end

  end
end

-- custom add
function load_data(filename)

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data)

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end


-- Call and postpone execution for cron plugins
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end

  -- Called again in 2 mins
  postpone (cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false
