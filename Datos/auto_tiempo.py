""" eso guión de python3 entre las fechas en el
'tiempo_trabajo.csv automaticamente """

import datetime
from dateutil import rrule
alpha=datetime.date(2010, 1, 1) # change to accept input
omega=datetime.date(2020, 2, 1) # change to accept input
dates=rrule.rruleset() # create an rrule.rruleset instance
dates.rrule(rrule.rrule(rrule.DAILY, dtstart=alpha, until=omega))
# this set is INCLUSIVE of alpha and omega
dates.exrule(rrule.rrule(rrule.DAILY,
        byweekday=(rrule.SA, rrule.SU), dtstart=alpha))
# here's where we exclude the weekend dates
#print (list(dates)) # there's probably a faster way to handle this

f = open('tiempo_trabajo.csv','w')

for d in dates:
    string = str(d.day).zfill(2) + '-'
    string += str(d.month).zfill(2) + '-'
    string += str(d.year)
    string += ';9:00;18:00\n'
    f.write(string)
f.close()
