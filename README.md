Fulcrum Fusion
==============

An application to integrate [Fulcrum](http://fulcrumapp.com/) and [Fusion Tables](http://www.google.com/drive/apps.html#fusiontables).

This web application can be hosted, configured as a Webhook within Fulcrum,
and used to push changes to your Fulcrum data to Google's Fusion Tables.

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

We need to run the Sinatra server:

```
ruby fulcrum_fusion.rb
```

### Webhooks

The Sinatra app runs on port `3002` by default. Add a webhook for your
Organization using this as the URL.

### Seeing it in Action

This assumes everything is hooked up properly.

* Create a form. Shortly, you'll see a Fusion Table in your [Google
Drive](https://drive.google.com/#query?view=2&filter=tables) for this form.
* Create a record. Then you should see this as a record in that Fusion Table
created above.
* Do an import in Fulcrum. Shortly you'll see the form and all the data in the
appropriate Fusion Table.

####Notes:

- Each new from will be created as a new Fusion Table.
- A table will be created called `FulcrumApp_{FormName}_WithId_{FormId}`. The
  name is constricted by the library used to work with Fusion Tables.
- All the column names in the application are columns from the API. There
  aren't any dynamic ones yet.

### Limitations

Here's how things currently work:

- Due to limits with the Fusion Tables API, there maybe some failures.  The
  code will retry the same request until it succeeds. This could exceed the 20
  second timeout for the webhooks, but it's unlikely.

