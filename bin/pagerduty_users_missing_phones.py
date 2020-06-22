#!/usr/bin/env python3

import pypd

pypd.api_key = "API KEY HERE"

pd_users = pypd.User.find()

for u in pd_users:
    has_phone = False
    for cm in u["contact_methods"]:
        if not has_phone or cm["type"] in ["phone_contact_method_reference", "sms_contact_method_reference"]:
            phone = u.get_contact_method(cm["id"])
            if len(phone["address"]) > 0:
                has_phone = True
                print("{} <{}>".format(u["name"], phone["address"]))
    # if not has_phone:
    #     print("{} <{}>".format(u["name"], u["email"]))
