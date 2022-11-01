
curl --request POST \
    --url https://api.pagerduty.com/incidents \
    --header 'Accept: application/vnd.pagerduty+json;version=2' \
    --header "Authorization: Token token=$1" \
    --header 'Content-Type: application/json' \
    --header "From: $2" \
    --data '{
            "incident": {
                "type": "incident",
                "title": "Jenkins CI/CD build failure",
                "service": {
                "id": "P7OU3JP",
                "type": "service_reference"
                },
                "priority": {
                "id": "P53ZZH5",
                "type": "priority_reference"
                },
                "urgency": "high",
                "body": {
                "type": "incident_body",
                "details": "$5 build of $6 job was $4. See $3"
                }
            }
}'