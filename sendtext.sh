#!/bin/bash

help_()
{
        echo "usage: SendText <+recipents SMS number> <body of text>"
        echo "example:"
        echo "SendText \"+12345678901\" \"This is the body of the SMS message\""
}


if [[ -z "$1" ]];then
        help_
        echo "Enter phone number."
        exit 1
fi
if [[ -z "$2" ]]; then
        help_
        echo "Enter message body."
        exit 1
fi

sms_to=$1
body_=$2
# Insert your information below.  
myNumber="+nnnnnnnnn"
account_sid="yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
auth_token="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"


resp=$(curl -X POST -F "Body=$body_" \
    -F "From=$myNumber" -F "To={$sms_to}" \
    "https://api.twilio.com/2010-04-01/Accounts/${account_sid}/Messages" \
    -u "${account_sid}:${auth_token}" 2>/dev/null)

echo $resp > resp
status=$(xml2 < resp | grep Status | awk 'BEGIN { FS = "/|=" } ; {print $5}')
rm -f resp

if [[ $status == "queued" ]]; then
        echo "Success!"
        exit 0
else
        echo "Error"
        echo $resp
        exit 1
fi
