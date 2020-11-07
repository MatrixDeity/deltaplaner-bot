module config

import json
import os

struct Config {
pub:
	database string
	token    string
	users    []int
}

pub fn load(path string) ?Config {
	raw_json := os.read_file(path) or {
		msg := 'cannot read config'
		return error(@FILE + ':' + @LINE + ':\n  $msg\n$err\n')
	}
	config := json.decode(Config, raw_json) or {
		msg := 'cannot decode config'
		return error(@FILE + ':' + @LINE + ':\n  $msg\n$err\n')
	}
	return config
}
