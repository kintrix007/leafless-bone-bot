import discordv as vd

struct CallbackData {
	client      vd.Client [required]
	client_user vd.User   [required]
}
