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
