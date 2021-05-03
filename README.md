# Zenstamp
A Self contained server, producing an ECDSA signed unix timestamp  

# How to use:

Just download the **zenstamp.sh** installer and run it. The server will create two endpoints:
 - ***http://0.0.0.0:3300/api/local-zenstamp*** returning a signed timestamp, where time is read from the local server 
 - ***http://0.0.0.0:3300/api/zenstamp*** returning a signed timestamp, where time is read from the *apiroom.net* server
 
 In both the endpoints, the ECDSA signatures are produced locally, using a unique keypair that is produced via an API during the installation.
 
 ## What you get: 
 
 The endpoints will produce something like this: 
 
```json
 {
  "public_key": "BMyBq3hjJUgFDRRtClhq4Ejw14nBdHfTcKgzml43INfNEBrGfEP3uKqSc/DELzQS7m2SroH7umbFgHlziqu41d8=",
  "timestamp": 1620059840,
  "timestamp.signature": {
    "r": "oAr0Qsa/LGh/D1WSwY7QwotrJZudi/x/0ydwtPtZNWE=",
    "s": "ZwVS8AJt2jXXnN0wi0db54sliaaUqbKJBxCb6Qhtztw="
  }
} 
```

## Requirements: 
 - GNU/Linux
 - Node 12

## Acknowledgement

*Zenstamp* uses [Restroom-mw](https://dyne.github.io/restroom-mw/#/) and [Zenroom](https://zenroom.org/), and is copyrght of Dyne.org
 
 
