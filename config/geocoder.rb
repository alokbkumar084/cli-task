Geocoder.configure(
  use_https: true,
  http_headers: { 'User-Agent' => 'Mozilla/5.0' },
  lookup: :nominatim,
  timeout: 5
)