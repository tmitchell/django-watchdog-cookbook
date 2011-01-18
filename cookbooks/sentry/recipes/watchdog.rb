directory "/home/fido/sites/" do
    owner "fido"
    group "fido"
    mode 0775
end

virtualenv "/home/fido/sites/watchdog" do
    owner "fido"
    group "fido"
    mode 0775
end

directory "/home/fido/sites/watchdog/run" do
    owner "fido"
    group "fido"
    mode 0775
end

git "/home/fido/sites/watchdog/checkouts/watchdog" do
    repository "git@github.com:tmitchell/django-watchdog.git"
    reference "HEAD"
    user "fido"
    group "fido"
    action :sync
end

script "Install Requirements" do
    interpreter "bash"
    user "fido"
    group "fido"
    code <<-EOH
    /home/fido/sites/watchdog/bin/pip install -r /home/fido/sites/watchdog/checkouts/watchdog/requirements.txt
    EOH
end

script "Migrate Database" do
    interpreter "bash"
    user "fido"
    group "fido"
    code <<-EOH
    source /home/fido/sites/watchdog/bin/activate
    /home/fido/sites/watchdog/checkouts/watchdog/manage.py syncdb --settings=settings.sqlite --noinput
    /home/fido/sites/watchdog/checkouts/watchdog/manage.py migrate --settings=settings.sqlite --noinput
    EOH
end

script "Collect Static Files" do
    interpreter "bash"
    user "fido"
    group "fido"
    code <<-EOH
    source /home/fido/sites/watchdog/bin/activate
    /home/fido/sites/watchdog/checkouts/watchdog/manage.py build_static --settings=settings.sqlite --noinput
    EOH
end

cookbook_file "/etc/init/watchdog-gunicorn.conf" do
    source "gunicorn.conf"
    owner "root"
    group "root"
    mode 0644
end

service "watchdog-gunicorn" do
    provider Chef::Provider::Service::Upstart
    enabled true
    running true
    supports :restart => true, :reload => true, :status => true
    action [:enable, :start]
end
