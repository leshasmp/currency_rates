.PHONY: test

setup:
	bin/setup
	npm ci

start:
	./bin/dev

test:
	bundle exec rspec

lint: lint-code

lint-code:
	bundle exec rubocop

linter-code-fix:
	bundle exec rubocop -A

db-reset:
	bin/rails db:reset

update-exchange-rates:
	whenever --update-crontab
