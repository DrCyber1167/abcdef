local function run(msg, matches)
	if matches[1]:lower() == "github>" then
		local dat = https.request("https://api.github.com/repos/"..matches[2])
		local jdat = JSON.decode(dat)
		if jdat.message then
			return "Invalid Adress"
		end
		local base = "curl 'https://codeload.github.com/"..matches[2].."/zip/master'"
		local data = io.popen(base):read('*all')
		f = io.open("file/github.zip", "w+")
		f:write(data)
		f:close()
		return send_document("chat#id"..msg.to.id, "file/github.zip", ok_cb, false)
	else
		local dat = https.request("https://api.github.com/repos/"..matches[2])
		local jdat = JSON.decode(dat)
		if jdat.message then
			return "Invalid Adress"
		end
		local res = https.request(jdat.owner.url)
		local jres = JSON.decode(res)
		send_photo_from_url("chat#id"..msg.to.id, jdat.owner.avatar_url)
		return "Account detial:\n"
			.."AccountName: "..(jres.name or "-----").."\n"
			.."Username: "..jdat.owner.login.."\n"
			.."Company: "..(jres.company or "-----").."\n"
			.."Website: "..(jres.blog or "-----").."\n"
			.."Email: "..(jres.email or "-----").."\n"
			.."Locatian: "..(jres.location or "-----").."\n"
			.."Number of projects: "..jres.public_repos.."\n"
			.."Followers: "..jres.followers.."\n"
			.."Following: "..jres.following.."\n"
			.."Account creation date: "..jres.created_at.."\n"
			.."Bio: "..(jres.bio or "-----").."\n\n"
			.."Project detial:\n"
			.."project Name: "..jdat.name.."\n"
			.."Github page: "..jdat.html_url.."\n"
			.."Source pakage: "..jdat.clone_url.."\n"
			.."Weblog: "..(jdat.homepage or "-----").."\n"
			.."Date of creation: "..jdat.created_at.."\n"
			.."Lastet update: "..(jdat.updated_at or "-----").."\n"
			.."Programming language: "..(jdat.language or "-----").."\n"
			.."Script size: "..jdat.size.."\n"
			.."Stars: "..jdat.stargazers_count.."\n"
			.."seen: "..jdat.watchers_count.."\n"
			.."Splits: "..jdat.forks_count.."\n"
			.."Subscribers: "..jdat.subscribers_count.."\n"
			.."About peoject:\n"..(jdat.description or "-----").."\n"
	end
end

return {
	description = "Github Informations",
	usagehtm = '<tr><td align="center">github پروژه/اکانت</td><td align="right">آدرس گیتهاب را به صورت پروژه/اکانت وارد کنید<br>مثال: github shayansoft/umbrella</td></tr>'
	..'<tr><td align="center">github> پروژه/اکانت</td><td align="right">با استفاده از این دستور، میتوانید سورس پروژه ی مورد نظر را دانلود کنید. آدرس پروژه را مثل دستور بالا وارد کنید</td></tr>',
	usage = {
		"github (account/proje) : مشخصات پروژه و اکانت",
		"github> (account/proje) : دانلود سورس",
		},
	patterns = {
		"^[!#$/]([Gg]ithub>) (.*)",
		"^[!#$/]([Gg]ithub) (.*)",
		
		},
	run = run
}
