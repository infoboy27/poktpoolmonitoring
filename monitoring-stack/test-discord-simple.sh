#!/bin/bash

# Simple Discord Webhook Test
# This script sends a test message to your Discord channel

WEBHOOK_URL="https://discord.com/api/webhooks/1403004748944375840/ub7yx4bwHxvKlGxBpa2vLACly7BY3_t3CQKJ_Lqt-MIrXilcVg3hoA-S2yTs9JthBtct"

echo "🧪 Testing Discord Webhook..."
echo "📤 Sending test message to poktpool-alerts channel..."

# Create a test message
TEST_MESSAGE='{
  "username": "POKTpool Monitor",
  "avatar_url": "https://cdn.discordapp.com/attachments/123456789/123456789/alert-bot.png",
  "embeds": [
    {
      "title": "🚨 POKTpool Monitoring Alert - LOCAL TEST",
      "description": "This is a test message from your local Mac to verify Discord alerts are working correctly.",
      "color": 16711680,
      "fields": [
        {
          "name": "🔧 Test Type",
          "value": "Local Mac Test",
          "inline": true
        },
        {
          "name": "⏰ Timestamp",
          "value": "'$(date)'",
          "inline": true
        },
        {
          "name": "💻 Environment",
          "value": "Local Development",
          "inline": true
        }
      ],
      "footer": {
        "text": "POKTpool Monitoring Stack - Local Test"
      }
    }
  ]
}'

# Send the test message
echo "📤 Sending message..."
RESPONSE=$(curl -s -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d "$TEST_MESSAGE" \
  "$WEBHOOK_URL")

HTTP_CODE="${RESPONSE: -3}"
RESPONSE_BODY="${RESPONSE%???}"

echo ""
if [ "$HTTP_CODE" = "204" ]; then
    echo "✅ SUCCESS! Test message sent to Discord."
    echo "📱 Check your #poktpool-alerts channel for the test message."
    echo ""
    echo "🎉 Discord alerts are working correctly!"
else
    echo "❌ FAILED! HTTP Status: $HTTP_CODE"
    echo "📄 Response: $RESPONSE_BODY"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "   1. Check if the webhook URL is correct"
    echo "   2. Ensure the webhook has permission to post in the channel"
    echo "   3. Verify the channel exists and is accessible"
fi

echo ""
echo "📚 Next Steps:"
echo "   1. Start the monitoring stack: make up"
echo "   2. Access Grafana: http://localhost:3000"
echo "   3. Test alerts through Grafana UI"
