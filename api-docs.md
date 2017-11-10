# API Documentation

For API version 1.

All API endpoints accept and reply only JSON. When you have an authorization token from logging in you must use this to access all restricted endpoints. This is done by putting the token in the 'Authorization' header. Also best to set the 'Content-type' header to 'application/json'.


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
