import discordv as vd

struct CallbackData {
	client_user vd.User [required]
mut:
	client vd.Client [required]
}
