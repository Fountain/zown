VCR.config do |c|
  c.cassette_library_dir = "#{Rails.root}/features/cassettes"
  c.stub_with :webmock
  c.default_cassette_options = { :record => :once }
end
