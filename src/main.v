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

	client.on_ready(fn (mut client vd.Client, ready &vd.Ready) {
		defer {
			println("Bot ready as '${ready.user.username}#${ready.user.discriminator}'.")
		}

		data := CallbackData{
			client: client
			client_user: ready.user
		}

		// There is probably a cleaner way..? But we do want access to the client's user
		client.on_message_create(fn [data] (mut client vd.Client, message &vd.MessageCreate) {
			on_message(data, message)
		})

		client.on_message_reaction_add(fn [data] (mut client vd.Client, reaction &vd.MessageReactionAdd) {
			on_reaction(data, reaction)
		})
	})

	println('Bot online...')
	client.run().wait()
}

fn on_message(data CallbackData, message &vd.MessageCreate) {
	if message.author.bot {
		return
	}

	println(message.mentions)

	if data.client_user.id in message.mentions.map(it.id) {
		println('Mention detected')
	}
}

fn on_reaction(data CallbackData, reaction &vd.MessageReactionAdd) {
	if reaction.member.user.bot {
		return
	}
}
