---
description: StackState v6.0
---

# Troubleshooting notifications

When a notification channel fails to send out notifications the notification overview will show an error status. To inspect the errors:

1. Click on the notification
2. The top of the page shows a banner with a summary of the errors
3. Scroll down to the channels, click on the "error" link for the affected channel(s) to open the error details.


## Common errors

### Slack

Slack errors usually contain an error code:

* `token_revoked`, `token_expired` or `missing_scope`: These error codes all indicate a problem with the authorization of StackState to post messages to Slack. To solve these recreate the channel to re-authorize StackState with Slack such that all required permissions are granted.
* For other error codes see [Slack API error codes](https://api.slack.com/automation/cli/errors).

### HTTP

Most channels, specifically the webhook, expect a HTTP response with status 200 OK. Other responses are considered an error. HTTP errors contain a, usually short, message and the status code that was received instead of 200 OK.

Verify that any configured URLs and tokens are correct and, in case of the webhook, that POST requests are handled properly and return a 200 OK response.

### Other

In case the error is of type "Other" StackState is most likely not able to even connect to the external service or webhook. Verify that URL is correct, can be resolved and can be accessed by StackState.
