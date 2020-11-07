module cron

const (
	short_week_days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
	long_week_days  = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
)

fn convert_part(part string, is_week_day bool) ?int {
	if res := to_integer(part) {
		return res
	}
	if is_week_day {
		res := max(short_week_days.index(part), long_week_days.index(part))
		if res != -1 {
			return res + 1
		} else {
			return none
		}
	}
	return none
}

fn to_integer(str string) ?int {
	casted := str.int()
	if casted == 0 && str != '0' {
		return none
	}
	return casted
}

[inline]
fn max(a int, b int) int {
	return if a < b {
		b
	} else {
		a
	}
}

fn in_range(value int, begin int, end int, step int) bool {
	if value >= begin && value < end {
		return (value - begin) % step == 0
	}
	return false
}
