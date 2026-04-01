import os
import redis

redis_client = redis.Redis(
    host=os.environ["REDIS_HOST"],
    port=6379,
    decode_responses=True
)