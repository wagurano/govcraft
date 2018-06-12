namespace :migrate do
  task 'move_image_speakers_to_agent' => :environment do
    bucket_name = ENV['S3_BUCKET']
    credentials = Aws::Credentials.new(ENV['S3_ACCESS_KEY'], ENV['S3_SECRET_KEY'])
    destination = 'uploads/agents/image'
    # s3_client = Aws::S3::Client.new(region: ENV['S3_REGION'], credentials: credentials)

    s3 = Aws::S3::Resource.new(region: ENV['S3_REGION'], credentials:credentials)
    source = 'uploads/speaker/image'
    bucket = s3.bucket(bucket_name)
    bucket.objects(prefix: source).each do |source_object|
      source_key = source_object.key
      destination_key = source_object.key.dup.sub(source, "")
      new_object = bucket.object("uploads/agent/image#{destination_key}")
      source_object.copy_to new_object, acl: "public-read"
      puts "uploads/agent/image#{destination_key}"
    end
  end
end
