# RIBA Backend API

Production-ready FastAPI backend for RIBA with Docker support.

## Features

- **FastAPI**: Modern, fast web framework for building APIs
- **Python 3.11**: Latest stable Python version
- **Docker Support**: Complete Docker and docker-compose setup
- **Clean Architecture**: Separation of concerns with layers (API, Services, Repositories, Integrations)
- **API Versioning**: Versioned API structure (/api/v1)
- **Extensible**: Easy to add new endpoints, services, and integrations

## Project Structure

```
backend/
├── app/
│   ├── main.py                 # FastAPI application factory
│   ├── api/v1/
│   │   ├── router.py           # V1 router registration
│   │   └── endpoints/          # Endpoint modules
│   ├── services/               # Business logic services
│   ├── repositories/           # Data access layer
│   ├── integrations/           # External service clients
│   ├── schemas/                # Pydantic models
│   ├── core/                   # Core configuration
│   └── utils/                  # Utility functions
├── Dockerfile                  # Docker image definition
├── requirements.txt            # Python dependencies
└── README.md                   # Backend documentation
```

## Quick Start

### Prerequisites

- Python 3.11+
- Docker and Docker Compose (for containerized setup)

### Local Development

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run the application:**
   ```bash
   python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

3. **Check health:**
   ```bash
   curl http://localhost:8000/health
   ```

4. **View API documentation:**
   - Swagger UI: http://localhost:8000/docs
   - ReDoc: http://localhost:8000/redoc

### Docker Setup

1. **Build and run with docker-compose:**
   ```bash
   docker compose up --build
   ```

2. **Check health:**
   ```bash
   curl http://localhost:8000/health
   ```

3. **Stop services:**
   ```bash
   docker compose down
   ```

## API Endpoints

All endpoints are prefixed with `/api/v1`.

### Authentication (`/api/v1/auth`)
- `POST /login` - Login user
- `POST /logout` - Logout user
- `POST /register` - Register new user

### Chat (`/api/v1/chat`)
- `GET /` - Get all chats
- `POST /` - Create new chat
- `GET /{chat_id}` - Get chat by ID
- `POST /{chat_id}/message` - Send message in chat

### Observation (`/api/v1/observation`)
- `GET /` - Get all observations
- `POST /` - Create new observation
- `GET /{observation_id}` - Get observation by ID
- `PUT /{observation_id}` - Update observation

### Risk Assessment (`/api/v1/risk`)
- `GET /score/{observation_id}` - Get risk score
- `POST /assess` - Assess risk
- `GET /summary` - Get risk summary

### Teacher Panel (`/api/v1/teacher-panel`)
- `GET /dashboard` - Get teacher dashboard
- `GET /students` - Get students list
- `GET /students/{student_id}` - Get student details
- `POST /alerts` - Create alert

## Environment Variables

Create a `.env` file in the backend directory:

```env
DEBUG=False
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
N8N_BASE_URL=http://localhost:5678
N8N_API_KEY=your-n8n-key
LLM_API_KEY=your-llm-key
LLM_MODEL=gpt-3.5-turbo
```

## Configuration

Application configuration is managed in `app/core/config.py`. Update the `Settings` class to add new configuration options.

## Services

### AnonymizerService
Handles data anonymization for sensitive information.

### NLPService
Provides natural language processing capabilities.

### RiskScoringService
Calculates risk scores from observation data.

### NotificationService
Sends notifications via email, push, or SMS.

## Integrations

### FirebaseClient
Integration with Firebase for authentication and data storage.

### N8NClient
Integration with N8N for workflow automation.

### LLMClient
Integration with Large Language Models for AI capabilities.

## Repositories

### FirestoreRepository
Base repository for Firestore database operations.

### UserRepository
User-specific database operations.

## Development

### Adding New Endpoints

1. Create a new file in `app/api/v1/endpoints/`
2. Define routes using FastAPI's `APIRouter`
3. Register router in `app/api/v1/router.py`

### Adding New Services

1. Create service class in `app/services/`
2. Implement business logic methods
3. Use in endpoint handlers

### Adding New Repositories

1. Create repository class in `app/repositories/`
2. Implement data access methods
3. Inject into services

## Testing

Run tests (when added):
```bash
pytest
```

## Production Deployment

1. Set `DEBUG=False` in environment
2. Use proper secret management for credentials
3. Configure CORS appropriately
4. Set up proper logging and monitoring
5. Use environment-specific configuration

## License

All rights reserved
