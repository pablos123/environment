#!/bin/python3
"""List users that do not follow you back on Instagram."""

import os
import sys
from pathlib import Path

from instagrapi import Client

cl = Client()
cl.delay_range = [1, 3]

home = os.getenv("HOME")
blacklist_path = Path(f"{home}/.instagram_unfollowers_blacklist")
blacklist = []
if blacklist_path.is_file():
    with blacklist_path.open() as fh:
        for line in fh:
            blacklist.append(line.strip())


sessionid = sys.argv[1]
if not sessionid:
    print("Pass the session ID!. Get it with: F12 -> Application -> Storage -> Cookies")
    exit(1)
if not cl.login_by_sessionid(sessionid):
    exit(1)

print("Obtaining following...")
following_usershort = cl.user_following(str(cl.user_id)).values()
print("Obtaining followers...")
followers_usershort = cl.user_followers(str(cl.user_id)).values()

print("Processing following...")
following = set()
for usershort in following_usershort:
    username = str(usershort.username)
    if username in blacklist:
        continue
    following.add(username)

print("Processing followers...")
followers = set()
for usershort in followers_usershort:
    username = str(usershort.username)
    if username in blacklist:
        continue
    followers.add(username)

unfollowers = following.difference(followers)
print("These users do not follow you back")
for username in unfollowers:
    print(f"https://www.instagram.com/{username}/")
