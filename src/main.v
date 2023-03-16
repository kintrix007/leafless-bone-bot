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

		// ? I have no clue why, but this HAS to be a heap struct
		mut data := &CallbackData{
			client_user: client_user
			client: client // Implicitly mutable..?
			// Same as
			// client: mut client
		}

		// There is probably a cleaner way..? But we _do_ want access to the client's user
		client.on_message_create(fn [mut data] (mut client vd.Client, message &vd.MessageCreate) {
			on_message(mut data, message) or {
				print_backtrace()
				println('Error: Could not handle message:\n${message}')
			}
		})

		client.on_message_reaction_add(fn [mut data] (mut client vd.Client, reaction &vd.MessageReactionAdd) {
			on_reaction(mut data, reaction) or {
				print_backtrace()
				println('Error: Could not handle reaction:\n${reaction}')
			}
		})
	})

	println('Bot online...')
	client.run().wait()
}

fn on_message(mut data CallbackData, message &vd.MessageCreate) ! {
	if message.author.bot {
		return
	}

	mentioned_ids := message.mentions.map(it.id)

	if data.client_user.id in mentioned_ids {
		println('Mentioned by ${message.author.username}#${message.author.discriminator}.')
		msg := '<@${message.author.id}> you dare mention me, mortal?'
		data.client.channel_message_send(message.channel_id, content: msg)!
	}
}

fn on_reaction(mut data CallbackData, reaction &vd.MessageReactionAdd) ! {
	if reaction.member.user.bot {
		return
	}
}
