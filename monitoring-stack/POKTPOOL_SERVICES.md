# POKTpool Services Monitoring Overview

This document outlines all POKTpool services that are being monitored with Discord alerts in the monitoring stack.

## 🎯 **POKTpool Services Being Monitored**

### **1. POKTpool Website Services**

#### **Main Website**
- **URL**: https://poktpool.com
- **Monitoring**: Availability, response time, content validation
- **Alerts**: Website down, slow response, content issues
- **Discord Integration**: ✅ Enabled

#### **WWW Subdomain**
- **URL**: https://www.poktpool.com
- **Monitoring**: Availability, response time, content validation
- **Alerts**: Website down, slow response, content issues
- **Discord Integration**: ✅ Enabled

### **2. POKTpool API Services**

#### **API Health Endpoint**
- **URL**: https://poktpool.com/api/health
- **Monitoring**: API availability, response time
- **Alerts**: API down, slow response
- **Discord Integration**: ✅ Enabled

#### **Status Endpoint**
- **URL**: https://poktpool.com/status
- **Monitoring**: Status endpoint availability, response time
- **Alerts**: Status endpoint down, slow response
- **Discord Integration**: ✅ Enabled

### **3. POKTpool SSL/TLS Security**

#### **SSL Certificate Monitoring**
- **URLs**: https://poktpool.com, https://www.poktpool.com
- **Monitoring**: SSL certificate validity, expiration
- **Alerts**: SSL certificate issues, expiration warnings
- **Discord Integration**: ✅ Enabled

## 📊 **Monitoring Metrics**

### **Website Monitoring**
- **Availability**: `probe_success{job="blackbox_poktpool_website_check"}`
- **Response Time**: `probe_duration_seconds{job="blackbox_poktpool_website_check"}`
- **Content Validation**: `probe_failed_due_to_regex{job="blackbox_poktpool_website_check"}`

### **API Monitoring**
- **Availability**: `probe_success{job="blackbox_poktpool_api_check"}`
- **Response Time**: `probe_duration_seconds{job="blackbox_poktpool_api_check"}`

### **SSL Monitoring**
- **Certificate Health**: `probe_success{job="blackbox_poktpool_ssl_check"}`

## 🚨 **Discord Alert Rules**

### **Critical Alerts (Red)**
1. **POKTpool Website Down**
   - Trigger: Website not responding
   - Severity: Critical
   - Discord: ✅ Enabled

2. **POKTpool API Down**
   - Trigger: API endpoints not responding
   - Severity: Critical
   - Discord: ✅ Enabled

3. **POKTpool SSL Certificate Issues**
   - Trigger: SSL certificate problems
   - Severity: Critical
   - Discord: ✅ Enabled

### **Warning Alerts (Orange/Yellow)**
1. **POKTpool Website Slow Response**
   - Trigger: Response time > 5 seconds
   - Severity: Warning
   - Discord: ✅ Enabled

2. **POKTpool API Slow Response**
   - Trigger: Response time > 3 seconds
   - Severity: Warning
   - Discord: ✅ Enabled

3. **POKTpool Content Issues**
   - Trigger: Content doesn't match expected patterns
   - Severity: Warning
   - Discord: ✅ Enabled

## 🔧 **Configuration Files**

### **Prometheus Configuration**
- **File**: `monitoring/prometheus/prometheus.yml`
- **Jobs**: 
  - `blackbox_poktpool_website_check`
  - `blackbox_poktpool_api_check`
  - `blackbox_poktpool_ssl_check`

### **Blackbox Configuration**
- **File**: `monitoring/blackbox/blackbox.yml`
- **Modules**:
  - `poktpool_website_check`
  - `poktpool_api_check`
  - `https_connect`

### **Alert Rules**
- **File**: `monitoring/grafana/provisioning/alerting/poktpool-alerts.yaml`
- **Groups**:
  - `poktpool-website`
  - `poktpool-api`
  - `poktpool-ssl`
  - `poktpool-content`

### **Discord Integration**
- **File**: `monitoring/grafana/provisioning/alerting/discord-alert.yaml`
- **Receiver**: `Discord Alerts`
- **Webhook**: Configured in `.env` file

## 📱 **Discord Alert Format**

All POKTpool alerts include:
- **Service Name**: POKTpool Website/API/SSL
- **Alert Type**: Down/Slow/Content Issues
- **Severity**: Critical/Warning
- **Instance**: Specific URL affected
- **Description**: Detailed issue description
- **Timestamp**: When the alert was triggered

## 🎯 **Monitoring Coverage**

### **✅ Fully Monitored Services**
- [x] POKTpool main website (poktpool.com)
- [x] POKTpool www subdomain (www.poktpool.com)
- [x] POKTpool API health endpoint (/api/health)
- [x] POKTpool status endpoint (/status)
- [x] SSL certificate monitoring
- [x] Content validation
- [x] Response time monitoring

### **✅ Discord Integration**
- [x] All POKTpool alerts configured for Discord
- [x] Proper severity levels (Critical/Warning)
- [x] Rich formatting with emojis and structured data
- [x] Service-specific alert messages
- [x] Real-time notifications

### **✅ Testing Capabilities**
- [x] Local testing scripts for Discord alerts
- [x] Different alert types testing
- [x] Webhook validation
- [x] Message formatting verification

## 🚀 **Deployment Status**

### **Local Development**
- **Status**: ✅ Ready
- **Testing**: ✅ Discord alerts tested
- **Configuration**: ✅ Complete

### **Ubuntu Server Deployment**
- **Status**: ✅ Ready
- **Documentation**: ✅ UBUNTU_DEPLOYMENT.md
- **Configuration**: ✅ Complete

## 📈 **Monitoring Dashboard**

### **Grafana Dashboards**
- **POKTpool Dashboard**: Available at `/etc/grafana/dashboards/poktpool`
- **Metrics**: All POKTpool service metrics
- **Alerts**: Real-time alert status
- **Discord Integration**: Test buttons available

## 🔍 **Troubleshooting**

### **Common Issues**
1. **Website not responding**: Check DNS, server status
2. **API endpoints down**: Verify API service status
3. **SSL certificate issues**: Check certificate expiration
4. **Discord alerts not working**: Verify webhook URL

### **Testing Commands**
```bash
# Test Discord webhook
./test-discord-simple.sh

# Test different alert types
./test-discord-alerts.sh

# Check monitoring stack status
make health-check
```

## 📚 **Additional Resources**

- [Discord Setup Guide](DISCORD_SETUP.md)
- [Ubuntu Deployment Guide](UBUNTU_DEPLOYMENT.md)
- [Alerts Documentation](ALERTS.md)
- [Main README](README.md)

---

**Last Updated**: $(date)
**Status**: ✅ All POKTpool services integrated with Discord alerts
