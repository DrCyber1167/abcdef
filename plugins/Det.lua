--[[


        CRUEL BOT
		
		
		@cruel0098
		
		
		Channel :     @cruel_channel
		
▒▒▒▒▒▒▒▒▒
▒▒█████▒▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒▒█▒▒▒█▒▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒▒▒▒█▒▒█▒
▒▒▒██▒▒█▒
▒▒█▒█▒▒█▒
▒█▒▒▒██▒▒
▒▒▒▒▒▒▒▒▒
▒▒██████▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒▒██████▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒█▒▒▒▒▒█▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒▒██▒██▒▒
▒▒▒▒▒▒▒▒▒
▒▒█████▒▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒▒█████▒▒
▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒█▒
▒▒▒▒▒▒▒█▒
▒███████▒
▒▒▒▒▒▒▒█▒
▒▒▒▒▒▒▒█▒
▒▒▒▒▒▒▒▒▒


]]
do
local MKH = 188548712 --put your id here(BOT OWNER ID)

local function setrank(msg, name, value) -- setrank function
  local hash = nil
  if msg.to.type == 'channel' then
    hash = 'rank:variables'
  end
  if hash then
    redis:hset(hash, name, value)
	return send_msg('channel#id'..msg.to.id, '('..name..') rate was changed to '..value..'', ok_cb,  true)
  end
end
local function res_user_callback(extra, success, result) -- /info <username> function
  if success == 1 then  
  if result.username then
   Username = '@'..result.username
   else
   Username = 'ندارد'
  end
    local text = 'Full name : '..(result.first_name or '')..' '..(result.last_name or '')..'\n'
               ..'Username: '..Username..'\n'
               ..'Id : '..result.id..'\n\n'
	local hash = 'rank:variables'
	local value = redis:hget(hash, result.id)
    if not value then
	 if result.id == tonumber(MKH) then
	   text = text..'Rate:Sodu (Executive Admin) \n\n'
	  elseif is_admin2(result.id) then
	   text = text..'Rate:Bot admin (Admin) \n\n'
	  elseif is_owner2(result.id, extra.chat2) then
	   text = text..'Rate:group owner (Owner) \n\n'
	  elseif is_momod2(result.id, extra.chat2) then
	    text = text..'Rate:Group admin (Moderator) \n\n'
      else
	    text = text..'Rate:Member (Member) \n\n'
	 end
   else
   text = text..'Rate : '..value..'\n\n'
  end
  local uhash = 'user:'..result.id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.id..':'..extra.chat2
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'The number of message sent : '..user_info_msgs..'\n\n'
  text = text..''
  send_msg(extra.receiver, text, ok_cb,  true)
  else
	send_msg(extra.receiver, extra.user..' username not found', ok_cb, false)
  end
end

local function action_by_id(extra, success, result)  -- /info <ID> function
 if success == 1 then
 if result.username then
   Username = '@'..result.username
   else
   Username = 'ندارد'
 end
    local text = 'Full name : '..(result.first_name or '')..' '..(result.last_name or '')..'\n'
               ..'Username: '..Username..'\n'
               ..'Id : '..result.id..'\n\n'
  local hash = 'rank:variables'
  local value = redis:hget(hash, result.id)
  if not value then
	 if result.id == tonumber(MKH) then
	   text = text..'Rate:sudo (Executive Admin) \n\n'
	  elseif is_admin2(result.id) then
	   text = text..'Rate:Bot admin (Admin) \n\n'
	  elseif is_owner2(result.id, extra.chat2) then
	   text = text..'Rate:group owner (Owner) \n\n'
	  elseif is_momod2(result.id, extra.chat2) then
	   text = text..'Rate:Group admin (Moderator) \n\n'
	  else
	   text = text..'Rate:member (Member) \n\n'
	  end
   else
    text = text..'Rate : '..value..'\n\n'
  end
  local uhash = 'user:'..result.id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.id..':'..extra.chat2
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'The number of sent message : '..user_info_msgs..'\n\n'
  text = text..''
  send_msg(extra.receiver, text, ok_cb,  true)
  else
  send_msg(extra.receiver, 'Id not saved in system\nuse !det @username', ok_cb, false)
  end
end

local function action_by_reply(extra, success, result)-- (reply) /info  function
		if result.from.username then
		   Username = '@'..result.from.username
		   else
		   Username = '----'
		 end
  local text = 'Name : '..(result.from.first_name or '')..'\nLast name :'..(result.from.last_name or '----')..'\n'
               ..'Username : '..Username..'\n'
               ..'Id : '..result.from.peer_id..'\n\n'
	local hash = 'Rate:'..result.to.id..':variables'
		local value = redis:hget(hash, result.from.id)
		 if not value then
		    if result.from.peer_id == tonumber(MKH) then
		       text = text..'Rate:Sodu Executive Admin \n\n'
		     elseif is_admin2(result.from.peer_id) then
		       text = text..'Rate:Bot admin Admin \n\n'
		     elseif is_owner2(result.from.peer_id, result.to.peer_id) then
		       text = text..'Rate:Group owner Owner \n\n'
		     elseif is_momod2(result.from.peer_id, result.to.peer_id) then
		       text = text..'Rate:group admin Moderator \n\n'
		 else
		       text = text..'Rate:member Member \n\n'
			end
		  else
		   text = text..'Rate : '..value..'\n\n'
		 end
         local user_info = {} 
  local uhash = 'user:'..result.from.peer_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..result.from.peer_id..':'..result.to.peer_id
  user_info_msgs = tonumber(redis:get(um_hash) or 0)
  text = text..'The number of Sent message : '..user_info_msgs..'\n\n'
  text = text..'@AstroTeam'
  send_msg(extra.receiver, text, ok_cb, true)
end

local function action_by_reply2(extra, success, result)
local value = extra.value
setrank(result, result.from.id, value)
end

local function run(msg, matches)
 if matches[1]:lower() == 'setrank' then
  local hash = 'usecommands:'..msg.from.peer_id..':'..msg.to.peer_id
  redis:incr(hash)
  if not is_sudo(msg) then
    return "Just for Sudo"
  end
  local receiver = get_receiver(msg)
  local Reply = msg.reply_id
  if msg.reply_id then
  local value = string.sub(matches[2], 1, 1000)
    msgr = get_message(msg.reply_id, action_by_reply2, {receiver=receiver, Reply=Reply, value=value})
  else
  local name = string.sub(matches[2], 1, 50)
  local value = string.sub(matches[3], 1, 1000)
  local text = setrank(msg, name, value)

  return text
  end
  end
 if matches[1]:lower() == 'det' and not matches[2] then
  local receiver = get_receiver(msg)
  local Reply = msg.reply_id
  if msg.reply_id then
    msgr = get_message(msg.reply_id, action_by_reply, {receiver=receiver, Reply=Reply})
  else
  if msg.from.username then
   Username = '@'..msg.from.username
   else
   Username = 'None'
   end
   local text = 'Name : '..(msg.from.first_name or 'None')..'\n'
   local text = text..'Last name : '..(msg.from.last_name or 'None')..'\n'	
   local text = text..'Username : '..Username..'\n'
   local text = text..'Id : '..msg.from.id..'\n\n'
   local hash = 'rank:variables'
	if hash then
	  local value = redis:hget(hash, msg.from.id)
	  if not value then
		if msg.from.id == tonumber(MKH) then
		 text = text..'Rate:Sodu (Executive Admin) \n\n'
		elseif is_sudo(msg) then
		 text = text..'Rate:Bot admin (Admin) \n\n'
		elseif is_owner(msg) then
		 text = text..'Rate:group owner (Owner) \n\n'
		elseif is_momod(msg) then
		 text = text..'Rate:group admin (Moderator) \n\n'
		else
		 text = text..'Rate:member (Member) \n\n'
		end
	  else
	   text = text..'Rate : '..value..'\n'
	  end
	end
    
	 local uhash = 'user:'..msg.from.id
 	 local user = redis:hgetall(uhash)
  	 local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
	 user_info_msgs = tonumber(redis:get(um_hash) or 0)
	 text = text..'THe number of sent message : '..user_info_msgs..'\n\n'
	 if msg.to.type == 'chat' then
	 text = text..'Group name : '..msg.to.title..'\n'
     text = text..'Group id : '..msg.to.id
    end
	text = text..''
    return send_msg(receiver, text, ok_cb, true)
    end
  end
  if matches[1]:lower() == 'det' and matches[2] then
   local user = matches[2]
   local chat2 = msg.to.id
   local receiver = get_receiver(msg)
   if string.match(user, '^%d+$') then
	  user_info('user#id'..user, action_by_id, {receiver=receiver, user=user, text=text, chat2=chat2})
    elseif string.match(user, '^@.+$') then
      username = string.gsub(user, '@', '')
      msgr = res_user(username, res_user_callback, {receiver=receiver, user=user, text=text, chat2=chat2})
   end
  end
end

return {
  description = 'Know your information or the info of a chat members.',
  usage = {
	'!info: Return your info and the chat info if you are in one.',
	'(Reply)!info: Return info of replied user if used by reply.',
	'!info <id>: Return the info\'s of the <id>.',
	'!info @<user_name>: Return the member @<user_name> information from the current chat.',
	'!setrank <userid> <rank>: change members rank.',
	'(Reply)!setrank <rank>: change members rank.',
  },
  patterns = {
	"^([Ii][Nn][Ff][Oo])$",
	"^[/!#]([Dd][Ee][Tt])$",
	"^([Dd][Ee][Tt]) (.*)$",
	"^[/!#]([Dd][Ee][Tt]) (.*)$",
	"^[/!]([Ss][Ee][Tt][Rr][Aa][Nn][Kk]) (%d+) (.*)$",
	"^[/!]([Ss][Ee][Tt][Rr][Aa][Nn][Kk]) (.*)$",
  },
  run = run
}

end

--[[
▒▒▒▒▒▒▒▒▒                    
▒▒█████▒▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒▒█▒▒▒█▒▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒▒▒▒█▒▒█▒
▒▒▒██▒▒█▒
▒▒█▒█▒▒█▒
▒█▒▒▒██▒▒
▒▒▒▒▒▒▒▒▒
▒▒██████▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒▒██████▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒█▒▒▒▒▒█▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒█▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒
▒███████▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒█▒▒█▒▒█▒
▒▒██▒██▒▒
▒▒▒▒▒▒▒▒▒
▒▒█████▒▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒█▒▒▒▒▒█▒
▒▒█████▒▒
▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒█▒
▒▒▒▒▒▒▒█▒
▒███████▒
▒▒▒▒▒▒▒█▒
▒▒▒▒▒▒▒█▒
▒▒▒▒▒▒▒▒▒





]]
