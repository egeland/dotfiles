#!/usr/bin/env python3

import pypd

pypd.api_key = "API KEY HERE"

pd_teams = [t for t in pypd.Team.find() if t['name'][:3] == "AMP"]
pd_users = pypd.User.find()

teams = {}

for t in pd_teams:
    teams[t["name"]] = []
    for u in pd_users:
        for ut in u['teams']:
            if ut['id'] == t.id:
                teams[t["name"]].append("{} <{}>".format(u['name'], u['email']))

for t in teams:
    print("{}:".format(t))
    for m in teams[t]:
        if t == "AMP-PlatformEngineering" or m not in teams["AMP-PlatformEngineering"]: # PE gets included in everything we get escalated to...
            print("  - {}".format(m))
    print("")
