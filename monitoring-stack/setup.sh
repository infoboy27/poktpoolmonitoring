#!/bin/bash

# POKTpool Monitoring Stack Setup Script

echo "🚀 Setting up POKTpool Monitoring Stack..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << EOF
# POKTpool Monitoring Stack Configuration

# Grafana configuration
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=admin

# Prometheus retention (how long to keep metrics)
PROMETHEUS_RETENTION_TIME=15d

# Loki retention (how long to keep logs)
LOKI_RETENTION_PERIOD=168h

# Monitoring intervals (in seconds)
SCRAPE_INTERVAL=15
EVALUATION_INTERVAL=15

# POKTpool monitoring targets
POKTPOOL_MAIN_URL=https://poktpool.com
POKTPOOL_WWW_URL=https://www.poktpool.com
POKTPOOL_API_HEALTH_URL=https://poktpool.com/api/health
POKTPOOL_STATUS_URL=https://poktpool.com/status
EOF
    echo "✅ .env file created"
else
    echo "✅ .env file already exists"
fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p monitoring/loki/data
mkdir -p monitoring/grafana/data
mkdir -p monitoring/prometheus/data
mkdir -p loadbalancer/certs

# Install Loki Docker plugin if not already installed
echo "🔌 Checking Loki Docker plugin..."
if ! docker plugin ls | grep -q "grafana/loki-docker-driver"; then
    echo "📦 Installing Loki Docker plugin..."
    sudo docker plugin install grafana/loki-docker-driver --alias loki --grant-all-permissions
else
    echo "✅ Loki Docker plugin already installed"
fi

# Set proper permissions
echo "🔐 Setting proper permissions..."
sudo chown -R 472:472 monitoring/grafana/data
sudo chown -R 65534:65534 monitoring/prometheus/data

echo ""
echo "🎉 Setup complete! You can now start the monitoring stack with:"
echo "   make up"
echo ""
echo "📊 Access the monitoring dashboard at:"
echo "   http://localhost:3000 (Grafana)"
echo "   http://localhost:9090 (Prometheus)"
echo "   http://localhost:3100 (Loki)"
echo ""
echo "🔧 For production deployment, edit the .env file and set:"
echo "   - DOMAIN=yourdomain.com"
echo "   - ACME_EMAIL=your-email@example.com" 