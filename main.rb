require 'cuba'
require 'cuba/safe'
require 'cuba/contrib'
require 'mote'
require 'redd/middleware'
require 'dotenv'
Dotenv.load

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Mote

Cuba.use Rack::Static, urls: %w[/js /css /img], root: File.expand_path("./public", __dir__)
Cuba.use Rack::Session::Cookie, :secret => '__a_very_long_string__'

Cuba.use Redd::Middleware,
  user_agent:   'Redd:Username App:v1.0.0 (by /u/seddit_development)',
  client_id:    ENV["CLIENT_ID"],
  secret:       ENV["SECRET_KEY"],
  redirect_uri: 'http://127.0.0.1:9393/redirect',
  scope:        %w(identity save),
  via:          '/login'


Cuba.define do
  on get do
    on root do
      render("index")
    end

    on 'redirect' do
      render('home', req: req)
    end
  end
end
