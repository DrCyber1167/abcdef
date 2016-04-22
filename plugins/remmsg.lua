local function history(extra, suc, result)
for i=1, #result do
delete_msg(result[i].id, ok_cb, false)
end
if tonumber(extra.con) == #result then
send_msg(extra.chatid, ''..#result..'🗑of recently chats deleted🗑', ok_cb, false)
else
send_msg(extra.chatid, '🗑Super group chats deleted🗑', ok_cb, false)
end
end
local function run(msg, matches)
if matches[1] == 'msgrem' and is_owner(msg) then
            if msg.to.type == 'channel' then
            if tonumber(matches[2]) > 99 or tonumber(matches[2]) < 1 then
            return "Invalid value\nvalue range[1-99]"
            end
            get_history(msg.to.peer_id, matches[2] + 1 , history , {chatid = msg.to.peer_id, con = matches[2]})
        else
                         return "Just for SuperGP"
        end
else
return "only admins can use it"
end
end
return {
    patterns = {
        '^[!/#](msgrem) (%d*)$'
    },
    run = run
}
