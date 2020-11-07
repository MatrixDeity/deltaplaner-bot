module deltaplaner

import deltaplaner.cron
import deltaplaner.database
import sync
import time

fn (mut b Bot) process_events(mut wg sync.WaitGroup) {
	defer {
		wg.done()
	}
	for {
		now := time.now()
		sleep_sec := 60 - now.second + 1
		time.sleep(sleep_sec)
		b.handle_events()
	}
}

fn (mut b Bot) handle_events() {
	events := b.db.get_coming_events()
	for event in events {
		if cron.is_now(event.crontab) {
			b.notificate_about(event)
			if event.counter > 0 {
				b.db.set_counter(event.id, event.counter - 1)
			}
		}
	}
}

fn (b Bot) notificate_about(event database.Event) {
	text := '#$event.id\n$event.message'
	b.client.send_message({
		chat_id: event.user_id.str()
		text: text
	}) or { } // TODO: log it
}
