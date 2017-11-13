# API Documentation

For API version 1.

All API endpoints accept and reply only JSON. When you have an authorization token from logging in you must use this to access all restricted endpoints. This is done by putting the token in the 'Authorization' header. Also best to set the 'Content-type' header to 'application/json'.

Parameters: In a `GET` request parameters are passed (properly escaped) on the end of the URL and in a modifying request (`POST`, `PUT` etc) parameters are passed as JSON encoded dictionary/hash structures in the request body.

## Root

    GET /

### Parameters

None

### Returns

A short and mostly useless data structure describing the API. The `api_version` field reports the latest supported API version.

    {
        "title": "Mini Social Network",
        "description": "A small JSON API for communicating amongst users",
        "api_version": "V1"
    }

### Failures

Request cannot fail.

## Sign up

    POST /v1/signup

### Parameters

`email` the email address you wish to use for this service. Not shown to the public and not really used. Not even validated as an email address, but it would be weird to leave out.

`name` your display name that is shown to users who browse the `/v1/users` resource

`password` super safe password

`password_confirmation` same thing again. Not entirely useful for an API.


### Returns

    {
        "message": "User created',
        "auth_token": AUTH_TOKEN
    }

Use of `AUTH_TOKEN` is required to use restricted end points.

### Failures

This call will fail any of the parameters is missing.


## Log in

    POST /v1/login

### Parameters

`email` email address used during sign up

`password` password used during sign up

### Returns

    {
        "auth_token": AUTH_TOKEN
    }

Use of `AUTH_TOKEN` is required to use restricted end points.

### Failures

If the user can't be located or the password is incorrect.

    ###############################################################
    #                                                             #
    #   All paths below this point require a vaalid auth token!   #
    #                                                             #
    ###############################################################

## Conversation Index

    GET /v1/conversations

### Parameters

`offset` Where the server should start from when returning the value. This is pretty much plopped straight into the query (after SQL safe-ifying) so if you give it an offset of gajillion then you're not going to get anything back! Must be greater than zero.

`limit` Same as above with regards to how it is handled. This value is clamped 10 < n < 200. Default value of 100.

### Returns

A list of conversations ordered by the times of their last reply. Also note that if you give out-of-range values for `offset` or `limit` it will silently ignore them. It will reply with the values used for these fields.

    {
        "offset": 0,
        "limit": 100,
        "total_count": TOTAL_COUNT,
        "conversations": [
            {
                "id": CONVERSATION_ID,
                "created_by_user_id": USER_ID,
                "state": CONVERSATION_STATE,
                "created_at": CONVERSATION_CREATED_AT,
                "updated_at": CONVERSATION_LAST_REPLY_AT
            }
        ]
    }

`total_count` will show you how many conversations that user has without limit

### Failures

This request should never fail.

## Create Conversation

    POST /v1/conversations

### Parameters

`other_user_id` The integer of the other user you wish to initiate a conversation with. The ID must not be your own and you cannot have two conversations with the same person at the same time.

### Returns

    {
      "id": CONVERSATION_ID,
      "other_user_id": OTHER_USER_ID
    }

`id` is the requestable ID for this conversation.

### Failures

`404` not found: if the other user cannot be found.
`422` invalid: if you have already got a conversation with this user.
`422` invalid: if you are trying to have a conversation with yourself

## See Conversation

    POST /v1/conversations/:id

### Parameters

### Returns

### Failures


## Reply to Conversation

    PUT /v1/conversations/:id

### Parameters

### Returns

### Failures


## End Conversation

    DELETE /v1/conversations/:id

### Parameters

### Returns

### Failures


## Users Index

    GET /v1/users

### Parameters

### Returns

### Failures


## See User Profile

    GET /v1/users/:id

### Parameters

### Returns

### Failures


