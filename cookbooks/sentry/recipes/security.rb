package "ufw" do
    :upgrade
end

service "ufw" do
    enabled true
    running true
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

bash "Enable UFW" do
    user "root"
    code <<-EOH
    ufw enable
    ufw allow from 10.0.0.0/8
    ufw allow from 99.34.35.224/29
    ufw allow from 74.1.129.208/29
    ufw allow from 98.189.193.0/27
    EOH
end
