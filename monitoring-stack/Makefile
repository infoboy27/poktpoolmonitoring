# Load .env if it exists
ifneq (,$(wildcard .env))
  include .env
  export
endif

build:
	docker compose build

up:
	docker compose down
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

logs-monitoring:
	docker compose logs -f prometheus grafana loki blackbox

logs-infrastructure:
	docker compose logs -f traefik cadvisor node-exporter

reset:
	docker compose down
	rm -rf monitoring/loki/data/*
	rm -rf monitoring/grafana/data/*
	rm -rf monitoring/prometheus/data/*
	docker compose up -d

status:
	docker compose ps

health-check:
	@echo "Checking POKTpool monitoring stack health..."
	@echo "Grafana: http://localhost:3000"
	@echo "Prometheus: http://localhost:9090"
	@echo "Loki: http://localhost:3100"
	@echo "Traefik: http://localhost:8082"
	@echo ""
	@echo "Checking container status:"
	@docker compose ps

clean:
	docker compose down -v
	rm -rf monitoring/loki/data/*
	rm -rf monitoring/grafana/data/*
	rm -rf monitoring/prometheus/data/*
