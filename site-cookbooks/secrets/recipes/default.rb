node['secrets'].each do |secret|
  Chef::EncryptedDataBagItem.load('secrets',secret).to_hash.each do |k,v|
    next if k == 'id'
    node.override[secret][k] = v
  end
end
