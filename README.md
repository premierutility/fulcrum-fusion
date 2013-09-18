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

### Limitations

Here's how things currently work:

- Creates a new table called 'Fulcrum_Fusion' in Fusion Tables, if it doesn't
  already exist.
- All records received over webhooks (for all apps) will be shown in this one table.
- Add a new record to see it created in the Fusion Table.
- Updating/Deleting this record will affect that record in the Fusion Table.
- Updating/Deleting a record that doesn't already exist in the Fusion Table
  likely blows up.
- This only works as advertised for one-off webhooks. Webhooks coming in batches will not work correctly.
- Handling the record data is done on another thread to keep the incoming webhook
  request from timing out.

