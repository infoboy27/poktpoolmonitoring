# POKTpool monitoring stack overview

This docker-compose.yaml contains a comprehensive monitoring stack for monitoring poktpool.com and related services. The stack includes Prometheus, Grafana, Loki for log aggregation, and various exporters for infrastructure monitoring.

We added a [.env](./.env) which is the file we use to parametrize all configurations in order to setup your personal POKTpool monitoring stack. It is intended to run by default for local testing but can be easily modified via .env variable to be configured for more robust staging/production purposes.

## Setup

### System Requirements

#### Complete Monitoring Stack
- **Minimum**: 4GB RAM | 2vCPU | 50GB storage
- **Recommended**: 8GB RAM | 4vCPU | 100GB storage

**Component-specific requirements:**

#### Monitoring components
- **Prometheus**: 1GB RAM | 1vCPU | 20GB storage (for metrics storage)
- **Grafana**: 512MB RAM | 1vCPU | 5GB storage (for dashboards and UI)
- **Loki**: 1GB RAM | 1vCPU | 20GB storage (for log storage)
- **Cadvisor**: 256MB RAM | 1vCPU | 2GB storage (for container metrics)
- **Traefik**: 256MB RAM | 1vCPU | 1GB storage (for load balancing)
- **Node Exporter**: 128MB RAM | 1vCPU | 1GB storage (for host metrics)
- **Blackbox Exporter**: 128MB RAM | 1vCPU | 1GB storage (for endpoint monitoring)

### .env 

Copy the env variable as example in order to activate its usage 

```bash
cp .env.template .env
```

### Grafana loki plugin

Install the loki plugin so all of our logs can be ingested by loki 

```bash
sudo docker plugin install grafana/loki-docker-driver --alias loki
```

### Grafana notification channels

In order to correctly receive the infrastructure and POKTpool alerts on this setup stack you should configure the discord and the pagerduty notification channel configs:

#### Discord Alerts Setup
For detailed Discord setup instructions, see: [Discord Setup Guide](./DISCORD_SETUP.md)

Quick setup:
1. Create a Discord webhook in your server settings
2. Update the `DISCORD_WEBHOOK_URL` in your `.env` file
3. Restart the monitoring stack

[Discord channel webhook](./monitoring/grafana/provisioning/alerting/discord-alert.yaml#L28)

#### PagerDuty Alerts Setup
[Pagerduty APIKEY](./monitoring/grafana/provisioning/alerting/pagerduty-alert.yaml#L9)

### Required Ports

This section describes the ports opened externally and internally by this setup. 

Make sure you open the external ports in order to properly configure POKTpool monitoring.

#### Load Balancer Ports
- **80**: HTTP traffic (redirects to HTTPS in production)
- **443**: HTTPS traffic (SSL/TLS)

#### Monitoring Ports
- **3000**: Grafana web interface
- **9090**: Prometheus metrics endpoint
- **3100**: Loki log aggregation
- **8082**: Traefik metrics endpoint
- **9115**: Blackbox exporter metrics
- **8080**: cAdvisor container metrics
- **9100**: Node exporter host metrics

## Running

### Local

```bash
sudo make up
```

This stack runs the following local monitoring services:

- http://monitoring.localhost/ - Grafana monitoring interface
  - user: admin, pass: admin (default)

### Clearing data

This command clears all monitoring data for a hard reset of the environment

```bash
sudo make reset
```

## Production

This stack lets you run a production deployment of the POKTpool monitoring stack by just changing a small number of settings shown below:

### Ubuntu Server Deployment

For Ubuntu server deployment, see the comprehensive guide: [Ubuntu Deployment Guide](./UBUNTU_DEPLOYMENT.md)

Quick Ubuntu setup:
```bash
# Clone and setup
git clone https://github.com/your-username/poktpoolmonitoring.git
cd poktpoolmonitoring/monitoring-stack
chmod +x setup.sh setup-discord.sh
./setup.sh

# Configure Discord alerts (optional)
make setup-discord

# Start the stack
make up
```

### Step 1: Define your env variables

#### $DOMAIN

With a `DOMAIN` variable defined on [.env.template](/.env.template) traefik will expose and validate SSL on this endpoints externally.

#### $ACME_EMAIL

We use this env variable to request SSL ACME certificate during [traefik HTTPS validation](./loadbalancer/traefik.yml)

For more information check the Traefik section below

### Step 2: Configure your DNS

Your domain should point to your production server:

*.monitoring.<YOUR_DOMAIN> A record -> ||YOUR IP||

Once it's done, make sure your DNS are properly configured so traefik can request the SSL certificates and expose your monitoring services under your domain.

### Step 3: Open external ports

As described in the ports section, the monitoring stack requires the following ports opened:

#### Load Balancer Ports
- **80**: HTTP traffic (redirects to HTTPS in production)
- **443**: HTTPS traffic (SSL/TLS)

You should be able to expose this ports via your cloud provider and/or by opening as well ufw as described below

#### Firewall Configuration Example (UFW)
```bash
# Load balancer ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### Step 4: Run

```bash
sudo make up
```

Traefik will take some time for requesting the SSL Certificates and will expose the services accordingly.

## Monitoring stack configuration

Below you will find the configuration file references and instructions in order to understand and customize the current setup.

You can also find additional documentation below regarding the current setup:

[Metric documentation](./METRICS.md)

[Alert documentation](./ALERTS.md)

### Grafana

Grafana comes with default dashboards described below along with their configuration files and some other env variables described on (.env)[.env]

#### - [POKTpool dashboard](http://localhost:3000/d/poktpool-monitoring/poktpool-monitoring-dashboard?orgId=1&from=now-1h&to=now&timezone=browser)

Dashboard with POKTpool website monitoring metrics including availability, response times, SSL status, and API health.

#### - [Blackbox dashboard](http://localhost:3000/d/xtkCtBkis/blackbox-exporter?var-interval=10s&orgId=1&from=now-15m&to=now&timezone=browser&var-target=$__all&var-source=$__all&var-destination=$__all&refresh=1m)

Dashboard with blackbox metrics which continuously tests the POKTpool website and API endpoints.

#### - [Cadvisor exporter](http://localhost:3000/d/pMEd7m0Mz/cadvisor-exporter?orgId=1&from=now-6h&to=now&timezone=browser&var-host=$__all&var-container=$__all&var-DS_PROMETHEUS=PBFA97CFB590B2093)

Dashboard with resources metrics for docker containers.

#### - [Node exporter](http://localhost:3000/d/rYdddlPWk/node-exporter-full?orgId=1&from=now-24h&to=now&timezone=browser&var-datasource=default&var-job=node-exporter&var-node=node-exporter:9100&var-diskdevices=%5Ba-z%5D%2B%7Cnvme%5B0-9%5D%2Bn%5B0-9%5D%2B%7Cmmcblk%5B0-9%5D%2B&refresh=1m)

Dashboard with resource metrics for the host instance.

#### - [Traefik dashboard](http://localhost:3000/d/O23g2BeWk/traefik-dashboard?orgId=1&from=now-5m&to=now&timezone=browser&var-service=&var-entrypoint=$__all&refresh=5m)

Dashboard with loadbalancer metrics.

#### - [Instance monitoring alerts](http://localhost:3000/d/KljDeaZ4z/blockchain-node-instance-dashboard?orgId=1&from=now-15m&to=now&timezone=browser&var-DS_PROMETHEUS=default&var-job=node-exporter)

Dashboard with host container metrics.

[dashboard folder](./monitoring/grafana/dashboards)
[dashboard config](./monitoring/grafana/provisioning/dashboards/dashboard.yaml)
[datasources config](./monitoring/grafana/provisioning/datasources/automatic.yaml)

### Prometheus

Configuration is mainly described on the prometheus.yml configuration file.

[prometheus.yml](./monitoring/prometheus/prometheus.yml)

The Prometheus configuration monitors:
- POKTpool website availability (poktpool.com and www.poktpool.com)
- POKTpool API endpoints (if available)
- SSL certificate status
- System metrics (CPU, memory, disk)
- Container metrics
- Load balancer metrics

### Cadvisor

Used for server metrics, we use the vanilla config which is described in docker-compose.yaml.

### Node-exporter

Used for exporting node metrics, we use the vanilla config which is described in docker-compose.yaml.

### Blackbox

We use blackbox for testing and monitoring POKTpool website and API endpoints.

[blackbox.yml](./monitoring/blackbox/blackbox.yml)

The blackbox exporter monitors:
- Website availability and response times
- SSL certificate validity
- API endpoint health
- Content verification (checking for POKTpool-specific content)

### Traefik

As mentioned, we use traefik as loadbalancer for exposing monitoring software on two setups local and production.

Traefik will automatically create certs for all the URLs described in the # Running section in this document.

##### Traefik key settings

[Traefik general config](./loadbalancer/traefik.yml)

[Production services](./loadbalancer/services/prod.yaml)

[Local services](./loadbalancer/services/local.yaml)

[Middlewares config](./loadbalancer/services/middleware.yaml)

#### SSL resolver

We use acme as SSL certificate resolver with httpChallenge by default which can be used for production, our documentation also contains `cloudflare` and `namecheap` integration for dnsChallenge recommended for production grade usage.

For more information please check [traefik config](./loadbalancer/traefik.yml) on the section https-resolver, below you'll find details about the https-resolvers described in this file:

*https-resolver*

It's the one used by default for production grade SSL, validation is based on httpChallenge validation.

*cloudflare*

It's the recommended one (or any compatible https DNS resolver for your provider) since DNS resolver is way more effective than httpChallenge.

*namecheap*

Added for educational purposes.

For more information about https-resolvers please refer to [traefik https-resolvers](https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/overview/)

#### Loki

We use loki for logs which takes all the stdout from the containers and sends it to the loki container. More info on (docker-compose.yaml)[./docker-compose.yaml]

[Loki config](./monitoring/loki/config.yaml)

For ex.: to access loki logs after you executed the docker-compose up command you should see it [here](http://localhost:3000/explore?schemaVersion=1&panes=%7B%225v4%22:%7B%22datasource%22:%22beh1gkva12hvkd%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22expr%22:%22%7Bcompose_service%3D%5C%22blackbox%5C%22%7D%20%7C%3D%20%60%60%22,%22queryType%22:%22range%22,%22datasource%22:%7B%22type%22:%22loki%22,%22uid%22:%22beh1gkva12hvkd%22%7D,%22editorMode%22:%22builder%22,%22direction%22:%22backward%22%7D%5D,%22range%22:%7B%22from%22:%22now-1h%22,%22to%22:%22now%22%7D%7D%7D&orgId=1)

## What is being monitored

This monitoring stack is specifically designed to monitor poktpool.com and includes:

1. **Website Availability**: Continuous monitoring of poktpool.com and www.poktpool.com
2. **Response Times**: Tracking of website and API response times
3. **SSL Certificate Status**: Monitoring SSL certificate validity and expiry
4. **API Health**: Monitoring of POKTpool API endpoints (if available)
5. **System Resources**: CPU, memory, and disk usage of the monitoring server
6. **Container Metrics**: Performance metrics of all monitoring containers
7. **Load Balancer Metrics**: Traefik performance and routing statistics

The monitoring provides real-time alerts and historical data to ensure poktpool.com remains available and performs optimally.
