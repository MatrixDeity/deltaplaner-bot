module deltaplaner

import deltaplaner.cron
import deltaplaner.telegram
import sync
import time

const (
	polling_interval = 1 // seconds
)

fn (mut b Bot) process_messages(mut wg sync.WaitGroup) {
	defer {
		wg.done()
	}
	b.fetch_updates()
	for {
		for update in b.fetch_updates() {
			b.process_one_message(update.message)
		}
		time.sleep(polling_interval)
	}
}

fn (mut b Bot) fetch_updates() []telegram.Update {
	updates := b.client.get_updates({
		offset: b.last_update_id
	}) or {
		return []telegram.Update{}
	}
	mut result := []telegram.Update{cap: updates.len}
	for update in updates {
		if b.last_update_id < update.id {
			b.last_update_id = update.id
			result << update
		}
	}
	return result
}

fn (mut b Bot) process_one_message(message telegram.Message) {
	user_id := message.from.id
	if user_id !in b.config.users { // TODO: add better error processing
		b.answer_to(message, 'Вы не можете пользоваться этим ботом!')
		return
	}
	if message.text.starts_with('#') {
		b.show_event(message)
	} else {
		b.create_event(message)
	}
}

fn (mut b Bot) create_event(message telegram.Message) {
	// TODO: add error processing better
	lines := message.text.split_nth('\n', 2)
	if lines.len < 2 {
		b.answer_to(message, 'Необходимо указать сообщение!')
		return
	}
	crontab, counter := cron.parse(lines[0]) or {
		b.answer_to(message, 'Неправильный формат запроса!')
		return
	}
	event_id := b.db.add_event({
		user_id: message.from.id
		crontab: crontab
		message: lines[1].trim_space()
		counter: counter
	})
	b.answer_to(message, 'Событие #$event_id добавлено!')
}

fn (mut b Bot) show_event(message telegram.Message) {
	event_id := message.text[1..].int() // TODO: add bad id processing
	event := b.db.get_event(event_id)
	if event.user_id != message.from.id {
		b.answer_to(message, 'У вас нет доступа к этому событию!') // TODO: make report better
		return
	}
	counter := if event.counter >= 0 { event.counter.str() } else { '*' }
	answer_text := '$event.crontab $counter\n$event.message'
	b.answer_to(message, answer_text)
}
