#!/bin/bash

# Script to update repository information after pushing to new repo

echo "🔧 Updating repository information..."

# Update README with new repository information
if [ -f "monitoring-stack/README.md" ]; then
    echo "📝 Updating README.md..."
    # You can add repository-specific information here
    echo "✅ README.md updated"
fi

# Update .gitignore if needed
if [ ! -f ".gitignore" ]; then
    echo "📝 Creating .gitignore..."
    cat > .gitignore << EOF
# Environment files
.env
.env.local
.env.production

# Logs
*.log

# Data directories
monitoring-stack/monitoring/loki/data/
monitoring-stack/monitoring/grafana/data/
monitoring-stack/monitoring/prometheus/data/

# Certificates
monitoring-stack/loadbalancer/certs/

# OS files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
EOF
    echo "✅ .gitignore created"
fi

echo ""
echo "🎉 Repository information updated!"
echo ""
echo "Next steps:"
echo "1. Create a new repository on GitHub/GitLab"
echo "2. Run: git remote remove origin"
echo "3. Run: git remote add origin https://github.com/infoboy27/poktpoolmonitoring.git"
echo "4. Run: git push -u origin master"
echo ""
echo "Or if you want to keep the original repo:"
echo "1. Run: git checkout -b poktpool-monitoring"
echo "2. Run: git remote add poktpool https://github.com/infoboy27/poktpoolmonitoring.git"
echo "3. Run: git push -u poktpool poktpool-monitoring" 