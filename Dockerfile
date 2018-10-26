version: '3.2'
services:
  postgres_exporter_dev:
    image: wrouesnel/postgres_exporter
    environment:
      DATA_SOURCE_NAME: "postgresql://postgres:postgresonesjfsa@10.20.30.32:5432/?sslmode=disable"
    command: 
      - '--extend.query-path=/queries.yaml'
    volumes:
      - /backups/prometheus/dev/queries.yaml:/queries.yaml
  postgres_exporter_test:
    image: wrouesnel/postgres_exporter
    environment:
      DATA_SOURCE_NAME: "postgresql://postgres:postgresonesjfa@10.20.30.32:5433/?sslmode=disable"
    command:
      - '--extend.query-path=/queries.yaml'
    volumes:
      - /backups/prometheus/test/queries.yaml:/queries.yaml
  node_exporter:
    image: quay.io/prometheus/node-exporter
    network_mode: "host"
    pid: "host"
    cap_add:
      - SYS_TIME
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - /backups/prometheus/storage:/prometheus
      - /backups/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.external-url=http://10.20.30.32:9090/'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention=200h'
      - '--web.enable-lifecycle'
      - '--web.enable-admin-api'
      - '--storage.tsdb.min-block-duration=30m'
      - '--storage.tsdb.max-block-duration=1d'
    ports:
      - 9090:9090
  grafana:
    image: grafana/grafana:latest
    ports:
      - 3000:3000
