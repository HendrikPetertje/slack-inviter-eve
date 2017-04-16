# Slack Community Inviter/Landing Page

A simple application, to help bootstrap your slack EVE community.

![login](http://i.imgur.com/IFnzkqS.jpg)

![create](http://i.imgur.com/0Fq0AX3.jpg)

# Setup

1. Signup for a slack team on their homepage(https://slack.com/)
  - Go through the entire process.
  - visit https://api.slack.com/custom-integrations/legacy-tokens and get a token! (easy way to turn off invitations is by revoking the token!)
2. Register a new OATH app on https://developers.eveonline.com/applications
3. Publish this app, add your configurations. The required variables can be
   found in .env.example

4. Submit your heroku url to https://keep-awake.herokuapp.com/ - add `_ping` for optimal performance (eg `http://example.herokuapp.com/_ping` )
5. add the free heroku addon "Heroku Redis" to your app.
6. Activate the sidekiq worker in the resources tab on your heroku dashboard.

## Development

clone
bundle
rename .env file

`mv .env.example .env`

edit variables

```bash

SIDEKIQ_USERNAME=user
SIDEKIQ_PASSWORD=password
SLACK_TOKEN=yourslackapitoken
SLACK_SUBDOMAIN=yourslacksubdomain
TITLE="Title of your slack community?"
TOP_SUBTITLE="Come make some friends, share links, meet a lunch buddy."
BACKGROUND_IMAGE="http://i.imgur.com/vDADTWP.jpg"

```

start the server

`rails s`


### Prerequisites

* PostgreSQL: `brew install postgresql`
* Redis: `brew install redis`

### Required Configuration

Configuration items are stored in environment variables.

```bash

SIDEKIQ_USERNAME=user
SIDEKIQ_PASSWORD=password
SLACK_TOKEN=yourslackapitoken (an API token for an administrator of the organization from: https://api.slack.com/web)
SLACK_SUBDOMAIN= e.g., tech404 for tech404.slack.com (signup for slack)
TITLE="Title of your slack community?"
TOP_SUBTITLE="Come make some friends, share links, meet a lunch buddy."
BACKGROUND_IMAGE="http://i.imgur.com/vDADTWP.jpg"

```
