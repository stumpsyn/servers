# Swiped from https://gist.github.com/geewiz/1550976

# remount /dev/shm
execute "remount_shm" do
  action :nothing
  command "mount -o remount /dev/shm"
end

# set noexec for /dev/shm
bash "shm_noexec" do
  user "root"
  cwd "/etc"
  code <<-EOH
  sed -i.bak -e '/\/dev\/shm/d' /etc/fstab
  echo "none /dev/shm tmpfs nodev,nosuid,noexec 0 0" >>/etc/fstab
  EOH
  not_if 'grep -q -e "/dev/shm.*noexec" /etc/fstab'
  notifies :run, "execute[remount_shm]"
end
