#!/bin/python3
"""List users that do not follow you back on Letterboxd."""

from time import sleep
from typing import List
from bs4 import BeautifulSoup
import requests

LETTERBOXD_USER = "pablos123"
FOLLOWING_URL = f"https://letterboxd.com/{LETTERBOXD_USER}/following"
FOLLOWERS_URL = f"https://letterboxd.com/{LETTERBOXD_USER}/followers"


def get_followers() -> set:
    page_num = 0
    followers = []
    while True:
        page_followers = get_page_followers(page_num)
        if not page_followers:
            break
        followers.extend(page_followers)
        page_num += 1
        sleep(1)
    return set(followers)


def get_following() -> set:
    page_num = 0
    following = []
    while True:
        page_following = get_page_following(page_num)
        if not page_following:
            break
        following.extend(page_following)
        page_num += 1
        sleep(1)
    return set(following)


def get_page_followers(page_num: int) -> List[str]:
    followers_url = get_followers_url(page_num)
    response = request(followers_url)
    return get_usernames(response.text)


def get_page_following(page_num: int) -> List[str]:
    following_url = get_following_url(page_num)
    response = request(following_url)
    return get_usernames(response.text)


def get_followers_url(page_num: int) -> str:
    if page_num == 0:
        return FOLLOWERS_URL
    return f"{FOLLOWERS_URL}/page/{page_num}/"


def get_following_url(page_num: int) -> str:
    if page_num == 0:
        return FOLLOWING_URL
    return f"{FOLLOWING_URL}/page/{page_num}/"


def get_usernames(html: str) -> List[str]:
    soup = BeautifulSoup(html, "html.parser")
    person_summaries = soup.find_all("div", class_="person-summary")
    return [person_summary.a["href"] for person_summary in person_summaries]


def request(url: str) -> requests.Response:
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
    except (
        requests.exceptions.HTTPError,
        requests.exceptions.Timeout,
        requests.exceptions.TooManyRedirects,
        requests.exceptions.RequestException,
    ) as e:
        raise e

    return response


if __name__ == "__main__":
    followers = get_followers()
    following = get_following()
    unfollowers = following.difference(followers)
    print("These users do not follow you back")
    for username in unfollowers:
        print(f"https://letterboxd.com/{username}/")
