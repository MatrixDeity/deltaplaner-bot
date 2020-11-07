module main

import deltaplaner
import flag
import os

struct Args {
	config_path string
}

fn parse_args() Args {
	mut parser := flag.new_flag_parser(os.args)
	return Args{
		config_path: parser.string('config', `c`, 'deltaplaner.json', 'Path to deltaplaner json-config')
	}
}

fn main() {
	args := parse_args()
	mut bot := deltaplaner.new_bot(args.config_path) or {
		msg := 'cannot create new bot'
		panic('\n' + @FILE + ':' + @LINE + ':\n  $msg\n$err\n')
	}
	bot.start()
}
