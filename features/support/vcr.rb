VCR.config do |c|
  c.cassette_library_dir = "#{Rails.root}/features/cassettes"
  c.stub_with :webmock
  c.default_cassette_options = {
    :record => :new_episodes,
    :match_requests_on => [:method, :uri, :body]
  }
end
