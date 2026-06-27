.PHONY: help build up down restart logs validate

help:
	@echo "Targets:"
	@echo "  build     Build (or rebuild) the nginx-frontproxy image"
	@echo "  up        Start the front proxy (build if needed)"
	@echo "  down      Stop and remove the container"
	@echo "  restart   down + up"
	@echo "  logs      Tail container logs (Ctrl-C to exit)"
	@echo "  validate  Run 'nginx -t' against the current config inside the container"

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

restart: down up

logs:
	docker compose logs -f

validate:
	docker compose exec nginx-frontproxy nginx -t
