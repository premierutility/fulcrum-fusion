Fulcrum Fusion
==============

An application to integrate [Fulcrum](http://fulcrumapp.com/) and [Fusion Tables](http://www.google.com/drive/apps.html#fusiontables).

This web application can be hosted, configured as a Webhook within Fulcrum,
and used to push changes to your Fulcrum data to Google's Fusion Tables.

Production
----------

### Deploy

Deploy to Heroku using the following steps:

- Clone this repo
- `cd fulcrum-fusion`
- [Install the Heroku Toolbelt](https://toolbelt.heroku.com/)
- `heroku login`
- `heroku create`
  - Look for the application name from this
  - Use it to visit it on the web
- `heroku config:set GOOGLE_USERNAME=<your google username>`
- `heroku config:set GOOGLE_PASSWORD=<your google password>`
- `heroku config:set GOOGLE_API_KEY=<your google api key>`
- `heroku config:set FULCRUM_API_URL='https://api.fulcrumapp.com/api/v2'>`
- `heroku config:set FULCRUM_API_KEY=<your api key for your fulcrum org>`
- `git push heroku master`

For more help check out [how to get started with Node.js](https://devcenter.heroku.com/articles/getting-started-with-nodejs) on Heroku.

Note: Change FULCRUM_API_URL appropriately if you're using something other
than the default production API.

### Webhooks

Go into Fulcrum and add your Heroku application's URL as a webhook.

Development
-----------

### Install

```
bundle install
```

### Setup

```
cp credentials.rb.sample credentials.rb
```

Then fill in the file with your Google username, password, and [API token](https://cloud.google.com/console).

Note: If you have Google's 2-step verification enabled, you will need to
[generate an application-specific password](https://accounts.google.com/b/0/IssuedAuthSubTokens).

Remember to change the API url, since you're likely not hitting production.
Also add your API key for the Fulcrum Organization you're interested in.

### Run

We need to run the Sinatra server:

```
ruby fulcrum_fusion.rb
```

### Port

If the environment variable $PORT is set, the Sinatra app will listen there.
Otherwise, it will default to 4567.

### Webhooks

Add a webhook for your Organization using `localhost:<port_from_above>` as the
URL.

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

