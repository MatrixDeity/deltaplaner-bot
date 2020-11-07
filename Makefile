all: start

start:
	@v run .

build:
	@v build .

format:
	@v fmt -w .

clean:
	@rm -f deltaplaner-bot
	@rm -f deltaplaner.db

init-db:
	@rm -f deltaplaner.db
	@sqlite3 deltaplaner.db <scripts/init_db.sql
