import os
import logging

from fastapi import FastAPI
from pydantic import BaseSettings
import redis

import json_log_formatter


class Settings(BaseSettings):
    app_name: str = "Awesome API"
    app_log_level: str = os.environ.get('APP_LOGLEVEL', 'INFO').upper()
    port: int = os.environ.get("UVICORN_PORT", 8000)
    redis_host: str = os.environ.get("REDIS_HOST", "redis-db")
    redis_port: int = os.environ.get("REDIS_PORT", 6380)

settings = Settings()

logger = logging.getLogger(__name__)
stdout = logging.StreamHandler()
stdout.setLevel(level=settings.app_log_level)
formatter = json_log_formatter.VerboseJSONFormatter()
stdout.setFormatter(formatter)
logger.addHandler(stdout)

app = FastAPI()
redis_db = redis.Redis(host=settings.redis_host, port=settings.redis_port)

@app.get("/")
async def welcomeToKodeKloud():
    try:
      redis_db.incr('visitorCount')
      visitCount = str(redis_db.get('visitorCount'), 'utf-8')
    except redis.exceptions.ConnectionError as e:
        logger.critical(e)
        return {"message": "Welcome to KODEKLOUD!"}
    else:
        logger.debug(visitCount)
        return {"message": "Welcome to KODEKLOUD!", "request_count": visitCount}

@app.get("/info")
async def info():
    return {
        "app_name": settings.app_name,
        "app_log_level": settings.app_log_level,
        "app_port": settings.port,
        "redis_host": settings.redis_host,
        "redis_port": settings.redis_port,
    }
