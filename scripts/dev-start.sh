#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -d "$SCRIPT_DIR/../.venv" ]; then
    echo "🐍 Creating Python virtual environment..."
    python3 -m venv "$SCRIPT_DIR/../.venv"
    echo "📦 Installing required Python packages..."
    "$SCRIPT_DIR/../.venv/bin/pip" install --upgrade pip
    "$SCRIPT_DIR/../.venv/bin/pip" install ansible psycopg2-binary
fi

# Activating a python env because in WSL you cannot install externally managed Python
source "$SCRIPT_DIR/../.venv/bin/activate"

echo "🚀 Starting Docker Compose..."
docker-compose --env-file "$SCRIPT_DIR/../.env" up -d

export $(grep -v '^#' "$SCRIPT_DIR/../.env" | sed 's/\r$//' | xargs)

echo "⏳ Waiting a few seconds for services to be ready..."
sleep 10

echo "🛠 Running Ansible development setup..."
ansible-playbook "$SCRIPT_DIR/../playbooks/dev-setup.yml"

echo "✅ Development setup complete! You can now access:"
echo "- Backend: http://localhost:${BACKEND_PORT}"
echo "- Frontend: http://localhost:${FRONTEND_PORT}"
echo "- MinIO Web: http://localhost:9001"
