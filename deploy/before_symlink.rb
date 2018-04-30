%w(uploads google28d5b131c2b1660c.html).each do |path|
    run "ln -nfs #{config.shared_path}/public/#{path} #{config.release_path}/public/#{path}"
end
