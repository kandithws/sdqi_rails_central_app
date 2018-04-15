#!/usr/bin/env python2
from sys import argv
import json
import requests
import os

def get_event_data(event_id):
    url_omise = 'https://{0}:@api.omise.co/events/{1}'.format(os.environ['OMISE_SECRET_KEY'], event_id)
    res = requests.get(url_omise)
    print "Retrived Data From Omise: "
    print res.content
    data=json.loads(res.content)
    url_rails = 'http://localhost:3000/omise_callback'
    res_rails = requests.post(url_rails, json=data)
    print "Rails Response: "
    print res_rails.content

if __name__ == '__main__':
    if len(argv) < 2:
        print "Usage: trigger_omise_event.py event_id"
    get_event_data(argv[1])
