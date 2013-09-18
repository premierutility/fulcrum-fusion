Fulcrum Fusion
==============

An application to integrate [Fulcrum](http://fulcrumapp.com/) and [Fusion Tables](http://www.google.com/drive/apps.html#fusiontables).

This web application that can be hosted, configured as a Webhook within
Fulcrum, and used to push changes to your Fulcrum data to Google's Fusion
Tables.

Production
----------

Coming soon...

Development
-----------

### Install

```
bundle install
```

### Setup

```
cp credentials.yml.sample credentials.yml
```

Then fill in the file with your Google username, password, and [API token](https://cloud.google.com/console).

Note: If you have Google's 2-step verification enabled, you will need to
[generate an application-specific password](https://accounts.google.com/b/0/IssuedAuthSubTokens).

### Run

```
ruby fulcrum_fusion.rb
```

### Webhooks

The Sinatra app runs on port `3002` by default. Add a webhook for your Org
using this as the URL.

### Seeing it in Action

Use Fulcrum to create a record in your app. Assuming everything is hooked up
properly, you'll see the record in a Fusion Table soon.

