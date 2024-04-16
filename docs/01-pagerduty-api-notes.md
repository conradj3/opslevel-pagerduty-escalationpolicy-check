# Page Duty Escalation Policy API Calls

## Relationship API Mapping Between PagerDuty and Opslevel

It was discovered that is there is a 1:1 relationship mapping for the following keys within Opslevel Service and Pager Duty Service.

|Opslevel Service|Pager Duty Service|
|----------------|------------------|
|Service Name|Name|

The Pager Duty Service response contains the associated `escalation_policy` and `team` for the service. The `escalation_policy` contains the `team` and the `team` contains the `id` and `summary` of the team. The `team` is used to determine if the escalation policy is correctly configured. If the `team` is empty, then the escalation policy is not correctly configured.

> ***NOTE:*** We did not map the he escalation policy response of `summary` as it can potentially be different than the service name.

## Retrieve Escalation Policies

The following commands retrieves the escalation policies from PagerDuty. When looking at the json return, each `escalation_policy` should have a team array with at least one team. If the `team array` is empty, then the escalation policy is not correctly configured. We can also discover the services that are associated with the escalation policy at the `service` array.

### Example of a Bash Command to Retrieve Escalation Policies
The following command will retrieve the escalation policies from PagerDuty. The `Authorization` header is required to authenticate the request. The `Accept` header is required to specify the response type. The `Content-Type` header is required to specify the request type.

***Bash Example***
```bash
curl --request GET \
  --url https://api.pagerduty.com/escalation_policies \
  --header 'Accept: application/json' \
  --header 'Authorization: <PD_API_TOKEN>' \
  --header 'Content-Type: application/json'
 ```
> ***NOTE:*** Using curl returns raw `json` and can be piped to `jq` for further processing. This can be streamed to `jq`. For more information on `jq` please visit [GitHub Pages - Jq Manual 1.6](https://jqlang.github.io/jq/manual/v1.6/) or the repository located at [https://stedolan.github.io/jq/](https://stedolan.github.io/jq/) 

```bash

***PowerShell Example***
 ```pwsh
 $headers = @{
    'Accept' = 'application/json'
    'Authorization' = '<PD_API_TOKEN>'
    'Content-Type' = 'application/json'
}

$response = Invoke-RestMethod -Uri 'https://api.pagerduty.com/escalation_policies' -Method Get -Headers $headers
$response
```

> ***NOTE:*** Working with PowerShell returns `TypeName: System.Management.Automation.PSCustomObject` and can be natively piped using | My-Command .  For converting to JSON, use `ConvertTo-Json` 

```powershell 
$response.escalation_policies | ConvertTo-Json
``` 


#### Example of a PagerDuty Payload JSON Return
  ```json
  {
  "escalation_policies": [
    {
      "id": "PVUHL5V",
      "type": "escalation_policy",
      "summary": "Default",
      "self": "https://api.pagerduty.com/escalation_policies/PVUHL5V",
      "html_url": "https://dev-nov4io.pagerduty.com/escalation_policies/PVUHL5V",
      "name": "Default",
      "escalation_rules": [
        {
          "id": "PH95EC3",
          "escalation_delay_in_minutes": 30,
          "targets": [
            {
              "id": "PVC6G48",
              "type": "user_reference",
              "summary": "Conrad Johnson",
              "self": "https://api.pagerduty.com/users/PVC6G48",
              "html_url": "https://dev-nov4io.pagerduty.com/users/PVC6G48"
            }
          ]
        }
      ],
      "services": [
        {
          "id": "PWLBFTP",
          "type": "service_reference",
          "summary": "(Sample) Inventory Tracker",
          "self": "https://api.pagerduty.com/services/PWLBFTP",
          "html_url": "https://dev-nov4io.pagerduty.com/service-directory/PWLBFTP"
        },
        {
          "id": "PTPQEDM",
          "type": "service_reference",
          "summary": "(Sample) Mobile App",
          "self": "https://api.pagerduty.com/services/PTPQEDM",
          "html_url": "https://dev-nov4io.pagerduty.com/service-directory/PTPQEDM"
        }
      ],
      "num_loops": 0,
      "teams": [
        {
          "id": "P66WHU6",
          "type": "team_reference",
          "summary": "(Sample) Order Management Team",
          "self": "https://api.pagerduty.com/teams/P66WHU6",
          "html_url": "https://dev-nov4io.pagerduty.com/teams/P66WHU6"
        }
      ],
      "description": "",
      "on_call_handoff_notifications": "if_has_services",
      "privilege": null
    },
    {
        ...
    },
  ],
  "limit": 25,
  "offset": 0,
  "more": false,
  "total": null
}
```