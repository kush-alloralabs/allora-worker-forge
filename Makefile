.PHONY: lint format test clean node-env run compose compose-clean

lint:
	find . -name "*.py" | xargs pylint

format:
	black .

test:
	pytest -m unittest discover -s tests

clean:
	rm -rf __pycache__ .pytest_cache .coverage

node-env:
	python allonode-data/generate_envfile.py

run:
	cd src && uvicorn main:app --reload --port 8000

build:
	docker build -f docker/Dockerfile -t allora-worker .

compose:
	docker compose -f docker/dev.docker-compose.yaml up

compose-clean:
	docker compose -f docker/dev.docker-compose.yaml up --build --force-recreate
