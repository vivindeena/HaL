#!/bin/bash

function get_status() {
    curl -s "http://phc.prontonetworks.com/cgi-bin/authlogin" | grep "logged" >/dev/null
    return $?
}

function print_status() {
    now=$(date +"%T")
    get_status
    if [[ $? -eq 0 ]]; then
        echo "[$now] Logged in [✔]"
        return 0
    else
        echo "[$now] Logged out [✘]"
        return -1
    fi
}
function logout() {
    curl -s "http://phc.prontonetworks.com/cgi-bin/authlogout" >/dev/null
    return 0
}

function login() {
    local username="20BCI0005"
    local password="5566"

    get_status
    if [[ $? -eq 0 ]]; then logout; fi

    curl -s 'http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://captive.apple.com/hotspot-detect.html' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' \
        -H 'Accept-Language: en-GB,en;q=0.8' \
        -H 'Cache-Control: no-cache' \
        -H 'Connection: keep-alive' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Origin: http://phc.prontonetworks.com' \
        -H 'Pragma: no-cache' \
        -H 'Referer: http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://captive.apple.com/hotspot-detect.html' \
        -H 'Sec-GPC: 1' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36' \
        --data-raw "userId=$username&password=$password&serviceName=ProntoAuthentication&Submit22=Login" \
        --compressed \
        --insecure | grep "logged" >>/dev/null

    local successful=$?

    if [[ $successful -eq 0 ]]; then
        echo "Successfully logged in with $username"
    else
        echo "Not Successful"
    fi
    return $successful
}



while :; do
    ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F: '/ SSID/{print $2}')
    if [[ $ssid == *"VIT"* ]]; then
        print_status
        if [ $? -eq 0 ]; then
            sleep 10
        else
            login
            sleep 1
        fi
    fi
    
done
