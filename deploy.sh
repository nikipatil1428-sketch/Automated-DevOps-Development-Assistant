#!/bin/bash

set -e

echo "🚀 Starting DevOps Assistant Deployment"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Check dependencies
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 not found. Installing...${NC}"
        sudo apt-get install -y $1
    else
        echo -e "${GREEN}✅ $1 found${NC}"
    fi
}

check_dependency "docker"
check_dependency "docker-compose"
check_dependency "python3"
check_dependency "git"

# Build and run
echo "📦 Building Docker image..."
docker build -t devops-assistant:latest .

echo "🧪 Running tests..."
docker run --rm devops-assistant:latest pytest tests/

echo "🚀 Starting services..."
docker-compose up -d

echo "✅ Deployment complete!"
echo "📊 Monitoring: http://localhost:3000 (admin/admin)"
echo "🔗 App: http://localhost:5000"

# Health check
sleep 5
curl -f http://localhost:5000/health || echo -e "${RED}⚠️  Health check failed${NC}"