module deltaplaner

import deltaplaner.config
import deltaplaner.database
import deltaplaner.telegram
import sync

pub struct Bot {
	client         telegram.Client
	config         config.Config
mut:
	db             database.Database
	last_update_id int
}

pub fn new_bot(config_path string) ?Bot {
	bot_config := config.load(config_path) or {
		msg := 'fail to load bot config'
		return error(@FILE + ':' + @LINE + ':\n  $msg\n$err\n')
	}
	db := database.connect(bot_config.database) or {
		msg := 'bot database is unavailable'
		return error(@FILE + ':' + @LINE + ':\n  $msg\n$err\n')
	}
	return Bot{
		client: telegram.new_client(bot_config.token)
		config: bot_config
		db: db
	}
}

pub fn (mut b Bot) start() {
	mut wg := sync.new_waitgroup()
	wg.add(2)
	go b.process_messages(mut wg)
	go b.process_events(mut wg)
	wg.wait()
}

fn (b Bot) answer_to(message telegram.Message, text string) {
	b.client.send_message({
		chat_id: message.from.id.str()
		text: text
		reply_to_message_id: message.id
	}) or { } // TODO: log it
}
