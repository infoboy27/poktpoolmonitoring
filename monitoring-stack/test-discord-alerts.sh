#!/bin/bash

# Discord Alerts Test Script
# This script simulates different types of alerts that the monitoring stack would send

WEBHOOK_URL="https://discord.com/api/webhooks/1403004748944375840/ub7yx4bwHxvKlGxBpa2vLACly7BY3_t3CQKJ_Lqt-MIrXilcVg3hoA-S2yTs9JthBtct"

echo "🧪 Testing Discord Alerts - POKTpool Monitoring Stack"
echo "====================================================="
echo ""

# Function to send different types of alerts
send_alert() {
    local alert_type="$1"
    local title="$2"
    local description="$3"
    local color="$4"
    local severity="$5"
    
    local alert_message='{
      "username": "POKTpool Monitor",
      "avatar_url": "https://cdn.discordapp.com/attachments/123456789/123456789/alert-bot.png",
      "embeds": [
        {
          "title": "'"$title"'",
          "description": "'"$description"'",
          "color": '"$color"',
          "fields": [
            {
              "name": "🔧 Alert Type",
              "value": "'"$alert_type"'",
              "inline": true
            },
            {
              "name": "⚠️ Severity",
              "value": "'"$severity"'",
              "inline": true
            },
            {
              "name": "⏰ Timestamp",
              "value": "'$(date)'",
              "inline": true
            },
            {
              "name": "💻 Environment",
              "value": "Local Test",
              "inline": true
            }
          ],
          "footer": {
            "text": "POKTpool Monitoring Stack - Test Alert"
          }
        }
      ]
    }'
    
    echo "📤 Sending $alert_type alert..."
    RESPONSE=$(curl -s -w "%{http_code}" -X POST \
      -H "Content-Type: application/json" \
      -d "$alert_message" \
      "$WEBHOOK_URL")
    
    HTTP_CODE="${RESPONSE: -3}"
    
    if [ "$HTTP_CODE" = "204" ]; then
        echo "✅ SUCCESS! $alert_type alert sent to Discord."
    else
        echo "❌ FAILED! HTTP Status: $HTTP_CODE"
    fi
    echo ""
}

echo "🎯 Testing different types of alerts..."
echo ""

# Test 1: High Priority Alert (Red)
send_alert "Node Status" "🚨 Node Status Alert - CRITICAL" "Node is down or not responding to health checks" "16711680" "HIGH"

sleep 2

# Test 2: Medium Priority Alert (Orange)
send_alert "BFT Timing" "⚠️ BFT Propose Time Alert" "BFT propose time is exceeding normal thresholds" "16753920" "MEDIUM"

sleep 2

# Test 3: Low Priority Alert (Yellow)
send_alert "Peer Count" "📊 Total Peers Alert" "Number of connected peers is below optimal level" "16776960" "LOW"

sleep 2

# Test 4: Database Alert (Blue)
send_alert "Database" "💾 DB Partition Size Alert" "Database partition size is approaching limits" "3447003" "MEDIUM"

sleep 2

# Test 5: Resolved Alert (Green)
send_alert "Resolved" "✅ Node Status Resolved" "Node has recovered and is now responding normally" "3066993" "RESOLVED"

echo "🎉 All test alerts completed!"
echo ""
echo "📱 Check your #poktpool-alerts channel for the test messages."
echo ""
echo "📚 Alert Types Tested:"
echo "   🔴 High Priority (Red): Node Status"
echo "   🟠 Medium Priority (Orange): BFT Timing"
echo "   🟡 Low Priority (Yellow): Peer Count"
echo "   🔵 Database (Blue): DB Partition"
echo "   🟢 Resolved (Green): Recovery"
echo ""
echo "🚀 To test with real monitoring data:"
echo "   1. Start Docker Desktop"
echo "   2. Run: make up"
echo "   3. Access Grafana: http://localhost:3000"
echo "   4. Test alerts through Grafana UI"
