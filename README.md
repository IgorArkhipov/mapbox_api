# README

The goal of this API is to provide an endpoint which takes a GPS latitude and longitude and splits out the names of museums around that location grouped by their postcode as JSON.

Mapbox provides a handy API endpoint for fetching that around a location (you will need to create a free account for getting an API key to use their API). You can find the relevant Mapbox documentation here: https://docs.mapbox.com/api/search/#mapboxplaces.

As an example when doing a request to `/museums?lat=52.494857&lng=13.437641` would generate a response similar to:
```
  {
    "10999": ["Werkbundarchiv – museum of things"],
    "12043": ["Museum im Böhmischen Dorf"],
    "10179": ["Märkisches Museum", "Museum Kindheit und Jugend", "Historischer Hafen Berlin"],
    "12435": ["Archenhold Observatory"]
  }
```

Note that some places in Mapbox may not have postcodes. The decision on how to handle these museums is up to you.

## Requirements

* Ruby version manager (f.e. https://github.com/rbenv/rbenv)

* Ruby version 3.1+

## Installation

* Update Ruby gem manager
  - Run in terminal: `gem update --system`

* Update gems
  - Run in terminal: `gem update`

* Clone the current repository and then run in terminal inside its folder `bundle`

## Usage

* Initial application configuration
  - Before the first use you should also configure your own MapBox API token
  - Delete the provided `config/credentials.yml.enc` file.
  - Then run `rails credentials:edit` and it will create a new Rails master key and encrypted credentials file.
  - Run in terminal: `EDITOR="nano --wait" rails credentials:edit`
  - Add `mapbox_access_token` key to the bottom of the file like this: `mapbox_access_token: sample_api_token`
  - Save the file and quit the editor. The file with credentials will be encrypted.

* Application start
  - Run in terminal: `rails server`
  - Now the application is ready to respond to the incoming requests on http://localhost:3000/

* Application usage
  - List all available museum names grouped by their postal code close to the provided gps location
  - `curl -i 'http://localhost:3000/museums?lat=52.494857&lng=13.437641'`
  - Requirements should be provided with the following schema:
    ```
      lat: decimal between -90.0 and 90.0,
      lng: decimal between -180.0 and 180.0
    ```
  - If for some reason there is no postal code associated with the museum (on the MapBox side), the name of the museum will be added to the predefined key `missing_postcode` in the response JSON.
  - If you provide incorrect latitude and/or longitude, the resultset will be empty
  - The response should be expected in all cases and in case of any error (server side or on the MapBox side) the resultset should just be empty. The assumption here was, that this API could also be used from mobile devices by end users.
