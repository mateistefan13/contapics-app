#!/bin/bash
set -e

echo "🚀 Stopping Docker Compose..."
docker-compose down

echo "⏳ Waiting a few seconds for services to stop..."
sleep 5

echo "✅ Development setup down!"