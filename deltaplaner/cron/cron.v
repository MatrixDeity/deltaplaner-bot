module cron

import time

pub fn is_now(expr string) bool {
	now := time.now()
	values := expr.split_nth(' ', 5)
	return is_now_value(values[0], now.minute, false) && is_now_value(values[1], now.hour, false) &&
		is_now_value(values[2], now.day, false) && is_now_value(values[3], now.month, false) && is_now_value(values[4], now.day_of_week(), true)
}

pub fn parse(expr string) ?(string, int) {
	// TODO: add crontab validation
	max_values := 6
	mut values := expr.split(' ').filter(it.trim_space().len > 0)
	if values.len > max_values {
		return none
	}
	for values.len < max_values {
		if values.len < max_values - 1 {
			values << '*'
		} else {
			values << '1'
		}
	}
	crontab := values[..values.len - 1].join(' ')
	counter := to_integer(values[values.len - 1]) or {
		-1
	}
	return crontab, counter
}

fn is_now_value(value string, target int, is_week_day bool) bool {
	if value == '*' {
		return true
	}
	parts := value.split(',')
	for part in parts {
		if res := convert_part(part, is_week_day) {
			return res == target
		}
		if '-' in value {
			mut step := 1
			mut begin := 0
			mut end := 0
			if '/' in value {
				mut pair := value.split_nth('-', 2)
				begin = convert_part(pair[0], is_week_day) or {
					continue
				}
				pair = pair[1].split_nth('/', 2)
				end = convert_part(pair[0], is_week_day) or {
					continue
				}
				step = to_integer(pair[1]) or {
					continue
				}
			} else {
				pair := value.split_nth('-', 2)
				begin = convert_part(pair[0], is_week_day) or {
					continue
				}
				end = convert_part(pair[1], is_week_day) or {
					continue
				}
			}
			if in_range(target, begin, end + 1, step) {
				return true
			}
			if is_week_day && begin > end {
				return in_range(target, begin, end + 7, step)
			}
		}
		if '/' in value {
			pair := value.split_nth('/', 2)
			if pair[0] != '*' { // TODO: return error here?
				continue
			}
			if interval := to_integer(pair[1]) {
				return target % interval == 0
			}
		}
	}
	return false
}
