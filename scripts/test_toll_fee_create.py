#!/usr/bin/env python2
from sys import argv
import json
import requests
from time import gmtime, strftime, sleep

class TollBooth:
    def __init__(self, config):
        # Read config as json format
        data = None
        with open(config, 'r') as f:
            data = json.loads(f.read())
        self.config = data['config']
        self.data = data['data']
        # print "Tollconfig: " + str(self.config)
        # print "Tolldata: " + str(len(self.data) )
        self.data_iter = 0
        self.headers = {'Content-type': 'application/json', 'Authorization': 'Token token=' + self.config['api_key']}
        
    
    def post_next_request(self):
        if self.data_iter == len(self.data):
            return False
        else:
            tmp_data = dict( self.data[self.data_iter] )
            tmp_data['timestamp'] = strftime("%Y-%m-%d %H:%M:%S", gmtime())  
            print "Sending: " + str(json.dumps(tmp_data) )      
            response = requests.post(self.config['url'], data=json.dumps(tmp_data), headers=self.headers )
            print "Receiving: " + str(response.content)
            self.data_iter += 1
            return True
 
if __name__ == '__main__':
  print(argv[1])
  toll_booth = TollBooth(argv[1])
  toll_booth.post_next_request()
  sleep(2)
  toll_booth.post_next_request()
