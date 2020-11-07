module telegram

pub struct Result {
pub:
	ok       bool
	raw_data string [json: result; raw]
}

pub struct BadResult {
pub:
	ok          bool
	error_code  int
	description string
}

pub struct Update {
pub:
	message Message
	id      int     [json: update_id]
}

pub struct Message {
pub:
	date int
	from User
	id   int    [json: message_id]
	text string
}

pub struct User {
pub:
	id       int
	is_bot   bool
	username string
}
