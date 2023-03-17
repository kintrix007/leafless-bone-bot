module main

import discordv as vd

struct CallbackData {
	client_user vd.User [required]
pub mut:
	client vd.Client [required]
}
