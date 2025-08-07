# Discord Alerts Setup Guide

This guide will help you set up Discord alerts for your POKTpool monitoring stack.

## Prerequisites

- A Discord server where you have administrator permissions
- Access to the monitoring stack configuration

## Step 1: Create a Discord Webhook

1. **Open your Discord server** where you want to receive alerts
2. **Go to Server Settings**:
   - Right-click on your server name
   - Select "Server Settings"
3. **Navigate to Integrations**:
   - Click on "Integrations" in the left sidebar
   - Click on "Webhooks"
4. **Create a new webhook**:
   - Click "New Webhook"
   - Give it a name like "POKTpool Monitoring Alerts"
   - Select the channel where you want alerts to be posted
   - Click "Copy Webhook URL" (you'll need this in the next step)
   - Click "Save"

## Step 2: Configure the Monitoring Stack

1. **Edit the `.env` file** in the `monitoring-stack` directory:
   ```bash
   cd monitoring-stack
   nano .env
   ```

2. **Update the Discord webhook URL**:
   ```env
   # Replace this line with your actual webhook URL
   DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN
   ```

3. **Save the file** and restart the monitoring stack:
   ```bash
   make down
   make up
   ```

## Step 3: Test the Discord Integration

1. **Access Grafana**:
   - Open http://localhost:3000 in your browser
   - Login with admin/admin (or your configured credentials)

2. **Navigate to Alerting**:
   - Click on the bell icon in the left sidebar
   - Go to "Contact points"

3. **Test the Discord contact point**:
   - Find "Discord Alerts" in the list
   - Click the three dots menu
   - Select "Test"
   - This will send a test message to your Discord channel

## Step 4: Verify Alert Rules

The monitoring stack includes comprehensive alert rules for:

### High Priority Alerts (Discord + PagerDuty)
- **Node Status**: Node health monitoring
- **Last Height Time**: Block production timing
- **BFT Propose Time**: Consensus timing
- **Non-Signer Percent**: Validator participation

### Medium Priority Alerts (Discord)
- **BFT Timing Metrics**: Election, voting, and commit timing
- **Block Processing**: Size and processing time
- **Database Metrics**: Partition and commit operations
- **Root Chain**: Information retrieval timing

### Low Priority Alerts (Discord)
- **Peer Connectivity**: Total peers count
- **Mempool Metrics**: Size and transaction count
- **Database Partition Time**: Long-running operations

## Alert Message Format

Discord alerts will include:
- 🔴 **Firing Alerts**: Active issues requiring attention
- ✅ **Resolved Alerts**: Issues that have been resolved
- **Alert Name**: The specific metric being monitored
- **Instance**: Which node/server is affected
- **Severity**: Priority level (High/Medium/Low)
- **Summary**: Brief description of the issue
- **Description**: Detailed explanation (if available)
- **Value**: Current metric value (if available)

## Customization

### Modify Alert Rules
Edit the alert rules in:
```
monitoring-stack/monitoring/grafana/provisioning/alerting/alert-rules.yaml
```

### Customize Discord Message Format
Edit the Discord configuration in:
```
monitoring-stack/monitoring/grafana/provisioning/alerting/discord-alert.yaml
```

### Add New Alert Channels
You can add additional notification channels like:
- Email notifications
- Slack integration
- Microsoft Teams
- Custom webhooks

## Troubleshooting

### Discord Notifications Not Working
1. **Check webhook URL**: Ensure the URL is correct and not expired
2. **Verify permissions**: Make sure the webhook has permission to post in the channel
3. **Check Grafana logs**: Look for error messages in the Grafana container logs
4. **Test manually**: Use the "Test" function in Grafana's contact points

### Alerts Not Triggering
1. **Check Prometheus**: Ensure metrics are being collected
2. **Verify alert rules**: Check that alert conditions are properly configured
3. **Review evaluation interval**: Alerts are evaluated every 1 minute by default

### High Alert Volume
If you're receiving too many alerts:
1. **Adjust thresholds**: Modify alert limits in the alert rules
2. **Add grouping**: Configure alert grouping to reduce noise
3. **Set up alert routing**: Route different severity levels to different channels

## Security Considerations

- **Webhook URL**: Keep your Discord webhook URL secure and don't share it publicly
- **Environment Variables**: Use environment variables for sensitive configuration
- **Access Control**: Limit who has access to the monitoring stack
- **Log Rotation**: Configure proper log retention to avoid disk space issues

## Support

If you encounter issues:
1. Check the Grafana logs: `docker logs grafana`
2. Review the alert rules configuration
3. Test individual components (Prometheus, Grafana, etc.)
4. Consult the main README.md for general troubleshooting

## Next Steps

After setting up Discord alerts:
1. **Monitor the alerts**: Watch for false positives and adjust thresholds
2. **Set up escalation**: Configure different channels for different severity levels
3. **Add dashboards**: Create custom dashboards for better visibility
4. **Document procedures**: Create runbooks for common alert scenarios
