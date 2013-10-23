Fulcrum Fusion
==============

An application to integrate [Fulcrum](http://fulcrumapp.com/) and
[Fusion Tables](http://www.google.com/drive/apps.html#fusiontables).

This application can be deployed and then set as a Webhook within Fulcrum.
Once this is done, Fulcrum will push changes to your data to this application,
which will send them to Google's Fusion Tables.

Configure
-----------

First off, let's gather the configuration we'll need.

Below, we'll talk about these configuration variables:

- `PORT`
- `GOOGLE_USERNAME`
- `GOOGLE_PASSWORD`
- `GOOGLE_API_KEY`
- `FULCRUM_API_URL`
- `FULCRUM_API_KEY`

What follows is how to determine what values you'll use for each configuration
variable.

### PORT

This is the port the Sinatra application will listen to.

If deploying to heroku, don't worry about this.

If you're running locally, be safe and use the value of `4567`.  If you don't
specify it, and you have a $PORT environment variable already defined, the app
will use that and could cause issues.  If you don't define it, and it's not
set in your environment, it'll default to `4567`.

### GOOGLE_USERNAME

You'll need a Google account to interact with the Fusion Tables. This value is
simply your Google account's username. For instance, if your Gmail address is
`walter.white@gmail.com`, your username is `walter.white`.

### GOOGLE_PASSWORD

This is the password for your Google account.

If you have Google's 2-step verification enabled, you will need to
[generate an application-specific password](https://accounts.google.com/b/0/IssuedAuthSubTokens).
Then use this application-specific password for this value, instead of your
regular password. Using your regular password will cause issues since you
can't perform the 2nd step of the verification.

If running locally, the config file is ignored from the git repository by
default, so the password isn't going to be shared with everyone.

### GOOGLE_API_KEY

You need to use the google account above to set up an
[API token](https://cloud.google.com/console). This token is tied to your
google account and will be used for interacting with your Google Fusion
Tables.

### FULCRUM_API_URL

You'll likely want to use `https://web.fulcrumapp.com/api/v2` for this value.

If you're using something other than the default production API, however, be
sure to change this value appropriately. For instance, when you're doing local
development or testing outside of production.

### FULCRUM_API_KEY

This is the API key belonging to the member of the organization you'll be
using for this account. Remember, your plan needs to
[support webhooks](TODO: Link) and the member needs to have the
[proper permission](TODO: Link).

Remember, this API key is specific to the organization, member and
`FULCRUM_API_URL` specified above.

Get It Running
---------------

### Production

Deploy to Heroku using the following steps:

#### Create
- Clone this repo
- `cd fulcrum-fusion`
- [Install the Heroku Toolbelt](https://toolbelt.heroku.com/)
- `heroku login`
- `heroku create`
  - Look for the application name from this
  - Remember this name/URL for later

#### Configure

Use the configuration values from above to fill in these values:

- `heroku config:set GOOGLE_USERNAME=<value from above>`
- `heroku config:set GOOGLE_PASSWORD=<value from above>`
- `heroku config:set GOOGLE_API_KEY=<value from above>`
- `heroku config:set FULCRUM_API_URL='<value from above>`
- `heroku config:set FULCRUM_API_KEY=<value from above>`

#### Deploy
- `git push heroku master`

For more help check out
[how to get started with Node.js](https://devcenter.heroku.com/articles/getting-started-with-nodejs)
on Heroku.

#### Use

Go into Fulcrum and add your Heroku application's URL as a webhook.

### Development

#### Install

```
bundle install
```

#### Configure

```
cp config.rb.sample config.rb
```

Use the configuration values from above to fill in `config.rb`.

Remember to change the API URL, since you're likely not hitting production.
Also add your API key for the Fulcrum Organization you're interested in.

#### Run

We need to run the Sinatra server:

```
ruby fulcrum_fusion.rb
```

#### Use

Go into Fulcrum and add `localhost:<port_from_above>` as the URL.

See it in Action
-------------------

This assumes everything is hooked up properly.

- Create a form. Shortly, you'll see a Fusion Table in your [Google
Drive](https://drive.google.com/#query?view=2&filter=tables) for this form.
- Create a record. Then you should see this as a record in that Fusion Table
created above.
- Do an import in Fulcrum. Shortly you'll see the form and all the data in the
appropriate Fusion Table.

Limitations
-----------

Here's how things currently work:

- Each new from will be created as a new Fusion Table.
- A table will be created called `FulcrumApp_<FormName>_WithId_<FormId>`. The
  name is constricted by the library used to work with Fusion Tables.
- Due to limits with the Fusion Tables API, there maybe some failures.  The
  code will retry the same request until it succeeds or it reaches a maximum
  of 10 retries. This could exceed the 20 second timeout for the webhooks, but
  it's unlikely.

