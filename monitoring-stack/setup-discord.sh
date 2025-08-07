#!/bin/bash

# Discord Alert Setup Script for POKTpool Monitoring Stack

echo "🎯 Discord Alert Setup for POKTpool Monitoring Stack"
echo "=================================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Please run setup.sh first to create the environment file."
    exit 1
fi

echo "📋 This script will help you configure Discord alerts for your monitoring stack."
echo ""

# Check if Discord webhook URL is already configured
if grep -q "DISCORD_WEBHOOK_URL=your-discord-webhook-url-here" .env; then
    echo "⚠️  Discord webhook URL is not configured yet."
    echo ""
    echo "📝 To set up Discord alerts, you need to:"
    echo "1. Create a Discord webhook in your server"
    echo "2. Copy the webhook URL"
    echo "3. Update the .env file"
    echo ""
    
    read -p "Would you like to open the Discord webhook setup guide? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📖 Opening Discord setup guide..."
        if command -v xdg-open &> /dev/null; then
            xdg-open "https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks"
        elif command -v open &> /dev/null; then
            open "https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks"
        else
            echo "🌐 Please visit: https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks"
        fi
    fi
    
    echo ""
    echo "🔧 After creating your webhook, edit the .env file and replace:"
    echo "   DISCORD_WEBHOOK_URL=your-discord-webhook-url-here"
    echo "   with your actual webhook URL"
    echo ""
    echo "📖 For detailed instructions, see: DISCORD_SETUP.md"
    
elif grep -q "DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/" .env; then
    echo "✅ Discord webhook URL is already configured!"
    echo ""
    
    # Extract the webhook URL for display
    WEBHOOK_URL=$(grep "DISCORD_WEBHOOK_URL=" .env | cut -d'=' -f2)
    echo "🔗 Current webhook URL: ${WEBHOOK_URL:0:50}..."
    echo ""
    
    read -p "Would you like to test the Discord integration? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🧪 Testing Discord integration..."
        echo "📊 Please check your Discord channel for a test message."
        echo "💡 You can also test through Grafana UI at http://localhost:3000"
    fi
    
    echo ""
    echo "🎉 Discord alerts are ready! Your monitoring stack will send alerts to Discord."
    echo "📖 For troubleshooting, see: DISCORD_SETUP.md"
    
else
    echo "⚠️  Discord webhook URL is configured but may not be valid."
    echo "🔧 Please check your .env file and ensure the webhook URL is correct."
fi

echo ""
echo "📚 Additional Resources:"
echo "   - DISCORD_SETUP.md - Detailed setup guide"
echo "   - ALERTS.md - Alert rules documentation"
echo "   - README.md - General monitoring stack documentation"
echo ""
echo "🚀 To start the monitoring stack: make up"
echo "🛑 To stop the monitoring stack: make down"
