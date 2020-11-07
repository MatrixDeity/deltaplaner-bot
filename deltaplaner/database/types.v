module database

pub struct Event {
pub:
	id      int
	user_id int
	crontab string
	message string
	counter int
}
