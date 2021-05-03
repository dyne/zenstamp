#!/usr/bin/env bash 

# echo "${red}red text ${green}green text${reset}"
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

echo "${reset} "
echo "   "
echo "Make sure you have node 12, the version you have is" 
echo "   "
node -v
echo "   "
echo "   "
# Installing restroom
npx degit dyne/restroom-template zenstamp --force



# setup docker
cd ./zenstamp

touch .env
echo 'ZENCODE_DIR=./zencode
CUSTOM_404_MESSAGE=nothing to see here
HTTP_PORT=3300
HTTPS_PORT=3301' > .env


# Adding the exported files
echo "   "
echo "Adding exported contracts from apiroom"

# echo Creating directory "./zencode/dyneorg/"
# mkdir -p "./zencode/dyneorg"

echo Creating file "zenstamp.zen":
echo "# The Rule unknown ignore is required when using a restroom-mw statement
Rule unknown ignore 

# we'll need to create a keypair to produce an ECDSA signature later
Scenario 'ecdh': Create the keypair
Given that I am known as 'timestampServer'
Given I have my 'keypair'

# Those are restroom-mw statements: define the endpoints
Given that I have an endpoint named 'timeServer' 

# We need those object to store the output of the endpoints
Given I have a 'number' named 'timestamp'


# Those are restroom-mw statements: connect to endpoints and store their output into Zenroom's objects
Given I connect to 'timeServer' and save the output into 'timestamp'


When I create the signature of 'timestamp' 
When I rename the 'signature' to 'timestamp.signature' 


When I create the copy of 'public key' from dictionary 'keypair'
When I rename the 'copy' to 'public key'

# Printing the output
Then print the 'timestamp'
Then print the 'public key'
Then print the 'timestamp.signature'
"> ./zencode/zenstamp.zen



echo Creating file "local-zenstamp.zen":
echo "# The Rule unknown ignore is required when using a restroom-mw statement
Rule unknown ignore 

# we'll need to create a keypair to produce an ECDSA signature later
Scenario 'ecdh': Create the keypair
Given that I am known as 'timestampServer'
Given I have my 'keypair'

# Those are restroom-mw statements: define the endpoints
Given that I have an endpoint named 'localtimeServer' 

# We need those object to store the output of the endpoints
Given I have a 'number' named 'timestamp'


# Those are restroom-mw statements: connect to endpoints and store their output into Zenroom's objects
Given I connect to 'localtimeServer' and save the output into 'timestamp'


When I create the signature of 'timestamp' 
When I rename the 'signature' to 'timestamp.signature' 


When I create the copy of 'public key' from dictionary 'keypair'
When I rename the 'copy' to 'public key'

# Printing the output
Then print the 'timestamp'
Then print the 'public key'
Then print the 'timestamp.signature'
"> ./zencode/local-zenstamp.zen

echo " "
echo "The following scripts gets a fresh keypair, twice, from a generator on apiroom"
echo "Along with the keypair, it gets the endpoint of the epoch server on apiroom and the endpoint of the local epoch server."
echo " "

echo Creating file "zenstamp.keys":
# Old version: hardcoded keypair
# echo '{"timeServer":"http://apiroom.net:3312","timestampServer":{"keypair":{"private_key":"E0NzAVdOfJ6QpLYEmQMRO3OpuKqwYRZkgZzVfaexZhY=","public_key":"BLQkv2nWS9Vr+dFsS5KLCf7Fcm0G0rJt4tOt0ym/RGC6gsFhpRc0ZXlEx/rB1Uifp2tMVy9rTqlhxqUhv6ZKKIQ="}}}' > ./zencode/zenstamp.keys

curl -X POST "https://apiroom.net/api/dyneorg/Dyne-timestampServer-keypair-generator" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"data\":{},\"keys\":{}}" > ./zencode/zenstamp.keys

curl -X POST "https://apiroom.net/api/dyneorg/Dyne-timestampServer-keypair-generator" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"data\":{},\"keys\":{}}" > ./zencode/local-zenstamp.keys


# Finished exported files
echo "   "
echo "Finished exporting contracts from apiroom"
echo "   "

# Debbing
echo "   "
echo "Printing the .env file:"
echo "   "
cat .env

# cd restroom-mw
yarn 
yarn remove @restroom-mw/ui
yarn add @restroom-mw/core@next @restroom-mw/db@next @restroom-mw/http@next @restroom-mw/sawroom@next @restroom-mw/utils@next 
yarn add zenroom@next


# # # Debloating # # #
echo " -------------------------- "
echo " ---- Begin debloating ---- "
echo " -------------------------- "



echo 'import express from "express";
import chalk from "chalk";
import bodyParser from "body-parser";
import { ZENCODE_DIR, HTTP_PORT, HTTPS_PORT, HOST } from "./config";
import zencode from "@restroom-mw/core";
/* import ui from "@restroom-mw/ui"; */
import db from "@restroom-mw/db";
import httpmw from "@restroom-mw/http";
import sawroom from "@restroom-mw/sawroom";
import http from "http";
import https from "https";
import fs from "fs";

var privateKey = fs.readFileSync("ssl/selfsigned.key", "utf8");
var certificate = fs.readFileSync("ssl/selfsigned.crt", "utf8");
var credentials = { key: privateKey, cert: certificate };

const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(require("morgan")("dev"));
app.set("json spaces", 2);

app.use(db);
app.use(sawroom);
app.use(httpmw);
app.use("/api/*", zencode);

app.get("/timestamp", (req, res) => {
  	res.contentType("text/plain")
	res.send(`${ (Math.round(Date.now() / 1000)).toString()}`)
})


const httpServer = http.createServer(app);
httpServer.listen(HTTP_PORT, HOST, () => {
  console.log(
    "Restroom started on " + chalk`{bold.blue http://0.0.0.0:${HTTP_PORT}}`
  );
});

const httpsServer = https.createServer(credentials, app);
httpsServer.listen(HTTPS_PORT, HOST, () => {
  console.log(
    "Restroom started on " + chalk`{bold.blue https://0.0.0.0:${HTTPS_PORT}} \n`
  );
  console.log(`the ZENCODE directory is: ${chalk.magenta.underline(ZENCODE_DIR)} \n`);
  console.log( "To open Swagger go to: " + chalk`{bold.blue http://0.0.0.0:${HTTP_PORT}/docs}`);
});' > ./src/app.js


cd zencode 
rm  confkeys.conf confkeys.keys confkeys.zen random.zen keypair_username.zen keypair_username.keys
rm -rf restroom-mw/
rm -rf misc/

echo " -------------------------- "
echo " ---- End debloating ---- "
echo " -------------------------- "


# instructions 
echo "   "
echo "${reset} "
echo "To launch zenstamp, type:"
echo "${reset} "
echo "${red}cd zenstamp"
echo "${reset} "
echo "${red}yarn start"
echo "${reset} "
echo "${red}Then go to: "
echo "${reset} "
echo "${red}Then go to:${blue} http://0.0.0.0:3300/api/zenstamp ${red}to get the time from the apiroom server"
echo "${reset} "
echo "${red}or go to:${blue} http://0.0.0.0:3300/api/local-zenstamp ${red}to use the time from this server"
echo "${reset} "

