.PHONY: test

up:
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
