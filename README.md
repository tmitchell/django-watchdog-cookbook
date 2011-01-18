# django-watchog-cookbook #


This is the companion project for [django-watchdog][dw].  It contains cookbooks and recipes for [Chef][chef] to install and configure a working [django-sentry][sentry] server site.

[django-watchdog-cookbook][dwc] has its roots in Eric Holscher's excellent [chef-django-example][cje] code and tutorial.  So if you've run through that (and I recommend doing so), this will feel very familiar to you.

## Installation ##

First clone the repository

    git clone https://github.com/tmitchell/django-watchdog-cookbook.git
    cd django-watchdog-cookbook

Now edit the following files:

*solo.rb*

Add the username (required) and password (optional) for an account under your control on the target system.  This account must have sudo rights.

*nodes/your.hostname.json*

Copy the example `127.0.0.1.json` to a file representing the right ip/hostname for the target system.  

Edit the following values:

 * `users:fido:keys` - Extend this array with the contents of your id_rsa.pub.  Any keys here will get inserted into the `.ssh/authorized_keys` for the user `fido`.

 * `all_servers` - Edit this to reflect the hostname of your target system, as well as its internal and external IP's.  This will be used to update the `/etc/hosts` file.

Switch to a virtualenv: `mkvirtualenv watchdog && workon watchdog`

Install [LittleChef][littlechef]: `pip install littlechef`

LittleChef is a wrapper over fabric and chef-solo that gets you bootstrapped and deals with the various configurations you might encounter.  If you're new to Chef, it's a quick way to get running quickly.  If you're already using and comfortable with chef-solo, you should be able to use the cookbook and recipes without much extra work.

Bootstrap your target system: `cook node:your.hostname deploy_chef`

After this process completes, your system will be set up with chef-solo.  Now we need to get it running the application stack.

Configure your target system `cook node:your.hostname configure`

After a while, this should return back and you should be able to navigate to http://your.hostname and see your django-sentry instance running!

Note that the default settings `sentry/settings/sqlite.py` just uses a Sqlite database.  You may need to edit the configuration to reflect your desired endstate (and optionally run a `manage.py createsuperuser` if you want to be able to log in)

## Manual Configuration ##

There is just a bit more additional configuration you will need to perform to get this django-sentry server hooked up to your Django app servers.

**On the Sentry Clients:**

 * Install django-sentry
 * Add `sentry.client` to `INSTALLED_APPS`
 * Generate a unique `SENTRY_KEY` and add it to your settings
 * Ensure `DEBUG = False` and `TEMPLATE_DEBUG = True`
 
**On the Sentry Server:**

  * Make sure your email configuration is set in your settings
  * Add the same `SENTRY_KEY` to your settings
  * Add the tuple `SENTRY_ADMINS` as described in the [django-sentry documentation][dsd]
  * Empty out `ADMINS` and `MANAGERS` so they don't get emailed

## Todo ##

(In no particular order)

 * Seed the settings_local.py using nodes during setup
 * Better handle changes to configuration so we automatically bump the gunicorn server.  Eric Holscher pointed out a chicken-egg (dab0100da3b5e4073ab5d0744b1dee0f58d823ed) problem with services and the files they need.
 * Handle the createsuperuser step automatically
 * Handle the SENTRY_KEY creation and configuration automatically

[chef]: http://opscode.com/chef
[dw]: https://github.com/tmitchell/django-watchdog
[dwc]: https://github.com/tmitchell/django-watchdog-cookbook
[lc]: https://github.com/tobami/littlechef
[sentry]: https://github.com/dcramer/django-sentry
[cje]: https://github.com/ericholscher/chef-django-example
[ce]: https://github.com/ericholscher/chef-django-example/commit/
[dsd]: http://justcramer.com/django-sentry/