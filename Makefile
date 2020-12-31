.PHONY: all
all: start

.PHONY: start
start:
	@v run .

.PHONY: build
build:
	@v .

.PHONY: format
format:
	@v fmt -w .

.PHONY: clean
clean:
	@rm -f deltaplaner-bot
	@rm -f deltaplaner.db

.PHONY: init-db
init-db:
	@rm -f deltaplaner.db
	@sqlite3 deltaplaner.db <scripts/init_db.sql
