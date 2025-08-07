# Ubuntu Server Deployment Guide

This guide provides step-by-step instructions for deploying the POKTpool monitoring stack on Ubuntu servers.

## Prerequisites

### System Requirements
- **Ubuntu 20.04 LTS or 22.04 LTS** (recommended)
- **Minimum**: 4GB RAM, 2vCPU, 50GB storage
- **Recommended**: 8GB RAM, 4vCPU, 100GB storage
- **Network**: Stable internet connection for Docker image downloads

### Required Software
- Docker Engine
- Docker Compose
- Git

## Step 1: Server Preparation

### Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### Install Required Packages
```bash
# Install essential packages
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    unzip \
    htop \
    ufw
```

### Configure Firewall
```bash
# Enable UFW
sudo ufw enable

# Allow SSH (adjust port if needed)
sudo ufw allow ssh

# Allow monitoring ports
sudo ufw allow 3000/tcp  # Grafana
sudo ufw allow 9090/tcp  # Prometheus
sudo ufw allow 3100/tcp  # Loki
sudo ufw allow 80/tcp     # HTTP (if using Traefik)
sudo ufw allow 443/tcp    # HTTPS (if using Traefik)

# Check firewall status
sudo ufw status
```

## Step 2: Install Docker

### Install Docker Engine
```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER

# Verify installation
docker --version
docker compose version
```

### Configure Docker Log Rotation
```bash
# Create Docker daemon configuration
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Restart Docker to apply settings
sudo systemctl restart docker
```

## Step 3: Deploy Monitoring Stack

### Clone Repository
```bash
# Clone the repository
git clone https://github.com/your-username/poktpoolmonitoring.git
cd poktpoolmonitoring/monitoring-stack

# Make scripts executable
chmod +x setup.sh setup-discord.sh
```

### Run Setup Script
```bash
# Run the setup script
./setup.sh
```

### Configure Environment
```bash
# Edit the .env file
nano .env
```

Update the following variables for production:
```env
# Production settings
DOMAIN=your-domain.com
ACME_EMAIL=your-email@domain.com

# Discord webhook (optional)
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN

# Security settings
GRAFANA_ADMIN_USER=your-admin-username
GRAFANA_ADMIN_PASSWORD=your-secure-password

# Retention settings (adjust based on storage)
PROMETHEUS_RETENTION_TIME=30d
LOKI_RETENTION_PERIOD=720h
```

## Step 4: Configure Discord Alerts (Optional)

```bash
# Run Discord setup
make setup-discord

# Or manually configure
nano .env
# Add your Discord webhook URL
```

## Step 5: Start the Stack

```bash
# Start all services
make up

# Check status
make status

# View logs
make logs
```

## Step 6: Access Monitoring Dashboards

### Local Access
- **Grafana**: http://localhost:3000
- **Prometheus**: http://localhost:9090
- **Loki**: http://localhost:3100

### Remote Access (if configured with domain)
- **Grafana**: https://your-domain.com
- **Prometheus**: https://your-domain.com/prometheus
- **Loki**: https://your-domain.com/loki

## Step 7: Production Optimizations

### System Tuning
```bash
# Increase file descriptor limits
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

# Optimize kernel parameters
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Monitoring Stack Tuning
```bash
# Create systemd service for auto-restart
sudo tee /etc/systemd/system/poktpool-monitoring.service > /dev/null <<EOF
[Unit]
Description=POKTpool Monitoring Stack
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/path/to/poktpoolmonitoring/monitoring-stack
ExecStart=/usr/bin/make up
ExecStop=/usr/bin/make down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable poktpool-monitoring.service
sudo systemctl start poktpool-monitoring.service
```

### Backup Configuration
```bash
# Create backup script
cat > backup-monitoring.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup/monitoring/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup configuration files
cp -r monitoring/grafana/provisioning $BACKUP_DIR/
cp -r monitoring/prometheus $BACKUP_DIR/
cp -r monitoring/loki $BACKUP_DIR/
cp docker-compose.yaml $BACKUP_DIR/
cp .env $BACKUP_DIR/

# Backup data (optional - can be large)
# cp -r monitoring/grafana/data $BACKUP_DIR/
# cp -r monitoring/prometheus/data $BACKUP_DIR/
# cp -r monitoring/loki/data $BACKUP_DIR/

echo "Backup completed: $BACKUP_DIR"
EOF

chmod +x backup-monitoring.sh
```

## Step 8: Monitoring and Maintenance

### Health Checks
```bash
# Check service status
make health-check

# Monitor system resources
htop

# Check disk usage
df -h

# Check Docker disk usage
docker system df
```

### Log Management
```bash
# View recent logs
make logs

# View specific service logs
docker compose logs -f grafana
docker compose logs -f prometheus
docker compose logs -f loki
```

### Updates and Maintenance
```bash
# Update the stack
git pull
make down
make up

# Clean up Docker resources
docker system prune -f

# Update Docker images
docker compose pull
docker compose up -d
```

## Troubleshooting

### Common Issues

#### Docker Permission Issues
```bash
# If you get permission errors
sudo usermod -aG docker $USER
newgrp docker
```

#### Port Conflicts
```bash
# Check what's using the ports
sudo netstat -tulpn | grep :3000
sudo netstat -tulpn | grep :9090
sudo netstat -tulpn | grep :3100
```

#### Disk Space Issues
```bash
# Clean up Docker
docker system prune -a -f

# Check disk usage
df -h
du -sh monitoring/*/data
```

#### Service Won't Start
```bash
# Check Docker daemon
sudo systemctl status docker

# Check container logs
docker compose logs

# Restart Docker
sudo systemctl restart docker
```

### Performance Issues

#### High Memory Usage
```bash
# Check memory usage
free -h
docker stats

# Adjust resource limits in docker-compose.yaml
```

#### High CPU Usage
```bash
# Check CPU usage
top
docker stats

# Consider reducing scrape intervals in .env
```

## Security Considerations

### Firewall Configuration
```bash
# Only allow necessary ports
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 3000/tcp  # Grafana
sudo ufw allow 9090/tcp  # Prometheus
sudo ufw allow 3100/tcp  # Loki
```

### SSL/TLS Configuration
```bash
# For production, use proper SSL certificates
# Configure in docker-compose.yaml with Traefik
```

### Access Control
```bash
# Change default passwords
# Use strong passwords in .env file
# Consider setting up authentication proxy
```

## Monitoring Stack Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Grafana       │    │   Prometheus    │    │   Loki          │
│   (Port 3000)   │    │   (Port 9090)   │    │   (Port 3100)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Traefik       │
                    │   (Load Balancer)│
                    └─────────────────┘
```

## Support and Maintenance

### Regular Tasks
- **Daily**: Check service status and logs
- **Weekly**: Review alert configurations and thresholds
- **Monthly**: Update Docker images and security patches
- **Quarterly**: Review and optimize resource usage

### Monitoring Stack Updates
```bash
# Update the repository
git pull origin main

# Update Docker images
docker compose pull

# Restart with new configuration
make down
make up
```

### Backup Strategy
- **Configuration**: Backup provisioning files weekly
- **Data**: Backup metrics and logs monthly
- **Full Stack**: Complete backup quarterly

For additional support, refer to:
- [Discord Setup Guide](DISCORD_SETUP.md)
- [Alerts Documentation](ALERTS.md)
- [Main README](README.md)
