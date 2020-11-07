module telegram

const (
	api_url = 'https://api.telegram.org'
)

pub struct Client {
	url   string
	token string
}

pub fn new_client(token string) Client {
	return Client{
		token: token
		url: '$api_url/bot$token'
	}
}
