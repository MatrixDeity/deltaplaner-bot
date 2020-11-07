module database

import sqlite
import sync

pub struct Database {
	connection sqlite.DB
mut:
	mutex      &sync.Mutex
}

pub fn connect(path string) ?Database {
	connection := sqlite.connect(path) or {
		msg := 'cannot connect to database'
		return error(@FILE + ':' + @LINE + ':\n  $msg\n$err\n')
	}
	return Database{
		connection: connection
		mutex: sync.new_mutex()
	}
}

pub fn (mut d Database) get_coming_events() []Event {
	d.mutex.m_lock()
	defer {
		d.mutex.unlock()
	}
	return sql d.connection {
		select from Event where counter > 0 || counter == -1
	}
}

pub fn (mut d Database) get_event(event_id int) Event {
	d.mutex.m_lock()
	defer {
		d.mutex.unlock()
	}
	return sql d.connection {
		select from Event where id == event_id limit 1
	}
}

pub fn (mut d Database) add_event(event Event) int {
	// TODO: return new event id
	d.mutex.m_lock()
	defer {
		d.mutex.unlock()
	}
	sql d.connection {
		insert event into Event
	}
	return d.get_last_inserted_id()
}

pub fn (mut d Database) set_counter(event_id int, counter int) {
	d.mutex.m_lock()
	defer {
		d.mutex.unlock()
	}
	sql d.connection {
		update Event set counter = counter where id == event_id
	}
}

fn (mut d Database) get_last_inserted_id() int {
	d.mutex.m_lock()
	defer {
		d.mutex.unlock()
	}
	rows, _ := d.connection.exec('select last_insert_rowid();')
	return rows[0].vals[0].int()
}
