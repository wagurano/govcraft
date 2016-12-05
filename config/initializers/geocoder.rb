Geocoder.configure(
  :lookup => :google,
  :use_https => true,
  # to use an API key:
  :api_key => ENV["GOOGLE_API_KEY"],
  # geocoding service request timeout, in seconds (default 3):
  :timeout => 5,
  # set default units to kilometers:
  :units => :km,
  # caching (see below for details):
  :cache => Redis.new
)
