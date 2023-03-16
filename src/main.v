module main

import os
import discordv as vd
import discordv.gateway

const bot_token = os.getenv('BOT_TOKEN')

fn main() {
	if bot_token == '' {
		panic("Please make sure you have the 'BOT_TOKEN' env variable set.")
	}
	intents := gateway.all_allowed
	mut client := vd.new(token: bot_token, intents: intents) or { panic('Could not authenticate') }

	client.on_ready(on_ready)

	println('Bot online...')
	client.run().wait()
}

fn on_ready(mut client vd.Client, ready &vd.Ready) {
	println("Bot ready as '${ready.user.username}#${ready.user.discriminator}'.")
}
