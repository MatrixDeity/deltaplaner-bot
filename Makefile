PROJECT = deltaplaner-bot

.PHONY: all
all: start

.PHONY: start
start:
	v run .

.PHONY: build
build:
	v .

.PHONY: format
format:
	v fmt -w .

.PHONY: clean
clean:
	rm -f $(PROJECT)
	rm -f deltaplaner.db

.PHONY: init-db
init-db:
	rm -f deltaplaner.db
	sqlite3 deltaplaner.db <scripts/init_db.sql

.PHONY: docker-build
docker-build:
	docker build --pull --no-cache --tag matrixdeity/$(PROJECT):latest .

.PHONY: docker-start
docker-start:
	docker run -d --rm \
	    --name $(PROJECT) \
	    --volume /etc/$(PROJECT):/etc/$(PROJECT) \
		--env TZ=Europe/Moscow \
		matrixdeity/$(PROJECT):latest

.PHONY: docker-stop
docker-stop:
	docker rm -f $(PROJECT)
