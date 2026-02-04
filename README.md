# RIBA - Production-Ready FastAPI Backend

A clean, scalable, and production-ready FastAPI backend project with complete Docker support, API versioning, and separation of concerns.

## 🚀 Features

- **FastAPI Framework**: Modern, fast (high-performance) web framework
- **Python 3.11**: Latest stable Python version
- **Docker & Docker Compose**: Complete containerization setup
- **Clean Architecture**: Well-organized layers (API, Services, Repositories, Integrations)
- **API Versioning**: Structured versioning with `/api/v1` prefix
- **Health Checks**: Built-in health check endpoints
- **CORS Support**: Cross-origin resource sharing enabled
- **Logging**: Comprehensive logging throughout the application
- **Environment Configuration**: Centralized configuration management
- **Production Ready**: Optimized Dockerfile, health checks, and best practices

## 📁 Project Structure

```
riba/
├── backend/
│   ├── app/
│   │   ├── main.py                      # FastAPI application factory
│   │   ├── api/
│   │   │   └── v1/
│   │   │       ├── router.py            # V1 router registration
│   │   │       └── endpoints/           # API endpoint modules
│   │   │           ├── auth.py
│   │   │           ├── chat.py
│   │   │           ├── observation.py
│   │   │           ├── risk.py
│   │   │           └── teacher_panel.py
│   │   ├── services/                    # Business logic services
│   │   │   ├── anonymizer_service.py
│   │   │   ├── nlp_service.py
│   │   │   ├── risk_scoring_service.py
│   │   │   └── notification_service.py
│   │   ├── repositories/                # Data access layer
│   │   │   ├── firestore_repo.py
│   │   │   └── user_repo.py
│   │   ├── integrations/                # External service clients
│   │   │   ├── firebase_client.py
│   │   │   ├── n8n_client.py
│   │   │   └── llm_client.py
│   │   ├── schemas/                     # Pydantic models (empty, ready to expand)
│   │   ├── core/
│   │   │   └── config.py                # Application configuration
│   │   └── utils/
│   │       └── logger.py                # Logging utilities
│   ├── Dockerfile                       # Docker image definition
│   ├── requirements.txt                 # Python dependencies
│   └── README.md                        # Backend documentation
│
├── docker-compose.yml                   # Docker Compose configuration
├── .env                                 # Environment variables
├── .dockerignore                        # Docker build ignore patterns
└── README.md                            # Project documentation
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- OR Python 3.11+ for local development

### With Docker (Recommended)

```bash
# Navigate to project directory
cd riba

# Build and run
docker compose up --build

# Verify it's running
curl http://localhost:8000/health

# View API docs
# Open http://localhost:8000/docs in browser
```

### Local Development

```bash
cd riba/backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run application
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Access API
# http://localhost:8000/docs
```

## 📚 API Documentation

Once the application is running, visit:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

### Available Endpoints

All endpoints are prefixed with `/api/v1/`

#### Authentication
- `POST /auth/login` - Login user
- `POST /auth/logout` - Logout user
- `POST /auth/register` - Register new user

#### Chat
- `GET /chat/` - Get all chats
- `POST /chat/` - Create new chat
- `GET /chat/{chat_id}` - Get specific chat
- `POST /chat/{chat_id}/message` - Send message

#### Observations
- `GET /observation/` - List observations
- `POST /observation/` - Create observation
- `GET /observation/{observation_id}` - Get specific observation
- `PUT /observation/{observation_id}` - Update observation

#### Risk Assessment
- `GET /risk/score/{observation_id}` - Get risk score
- `POST /risk/assess` - Assess risk
- `GET /risk/summary` - Get risk summary

#### Teacher Panel
- `GET /teacher-panel/dashboard` - Get dashboard
- `GET /teacher-panel/students` - List students
- `GET /teacher-panel/students/{student_id}` - Get student
- `POST /teacher-panel/alerts` - Create alert

## ⚙️ Configuration

### Environment Variables

Edit `.env` file to configure:

```env
# Application
DEBUG=False
APP_NAME=RIBA API
APP_VERSION=1.0.0

# Firebase
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key

# N8N Workflow Automation
N8N_BASE_URL=http://localhost:5678
N8N_API_KEY=your-n8n-key

# LLM/AI Integration
LLM_API_KEY=your-llm-key
LLM_MODEL=gpt-3.5-turbo

# Server
HOST=0.0.0.0
PORT=8000
```

### Application Settings

Core settings are in `backend/app/core/config.py`. Extend the `Settings` class to add new configuration options.

## 🏗️ Architecture

### Layers

1. **API Layer** (`api/v1/endpoints/`)
   - HTTP request/response handling
   - Route definitions
   - Input validation

2. **Service Layer** (`services/`)
   - Business logic
   - Data processing
   - External service orchestration

3. **Repository Layer** (`repositories/`)
   - Database access
   - CRUD operations
   - Data abstraction

4. **Integration Layer** (`integrations/`)
   - External service clients
   - Third-party API communication
   - Authentication with external systems

### Services Included

- **AnonymizerService**: Data anonymization
- **NLPService**: Natural language processing
- **RiskScoringService**: Risk calculation and assessment
- **NotificationService**: Multi-channel notifications (Email, Push, SMS)

### Integrations Included

- **FirebaseClient**: Firebase authentication and database
- **N8NClient**: Workflow automation
- **LLMClient**: Large language models (OpenAI, etc.)

## 🔧 Development

### Adding New Endpoints

1. Create file in `backend/app/api/v1/endpoints/`:
```python
from fastapi import APIRouter

router = APIRouter()

@router.get("/example")
async def example():
    return {"message": "Example endpoint"}
```

2. Register in `backend/app/api/v1/router.py`:
```python
from app.api.v1.endpoints import example

router.include_router(example.router, prefix="/example", tags=["example"])
```

### Adding New Services

1. Create class in `backend/app/services/`:
```python
class MyService:
    @staticmethod
    def my_method():
        return "result"
```

2. Use in endpoints:
```python
from app.services.my_service import MyService

@router.get("/")
async def my_endpoint():
    result = MyService.my_method()
    return {"result": result}
```

### Adding New Repositories

1. Create class in `backend/app/repositories/`:
```python
class MyRepository:
    async def get_data(self, id: str):
        # Implement data access
        return {}
```

## 🐳 Docker Commands

```bash
# Build image
docker build -t riba-backend -f backend/Dockerfile ./backend

# Run container
docker run -p 8000:8000 riba-backend

# Docker Compose
docker compose up                  # Start services
docker compose up --build         # Rebuild and start
docker compose down               # Stop services
docker compose logs -f            # View logs
docker compose ps                 # Show running services
```

## 📝 Notes

- All endpoints return JSON responses
- Placeholder implementations ready for expansion
- Logging configured throughout application
- Health checks enabled for Docker
- CORS enabled for frontend integration
- Ready for production deployment

## 🔐 Production Checklist

- [ ] Set `DEBUG=False` in production
- [ ] Configure real Firebase credentials
- [ ] Set up N8N workflows
- [ ] Configure LLM API keys
- [ ] Use environment-specific secrets management
- [ ] Set up monitoring and alerting
- [ ] Configure proper logging aggregation
- [ ] Set up automated backups
- [ ] Configure CORS with specific origins
- [ ] Enable HTTPS in production

## 📜 License

All rights reserved

## 🤝 Support

For issues or questions, refer to the backend documentation in `backend/README.md`.

## Team
- Ayşe Nur (Backend & DevOps)