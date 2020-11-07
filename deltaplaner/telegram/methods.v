module telegram

import json
import net.http

pub struct GetUpdatesArgs {
pub:
	offset int
}

pub fn (c Client) get_updates(args GetUpdatesArgs) ?[]Update {
	response := c.post('/getUpdates', json.encode(args)) ?
	updates := json.decode([]Update, response.raw_data) ?
	return updates
}

pub struct SendMessageArgs {
pub:
	chat_id             string
	text                string
	reply_to_message_id int
}

pub fn (c Client) send_message(args SendMessageArgs) ?Message {
	response := c.post('/sendMessage', json.encode(args)) ?
	message := json.decode(Message, response.raw_data) ?
	return message
}

fn (c Client) post(url string, raw_data string) ?Result {
	response := http.fetch(c.url + url, http.FetchConfig{
		method: .post
		data: raw_data
		headers: {
			'Content-Type': 'application/json'
		}
	}) ?
	if response.status_code == 200 {
		result := json.decode(Result, response.text) ?
		return result
	} else {
		bad_result := json.decode(BadResult, response.text) ?
		return error('$url error $bad_result.error_code: $bad_result.description')
	}
}
