.PHONY: test

setup:
	npm ci
	rails db:create db:migrate db:seed

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
	rails db:migrate:reset

update-exchange-rates:
	whenever --update-crontab
