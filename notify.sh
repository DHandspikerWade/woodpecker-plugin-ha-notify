#!/usr/bin/env bash

success_message="The $CI_REPO pipeline #$CI_PIPELINE_NUMBER has completed successfully."
failed_message="The $CI_REPO pipeline #$CI_PIPELINE_NUMBER has failed."
pipeline_status="$CI_PIPELINE_STATUS"

if [ -n "$PLUGIN_STATUS" ]; then
    # Allow users to override status. Needed to support WP > 3 due to always returning "running"
    pipeline_status="$PLUGIN_STATUS"
fi

if [ -n "$PLUGIN_SUCCESS_MESSAGE" ]; then
    success_message="$PLUGIN_SUCCESS_MESSAGE"
fi

if [ -n "$PLUGIN_FAILURE_MESSAGE" ]; then
    failed_message="$PLUGIN_FAILURE_MESSAGE"
fi

if [ -z "$PLUGIN_HOST" ]; then
    echo 'ERROR: "host" is a required setting.' 
    exit 1
fi

if [ -z "$PLUGIN_NOTIFY_ID" ]; then
    echo 'ERROR: "notify-id" is a required setting.' 
    exit 1
fi

if [ -z "$PLUGIN_TOKEN" ]; then
    echo 'ERROR: "notify-id" is a required setting.' 
    exit 1
fi

if [ "${pipeline_status}" == "success" ]; then
    title="✔️ Successful $CI_SYSTEM_NAME Pipeline"
    message="$success_message"
else
    title="❌ Failed $CI_SYSTEM_NAME Pipeline"
    message="$failed_message"
fi

body="$(echo '{}' | jq -r \
    --arg MESSAGE "$message" \
    --arg TITLE "$title" \
    --arg URL "$CI_PIPELINE_URL" \
    '.title = $TITLE | .message = $MESSAGE | .data.url = $URL | .data.clickAction = $URL'
)"

curl -X POST \
-H "Authorization: Bearer $PLUGIN_TOKEN" \
-H "Content-Type: application/json" \
-d "$body" \
"https://$PLUGIN_HOST/api/services/notify/$PLUGIN_NOTIFY_ID"

echo ""

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error while sending notification."
    exit 1
fi

echo "Notification sent successfully."