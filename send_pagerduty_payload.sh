#!/bin/sh
# Overview: This script fetches a list of services and escalation policies from the PagerDuty API and updates the services with the corresponding escalation policies and teams.
# Dependencies: jq, curl

# SECTION: Usage
# Function to print usage
usage() {
    echo "Usage: $0 OPSLEVEL_CE_TOKEN PD_API_TOKEN"
    echo "Provide the OPSLEVEL_CE_Token and the PD_API_TOKEN in order."
    exit 1
}

# Check if at least two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Error: You must provide exactly two arguments."
    usage
fi

# SECTION: Main
main(){
    # Configuration
    opslevel_ce_token="$1"
    pd_api_token="$2"
    local function_name="main"

    # PagerDuty API configuration
    pd_auth_header="Authorization: Token token=$pd_api_token"
    pd_contenttype_header="Content-Type: application/json"
    pd_accept_header="Accept: application/json"


    # Get PagerDuty services
    pagerduty_services=$(get_pagerduty_services)

    # Get PagerDuty escalation policies
    pagerduty_escalation_policies=$(get_pagerduty_escalation_policies)

    # Transform the PagerDuty services to include the teams from the escalation policies by match the escalation policy ID from each service
    opslevel_custom_event_payload=$(update_pagerduty_services "$pagerduty_services" "$pagerduty_escalation_policies")
    
    # Post OpsLevel custom event check
    echo "$opslevel_custom_event_payload" | post_opslevel_customevent_check "$message"

    # Dump logs before container exists
    cat ./log.txt
}

# SECTION: Functions
# Function: log
log() {
    local function_name=$1
    local log_message=$2
    echo "{\"timestamp\": \"$(date '+%Y-%m-%d %H:%M:%S')\", \"function\": \"$function_name\", \"message\": \"$log_message\"}" >> ./log.txt 2>&1
}


# FUNCTION: get_pagerduty_services
get_pagerduty_services() {
    local function_name="get_pagerduty_services"
    log "$function_name" "Fetching PagerDuty services..."

    local response_file=$(mktemp)
    local http_status=$(curl -s -o "$response_file" -w '%{http_code}' -f --request GET \
        --header "$pd_accept_header" --header "$pd_auth_header" --header "$pd_contenttype_header" \
        --url "https://api.pagerduty.com/services" || echo "failed")

    local response_body=$(cat "$response_file")
    rm "$response_file"

    if [ "$http_status" = "failed" ]; then
        log "$function_name" "Failed to make request due to curl error."
        return 1
    elif [ "$http_status" = 200 ]; then
        log "$function_name" "Successfully fetched PagerDuty services. HTTP status: $http_status, Response: $response_body"
        echo "$response_body"
    else
        log "$function_name" "Error fetching PagerDuty services. HTTP status: $http_status"
        return 1
    fi
}


# Function: get_pagerduty_escalation_policies
get_pagerduty_escalation_policies() {
    local function_name="get_pagerduty_escalation_policies"
    log "$function_name" "Fetching PagerDuty escalation policies..."

    local response_file=$(mktemp)
    local http_status=$(curl -s -o "$response_file" -w '%{http_code}' -f --request GET \
        --header "$pd_accept_header" --header "$pd_auth_header" --header "$pd_contenttype_header" \
        --url "https://api.pagerduty.com/escalation_policies" || echo "failed")

    local response_body=$(cat "$response_file")
    rm "$response_file"

    if [ "$http_status" = "failed" ]; then
        log "$function_name" "Failed to make request due to curl error."
        return 1
    elif [ "$http_status" = 200 ]; then
        log "$function_name" "Successfully fetched PagerDuty escalation policies. HTTP status: $http_status, Response: $response_body"
        echo $response_body
    else
        log "$function_name" "Error fetching PagerDuty escalation policies. HTTP status: $http_status"
        return 1
    fi
}

# Function: update_pagerduty_services
update_pagerduty_services() {
    services="$1"
    escalation_policies="$2"

    # Process each service and update it inline by matching its EscalationPolicy ID and extracting the teams if they exist
    updated_services=$(echo "$services" | jq -c '.services[]? | select(. != null)' | while IFS= read -r service; do
        servicename=$(echo "$service" | jq -r '.name')
        escalationPolicyId=$(echo "$service" | jq -r '.escalation_policy.id')
        
        escalation_policy=$(echo "$escalation_policies" | jq --arg escalationPolicyId "$escalationPolicyId" '.escalation_policies[]? | select(.id==$escalationPolicyId)')
        
        service_found=$(echo "$escalation_policy" | jq --arg serviceName "$servicename" '[.services[].summary == $serviceName] | any')
        if [ "$service_found" = "true" ]; then
            teams=$(echo "$escalation_policy" | jq '.teams')
            echo "$service" | jq --argjson teams "$teams" '.escalation_policy.teams = $teams'
        else
            echo "$service" | jq '.escalation_policy.teams = []'
        fi
    done | jq -s '{messages: .}') # Wrap the output in an array and then encapsulate it within an object under the "messages" key

    echo "$updated_services"
}

# Function to post OpsLevel custom event check
post_opslevel_customevent_check() {
    local function_name="post_opslevel_customevent_check"
    log "$function_name" "Posting OpsLevel custom event check..."

    response_file=$(mktemp)
    # See https://curl.se/docs/manpage.html for explaination of argument and variable flags
    http_status=$(curl -s -o "$response_file" -w '%{http_code}' --fail --request POST \
        --url "https://app.opslevel.com/integrations/custom_event/$opslevel_ce_token" \
        --header 'Content-Type: application/json' \
        --data-binary @- || echo "failed")

    response_body=$(cat "$response_file")
    rm "$response_file"

    if [ "$http_status" = "failed" ]; then
        log "$function_name" "Failed to make request due to curl error."
        return 1
    elif [ "$http_status" -ge 200 ] && [ "$http_status" -lt 300 ]; then
        success_message="Successfully posted OpsLevel custom event check."
        [ "$http_status" -eq 202 ]
        log "$function_name" "$success_message HTTP status: $http_status, Response: $response_body"
    else
        log "$function_name" "Error posting OpsLevel custom event check. HTTP status: $http_status"
        return 1
    fi
}

# SECTION: Main Invocation
main "$@"


