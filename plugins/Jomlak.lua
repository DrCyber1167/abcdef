local database = 'http://umbrella.shayan-soft.ir/txt/'


local function run(msg)

local res = http.request(database.."jomlak.db")

local jomlak = res:split(",")

return jomlak[math.random(#jomlak)]

end




return {

description = "Jomlak Sender",

usage = "!jomlak : send random texts",

patterns = {"^[/!]jomlak$"},

run = run

}
