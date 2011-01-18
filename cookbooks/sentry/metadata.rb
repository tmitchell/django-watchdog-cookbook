maintainer "Taylor Mitchell"
maintainer_email "taylor.mitchell@gmail.com"
license "BSD"
description "Installs a basic django-sentry site"
long_description <<-EOH
Installs a Django site running the django-sentry server.  The architecture
is an Nginx instance which serves up static files and proxies requests to a
gunicorn WSGI server. Django clients can install the django-sentry app to
offload error reporting to Sentry.
EOH

version "0.0.1"

recipe  "nginx", "Installs and configures nginx proxy and static content web server"
recipe  "security", "Installs and configures UFW"
recipe  "watchdog", "Creates and configures site virtualenv and WSGI server"

supports "ubuntu", ">= 10.04"
# probably others, hasn't been tested