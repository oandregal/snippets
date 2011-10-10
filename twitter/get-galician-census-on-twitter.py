#!/usr/bin/python

# -*- coding: utf-8 -*-

import twitter
import re

# Twitter
api = twitter.Api()

def isTag(tag):
    if tag[0] == "#":
        return True
    else:
        return False

def becomeTag(tag):
    if(isTag(tag)):
        return tag
    else:
        tag = "#" + tag
        return tag

def getUsersUsingTag(tag, users_to_retrieve):

    tag = becomeTag(tag)

    statuses = []
    users = []
    for page_index in range(1, 4):
        statuses = api.GetSearch(tag, per_page=users_to_retrieve, page=page_index)
        for st in statuses:
            if(not users.__contains__(st.user.screen_name)):
                users.append(st.user.screen_name)

    return users

def getCitizens(tag, users_to_retrieve):
    """Build a _Galician census_ on twitter taking into account:
       1. users who have used the tag #galega.

       [TODO] Include users who:
       2. set their location _inside_: Galicia.
       3. use galician language (check how twitter return it)."""

    citizens = []

    for user in getUsersUsingTag(tag, users_to_retrieve):
        citizens.append(user)

    return citizens

def printCitizens(tag, users_to_retrieve):

    for cit in getCitizens(tag, users_to_retrieve):
        print cit

tag_to_search = "#galega"
users_to_retrieve = 100
print "Building census...."
printCitizens(tag_to_search, users_to_retrieve)
print "Done!"
