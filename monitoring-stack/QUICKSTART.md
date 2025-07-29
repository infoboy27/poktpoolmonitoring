# POKTpool Monitoring Stack - Quick Start Guide

This guide will help you quickly set up and run the POKTpool monitoring stack to monitor poktpool.com.

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB RAM and 50GB storage available
- Linux/macOS/Windows with Docker support

## Quick Setup

### 1. Clone and Navigate
```bash
cd monitoring-stack
```

### 2. Run Setup Script
```bash
./setup.sh
```

This script will:
- Check Docker installation
- Create necessary directories
- Install Loki Docker plugin
- Create a default .env file
- Set proper permissions

### 3. Start the Stack
```bash
make up
```

### 4. Access Dashboards

Once the stack is running, you can access:

- **Grafana Dashboard**: http://localhost:3000
  - Username: `admin`
  - Password: `admin`
  - Navigate to the "POKTpool" folder to see the main monitoring dashboard

- **Prometheus**: http://localhost:9090
- **Loki Logs**: http://localhost:3100

## What's Being Monitored

The stack monitors:

1. **POKTpool Website**: poktpool.com and www.poktpool.com
2. **Response Times**: How fast the website responds
3. **SSL Status**: Certificate validity and expiry
4. **API Health**: Available API endpoints
5. **System Resources**: CPU, memory, disk usage
6. **Container Metrics**: Performance of monitoring services

## Useful Commands

```bash
# Start the stack
make up

# Stop the stack
make down

# View logs
make logs

# Check status
make status

# Reset all data
make reset

# Health check
make health-check
```

## Production Deployment

For production deployment:

1. Edit `.env` file and set:
   ```
   DOMAIN=yourdomain.com
   ACME_EMAIL=your-email@example.com
   ```

2. Configure DNS to point to your server

3. Open ports 80 and 443

4. Run `make up`

## Troubleshooting

### Common Issues

1. **Port already in use**: Stop other services using ports 3000, 9090, 3100
2. **Permission denied**: Run `sudo ./setup.sh` to fix permissions
3. **Docker not running**: Start Docker service
4. **Loki plugin error**: Run `sudo docker plugin install grafana/loki-docker-driver --alias loki --grant-all-permissions`

### Check Logs
```bash
# All logs
make logs

# Monitoring services only
make logs-monitoring

# Infrastructure services only
make logs-infrastructure
```

## Next Steps

- Customize alerting rules in `monitoring/grafana/provisioning/alerting/`
- Add more monitoring targets in `monitoring/prometheus/prometheus.yml`
- Configure notification channels (Discord, PagerDuty, etc.)
- Set up backup and retention policies

For detailed configuration, see the main [README.md](README.md). 