#!/usr/bin/env python3
"""
web cache and tracker
"""
import redis
import requests

def get_page(url: str) -> str:
    # Connect to Redis
    redis_client = redis.Redis()

    # Check if the page content is already cached
    cached_content = redis_client.get(url)
    if cached_content:
        return cached_content.decode("utf-8")

    # Fetch the page content using requests
    response = requests.get(url)
    if response.status_code == 200:
        page_content = response.text

        # Cache the page content with an expiration time of 10 seconds
        redis_client.setex(url, 10, page_content)

        # Track the number of times the URL was accessed
        redis_client.incr(f"count:{url}")

        return page_content

    return ""

if __name__ == "__main__":
    url = "http://slowwly.robertomurray.co.uk/delay/10000/url/https://www.example.com"
    content = get_page(url)
    print(content)

