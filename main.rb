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
  scope:        %w(identity history),
  via:          '/login'


Cuba.define do
  on get do
    on root do
      user = req.env['redd.session']

      if user
        path = "/user/#{user.me.name}/saved"
        saved_content = user.client.get(path)

        render('home', user: user, saved_content: saved_content)
      else
        render("sign_in")
      end
    end

    on 'redirect' do
      user = req.env['redd.session']
      if user
        res.redirect '/'
      end
    end

    on 'logout' do
      req.env['redd.session'] = nil
      res.redirect '/'
    end
  end
end
