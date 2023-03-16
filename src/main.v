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

		client_user := ready.user

		// There is probably a cleaner way..? But we do want access to the client's user
		client.on_message_create(fn [client_user] (mut client vd.Client, message &vd.MessageCreate) {
			on_message(client_user, mut client, message)
		})

		client.on_message_reaction_add(fn [client_user] (mut client vd.Client, reaction &vd.MessageReactionAdd) {
			on_reaction(client_user, mut client, reaction)
		})
	})

	println('Bot online...')
	client.run().wait()
}

fn on_message(client_user vd.User, mut client vd.Client, message &vd.MessageCreate) {
	if message.author.bot {
		return
	}

	mentioned_ids := message.mentions.map(it.id)

	if client_user.id in mentioned_ids {
		println('Mention detected')
		client.channel_message_send(message.channel_id, content: 'Mention detected') or { return }
	}
}

fn on_reaction(client_user vd.User, mut client vd.Client, reaction &vd.MessageReactionAdd) {
	if reaction.member.user.bot {
		return
	}
}
