# OpsLevel PagerDuty Custom Event Integration and Check

This repository contains a sample implementation of a PagerDuty Custom Event Integration and Check for OpsLevel. The integration is implemented with Shell Script and Docker.

## System Requirements

- Linux Terminal / Mac Terminal (For Shell Execution)
    - curl
    - jq
- Docker (For Docker Execution) (Optional)
- OpsLevel CLI (Optional)
- PagerDuty CLI (Optional)
- Taskfile (Optional)

> You can get away with just executing the Dockerfile locally or in computers.

## OpsLevel / PagerDuty Demands

It is important that your Opslevel Service Names match your PagerDuty Service Names. This check is designed to check PagerDuty services by Service Identifiers in the OpsLevel Check.

Please feel free to modify or change coding at your own will.  It is designed to me an example of how to utilize Custom Checks to ensure the standards and quality of operations are met within your company.

### Security API Access

You will need the `OpsLevel Custom Event Integration Secret` and a `PagerDuty API Token`. Please store your secrets safely, we are not responsible for the loss of secrets or system breaches due to bad security practices.  Below is a detailed guide on how to execute this OpsLevel integration.

## Executing from Terminal

1. Gather your `OpsLevel Custom Event Integration Secret` and `PagerDuty API Token` and store them in your environment variables. This is not recommended for production and you should use your secure vaulting solution and tools to store these secrets.

```bash
export PD_API_TOKEN=<PAGER DUTY API TOKEN HERE>
export OPSLEVEL_CE_TOKEN=<OPSLEVEL CUSTOM EVENT SECRET HERE>
```

2. From the root of the repository, execute the following command.

```bash
./send_pagerduty_payload.sh $OPSLEVEL_CE_TOKEN $PD_API_TOKEN
```

**If Taskfile is installed**

```bash
task send-pagerduty-payload
```

3. For convience a `log.txt` file will be created in the root of the repository.  This will contain the output of the script and the response from PagerDuty.

```text
{"timestamp": "2024-03-20 00:33:08", "function": "get_pagerduty_services", "message": "Fetching PagerDuty services..."}
{"timestamp": "2024-03-20 00:33:08", "function": "get_pagerduty_services", "message": "Successfully fetched PagerDuty services. HTTP status: 200, Response: {"services":[{"id":"PWLBFTP","name":"(Sample) Inventory Tracker","description":"Our core tracking tool for managing stock and scheduling procurement.","created_at":"2024-03-15T21:38:25-04:00","updated_at":"2024-03-15T21:38:25-04:00","status":"active","teams":[{"id":"P66WHU6","type":"team_reference","summary":"(Sample) Order Management Team","self":"https://api.pagerduty.com/teams/P66WHU6","html_url":"https://dev-nov4io.pagerduty.com/teams/P66WHU6"}],"alert_creation":"create_alerts_and_incidents","addons":[],"scheduled_actions":[],"support_hours":null,"last_incident_timestamp":null,"escalation_policy":{"id":"PVUHL5V","type":"escalation_policy_reference","summary":"Default","self":"https://api.pagerduty.com/escalation_policies/PVUHL5V","html_url":"https://dev-nov4io.pagerduty.com/escalation_policies/PVUHL5V"},"incident_urgency_rule":{"type":"constant","urgency":"high"},"acknowledgement_timeout":null,"auto_resolve_timeout":null,"alert_grouping":null,"alert_grouping_timeout":null,"alert_grouping_parameters":{"type":null,"config":null},"integrations":[],"response_play":null,"type":"service","summary":"(Sample) Inventory Tracker","self":"https://api.pagerduty.com/services/PWLBFTP","html_url":"https://dev-nov4io.pagerduty.com/service-directory/PWLBFTP"},{"id":"PTPQEDM","name":"(Sample) Mobile App","description":"Our mobile app. Find us in any App Store!","created_at":"2024-03-15T21:38:26-04:00","updated_at":"2024-03-15T21:38:26-04:00","status":"active","teams":[{"id":"P66WHU6","type":"team_reference","summary":"(Sample) Order Management Team","self":"https://api.pagerduty.com/teams/P66WHU6","html_url":"https://dev-nov4io.pagerduty.com/teams/P66WHU6"}],"alert_creation":"create_alerts_and_incidents","addons":[],"scheduled_actions":[],"support_hours":null,"last_incident_timestamp":null,"escalation_policy":{"id":"PVUHL5V","type":"escalation_policy_reference","summary":"Default","self":"https://api.pagerduty.com/escalation_policies/PVUHL5V","html_url":"https://dev-nov4io.pagerduty.com/escalation_policies/PVUHL5V"},"incident_urgency_rule":{"type":"constant","urgency":"high"},"acknowledgement_timeout":null,"auto_resolve_timeout":null,"alert_grouping":null,"alert_grouping_timeout":null,"alert_grouping_parameters":{"type":null,"config":null},"integrations":[],"response_play":null,"type":"service","summary":"(Sample) Mobile App","self":"https://api.pagerduty.com/services/PTPQEDM","html_url":"https://dev-nov4io.pagerduty.com/service-directory/PTPQEDM"},{"id":"P38C5UP","name":"(Sample) Shopping Cart Service","description":"Allows users to add/remove products in their virtual shopping carts prior to placing an order.","created_at":"2024-03-15T23:00:46-04:00","updated_at":"2024-03-15T23:02:03-04:00","status":"active","teams":[],"alert_creation":"create_alerts_and_incidents","addons":[],"scheduled_actions":[],"support_hours":null,"last_incident_timestamp":null,"escalation_policy":{"id":"PU0PX5J","type":"escalation_policy_reference","summary":"Misconfigured","self":"https://api.pagerduty.com/escalation_policies/PU0PX5J","html_url":"https://dev-nov4io.pagerduty.com/escalation_policies/PU0PX5J"},"incident_urgency_rule":{"type":"constant","urgency":"high"},"acknowledgement_timeout":null,"auto_resolve_timeout":null,"alert_grouping":null,"alert_grouping_timeout":null,"alert_grouping_parameters":{"type":null,"config":null},"integrations":[],"response_play":null,"type":"service","summary":"(Sample) Shopping Cart Service","self":"https://api.pagerduty.com/services/P38C5UP","html_url":"https://dev-nov4io.pagerduty.com/service-directory/P38C5UP"},{"id":"PNZGMNA","name":"Test","description":"Test","created_at":"2024-03-19T17:56:54-04:00","updated_at":"2024-03-19T18:01:28-04:00","status":"critical","teams":[{"id":"P66WHU6","type":"team_reference","summary":"(Sample) Order Management Team","self":"https://api.pagerduty.com/teams/P66WHU6","html_url":"https://dev-nov4io.pagerduty.com/teams/P66WHU6"}],"alert_creation":"create_alerts_and_incidents","addons":[],"scheduled_actions":[],"support_hours":null,"last_incident_timestamp":"2024-03-20T03:51:11Z","escalation_policy":{"id":"PVUHL5V","type":"escalation_policy_reference","summary":"Default","self":"https://api.pagerduty.com/escalation_policies/PVUHL5V","html_url":"https://dev-nov4io.pagerduty.com/escalation_policies/PVUHL5V"},"incident_urgency_rule":{"type":"constant","urgency":"high"},"acknowledgement_timeout":null,"auto_resolve_timeout":null,"alert_grouping":"intelligent","alert_grouping_timeout":null,"alert_grouping_parameters":{"type":"intelligent","config":{"time_window":300,"recommended_time_window":300}},"integrations":[],"response_play":null,"type":"service","summary":"Test","self":"https://api.pagerduty.com/services/PNZGMNA","html_url":"https://dev-nov4io.pagerduty.com/service-directory/PNZGMNA"}],"limit":25,"offset":0,"total":null,"more":false}"}
{"timestamp": "2024-03-20 00:33:08", "function": "get_pagerduty_escalation_policies", "message": "Fetching PagerDuty escalation policies..."}
{"timestamp": "2024-03-20 00:33:08", "function": "get_pagerduty_escalation_policies", "message": "Successfully fetched PagerDuty escalation policies. HTTP status: 200, Response: {"escalation_policies":[{"id":"PVUHL5V","type":"escalation_policy","summary":"Default","self":"https://api.pagerduty.com/escalation_policies/PVUHL5V","html_url":"https://dev-nov4io.pagerduty.com/escalation_policies/PVUHL5V","name":"Default","escalation_rules":[{"id":"PH95EC3","escalation_delay_in_minutes":30,"targets":[{"id":"PVC6G48","type":"user_reference","summary":"Conrad Johnson","self":"https://api.pagerduty.com/users/PVC6G48","html_url":"https://dev-nov4io.pagerduty.com/users/PVC6G48"}]}],"services":[{"id":"PWLBFTP","type":"service_reference","summary":"(Sample) Inventory Tracker","self":"https://api.pagerduty.com/services/PWLBFTP","html_url":"https://dev-nov4io.pagerduty.com/service-directory/PWLBFTP"},{"id":"PTPQEDM","type":"service_reference","summary":"(Sample) Mobile App","self":"https://api.pagerduty.com/services/PTPQEDM","html_url":"https://dev-nov4io.pagerduty.com/service-directory/PTPQEDM"},{"id":"PNZGMNA","type":"service_reference","summary":"Test","self":"https://api.pagerduty.com/services/PNZGMNA","html_url":"https://dev-nov4io.pagerduty.com/service-directory/PNZGMNA"}],"num_loops":0,"teams":[{"id":"P66WHU6","type":"team_reference","summary":"(Sample) Order Management Team","self":"https://api.pagerduty.com/teams/P66WHU6","html_url":"https://dev-nov4io.pagerduty.com/teams/P66WHU6"}],"description":"","on_call_handoff_notifications":"if_has_services","privilege":null},{"id":"PU0PX5J","type":"escalation_policy","summary":"Misconfigured","self":"https://api.pagerduty.com/escalation_policies/PU0PX5J","html_url":"https://dev-nov4io.pagerduty.com/escalation_policies/PU0PX5J","name":"Misconfigured","escalation_rules":[{"id":"PIPXY3R","escalation_delay_in_minutes":30,"targets":[{"id":"PKVPZWG","type":"schedule_reference","summary":"(Sample) Shopping Cart Service Oncall","self":"https://api.pagerduty.com/schedules/PKVPZWG","html_url":"https://dev-nov4io.pagerduty.com/schedules/PKVPZWG"}]}],"services":[{"id":"P38C5UP","type":"service_reference","summary":"(Sample) Shopping Cart Service","self":"https://api.pagerduty.com/services/P38C5UP","html_url":"https://dev-nov4io.pagerduty.com/service-directory/P38C5UP"}],"num_loops":0,"teams":[],"description":"","on_call_handoff_notifications":"if_has_services","privilege":null}],"limit":25,"offset":0,"more":false,"total":null}"}
{"timestamp": "2024-03-20 00:33:09", "function": "post_opslevel_customevent_check", "message": "Posting OpsLevel custom event check..."}
{"timestamp": "2024-03-20 00:33:09", "function": "post_opslevel_customevent_check", "message": "Successfully posted OpsLevel custom event check. HTTP status: 202, Response: {"result":"accepted"}"}
```
This `log.txt` is also stored in /app of the container. For convience the log is executed with a cat at the end of `post_opslevel_customevent_check()` is executed in the `main()` function of the script.

## Executing from Docker

1. Perform a Docker Build

```bash
docker build -t opslevel-pagerduty-check:latest .
```

If Taskfile is installed

```bash
task docker-build
```

2. Perform a Docker Run Command

```bash
docker run -d --name opslevel-pd-sender opslevel-pd-sender:latest "$OPSLEVEL_CE_TOKEN" "$PD_API_TOKEN"
```

If Taskfile is installed

```bash
task docker-run
```

For this example we are appending arguargumentsmentts to the Docker `ENTRYPOINT` which enters the container at `/app/send_pagerduty_payload.sh`

Container is designed to run as non root user `opslevel`.


## Executing on Schedule

1. You may use a basic crontab to execute the script on a schedule.  Below is an example of how to execute the script every 5 minutes.

    With your favorite editor (nvim, vim, nano, emcs (hardcore), etc.)

    ```bash
    crontab -e
    ```

    ```vim
    */5 * * * * <path_to_script>/send_pagerduty_payload.sh $OPSLEVEL_CE_TOKEN $PD_API_TOKEN
    ```
    ***View the crontab***!SECTION

    ```bash
    crontab -l
    ```

    > You will most likely want to store secrets in permanent exports for user when the shell launches. (Not Secure if your computer is compromised.) Recommend modification of script to pull secrets during runtime.

2. You may use `Task` on demand

    ```bash
    task send-pagerduty-payload
    ```

    > Ensure your exports are present.

3. You may choose to run this in Kubernetes as a CronJob or in a CI/CD pipeline.
    ### Kubernetes
    Navigate to the `configs/kubernetes` folder and run the following commands

    ```bash
    echo $OPSLEVEL_CE_TOKEN | base64
    echo $PD_API_TOKEN | base64
    ```
    Update the respected secrets at line code 8 and 18 of `opslevel-pd-cronjob.yaml`.

    ```bash
    kubectl create namespace opslevel-cronjobs
    kubectl apply -f opslevel-pagerduty-check-cronjob.yaml
    ```

    Check your deployment
    
    ```bash
    kubectl get cronjobs -n opslevel-cronjobs
    ```

    Run a manual test
    
    ```bash
    kubectl create job -n opslevel-cronjobs --from=cronjob/opslevel-cronjob test-opslevel-cronjob
    ```
    Check the logs
    ```
    kubectl logs job/test-opslevel-cronjob-2 -n opslevel-cronjobs
    ```

    ### Docker

    You may choose to run this in a CI/CD pipeline.  Below is an example of how to execute the script in a pipeline.
    Build and Push to your favorite Container Registery or Build and Run in your favorite CI/CD pipeline.

    Leverage `Task` to build and run.  Store your secrets securely according to your CI/CD Pipeline recommendations.



