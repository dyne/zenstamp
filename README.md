# Zenstamp
## A Self contained server, producing an ECDSA signed unix timestamp  

# How to use:

Just download the **zenstmp.sh** installer, and run it. The server will create two endpoints 
 - ***http://0.0.0.0:3300/api/local-zenstamp*** returning a signed timestamp, where time is read from the local server
 - ***http://0.0.0.0:3300/api/zenstamp*** returning a signed timestamp, where time is read from the *apiroom.net* server
 
 ## What you get: 
 
 The server will produce something like this: 
 

 {
  "public_key": "BMyBq3hjJUgFDRRtClhq4Ejw14nBdHfTcKgzml43INfNEBrGfEP3uKqSc/DELzQS7m2SroH7umbFgHlziqu41d8=",
  "timestamp": 1620059840,
  "timestamp.signature": {
    "r": "oAr0Qsa/LGh/D1WSwY7QwotrJZudi/x/0ydwtPtZNWE=",
    "s": "ZwVS8AJt2jXXnN0wi0db54sliaaUqbKJBxCb6Qhtztw="
  }
}

## Requirements: 
 - GNU/Linux
 - Node 12
 
 
