#!/bin/bash

# Discord Webhook Test Script for Mac
# This script helps you test Discord alerts locally

echo "🎯 Discord Webhook Test for POKTpool Monitoring"
echo "==============================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Please run setup.sh first."
    exit 1
fi

# Function to test Discord webhook
test_discord_webhook() {
    local webhook_url="$1"
    
    echo "🧪 Testing Discord webhook..."
    echo "📤 Sending test message to Discord..."
    
    # Create test message
    local test_message=$(cat <<EOF
{
  "username": "POKTpool Monitor",
  "avatar_url": "https://cdn.discordapp.com/attachments/123456789/123456789/alert-bot.png",
  "embeds": [
    {
      "title": "🚨 POKTpool Monitoring Alert - TEST",
      "description": "This is a test message to verify Discord alerts are working correctly.",
      "color": 16711680,
      "fields": [
        {
          "name": "🔧 Test Type",
          "value": "Configuration Test",
          "inline": true
        },
        {
          "name": "⏰ Timestamp",
          "value": "$(date)",
          "inline": true
        },
        {
          "name": "💻 Environment",
          "value": "Local Mac Test",
          "inline": true
        }
      ],
      "footer": {
        "text": "POKTpool Monitoring Stack - Test Message"
      }
    }
  ]
}
EOF
)

    # Send the test message
    local response=$(curl -s -w "%{http_code}" -X POST \
        -H "Content-Type: application/json" \
        -d "$test_message" \
        "$webhook_url")
    
    local http_code="${response: -3}"
    local response_body="${response%???}"
    
    if [ "$http_code" = "204" ]; then
        echo "✅ SUCCESS! Test message sent to Discord."
        echo "📱 Check your Discord channel for the test message."
        echo ""
        echo "🔗 Webhook URL: ${webhook_url:0:50}..."
        return 0
    else
        echo "❌ FAILED! HTTP Status: $http_code"
        echo "📄 Response: $response_body"
        echo ""
        echo "🔧 Troubleshooting:"
        echo "   1. Check if the webhook URL is correct"
        echo "   2. Ensure the webhook has permission to post in the channel"
        echo "   3. Verify the channel exists and is accessible"
        return 1
    fi
}

# Check current Discord configuration
echo "📋 Current Discord Configuration:"
echo ""

if grep -q "DISCORD_WEBHOOK_URL=your-discord-webhook-url-here" .env; then
    echo "⚠️  Discord webhook URL is not configured yet."
    echo ""
    echo "📝 To configure Discord alerts:"
    echo "1. Create a Discord webhook in your server"
    echo "2. Copy the webhook URL"
    echo "3. Update the .env file"
    echo ""
    
    read -p "Would you like to configure the webhook URL now? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔧 Please enter your Discord webhook URL:"
        echo "   (Get this from: Server Settings > Integrations > Webhooks)"
        echo ""
        read -p "Webhook URL: " webhook_url
        
        if [[ -n "$webhook_url" ]]; then
            # Update .env file
            sed -i.bak "s|DISCORD_WEBHOOK_URL=your-discord-webhook-url-here|DISCORD_WEBHOOK_URL=$webhook_url|" .env
            echo "✅ Webhook URL updated in .env file"
            echo ""
            
            # Test the webhook
            test_discord_webhook "$webhook_url"
        else
            echo "❌ No webhook URL provided."
        fi
    fi
    
elif grep -q "DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/" .env; then
    echo "✅ Discord webhook URL is configured!"
    echo ""
    
    # Extract the webhook URL
    webhook_url=$(grep "DISCORD_WEBHOOK_URL=" .env | cut -d'=' -f2)
    echo "🔗 Current webhook URL: ${webhook_url:0:50}..."
    echo ""
    
    read -p "Would you like to test the Discord webhook? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        test_discord_webhook "$webhook_url"
    fi
    
else
    echo "⚠️  Discord webhook URL is configured but may not be valid."
    echo "🔧 Please check your .env file and ensure the webhook URL is correct."
fi

echo ""
echo "📚 Additional Testing Options:"
echo "   1. Test through Grafana UI (if stack is running):"
echo "      - Start the stack: make up"
echo "      - Access Grafana: http://localhost:3000"
echo "      - Go to Alerting > Contact Points > Test"
echo ""
echo "   2. Manual curl test:"
echo "      curl -X POST -H 'Content-Type: application/json' \\"
echo "        -d '{\"content\":\"Test message\"}' \\"
echo "        YOUR_WEBHOOK_URL"
echo ""
echo "🚀 To start the full monitoring stack: make up"
echo "🛑 To stop the monitoring stack: make down"
