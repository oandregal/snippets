#! `which python`

# -*- coding: utf-8 -*-

import twitter
import time, datetime
import matplotlib.pyplot as plt

# Vars to customize
var_user = "amaneiro"
var_nro_twitts = 700

var_init_year = 2009
var_init_month = 11
var_init_day = 01

# Twitter
api = twitter.Api()

# View http://code.google.com/p/python-twitter/issues/list?q=getusertimeline
# issue #115 - getusertimeline omits retweets on user's timeline
# issue #116 - getusertimeline ignores count argument greater than 200
statuses = api.GetUserTimeline(var_user,
                               count=var_nro_twitts)

def timeline_to_frecuency(statuses):
    """get a two-axis representacion from twitter statuses"""

    date_array = [datetime.date(var_init_year, var_init_month, var_init_day)]

    while True:
        date_array.append(date_array[-1] + datetime.timedelta(days=1))
        if date_array[-1] == datetime.date.today():
            break

    axis = dict ([(x.isoformat(), 0) for x in date_array]) # fill in dates period to show

    for st in statuses:
        s = time.strftime("%Y-%m-%d", time.gmtime(st.created_at_in_seconds))
        axis[s] = axis[s] + 1
        axis.keys().sort()

    return [axis[item] for item in sorted(axis.keys())]

axis = timeline_to_frecuency(statuses)


# Getting the plot

plt.plot(axis)
frame1 = plt.gca()
frame1.axes.get_xaxis().set_ticks([])
frame1.axes.get_yaxis().set_ticks([])
plt.ylabel("numero de mensajes por dia")
plt.xlabel("rango de fechas: desde 01 Noviembre 2009 hasta 12 Marzo 2010")
plt.show()
