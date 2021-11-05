#!/bin/bash

{
    # start MongoDB
    mongod&

    # start webservice
    python /usr/src/app/serve.py --prod --port 8080

} || {
    echo "Something went wrong..."
    while [ 1 ]
    do
        sleep infinity
    done
}
