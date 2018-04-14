require 'cuba'
require 'cuba/safe'
require 'cuba/contrib'
require 'mote'
require 'redd/middleware'
require 'dotenv'
Dotenv.load

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers

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
        posts = []
        path = "/user/#{user.me.name}/saved"

        first = user.client.get(path)

        posts << first.body[:data][:children]

        first = user.client.get(path)
        posts << first.body[:data][:children]

        second = user.client.get(path, limit: 1000, after: first.body[:data][:after])
        posts << second.body[:data][:children]

        third = user.client.get(path, limit: 1000, after: second.body[:data][:after])
        posts << third.body[:data][:children]

        third = user.client.get(path, limit: 1000, after: second.body[:data][:after])
        posts << third.body[:data][:children]

        fourth = user.client.get(path, limit: 1000, after: third.body[:data][:after])
        posts << fourth.body[:data][:children]

        fifth = user.client.get(path, limit: 1000, after: fourth.body[:data][:after])
        posts << fifth.body[:data][:children]

        sixth = user.client.get(path, limit: 1000, after: fifth.body[:data][:after])
        posts << sixth.body[:data][:children]

        seventh = user.client.get(path, limit: 1000, after: sixth.body[:data][:after])
        posts << seventh.body[:data][:children]

        eigth = user.client.get(path, limit: 1000, after: seventh.body[:data][:after])
        posts << eigth.body[:data][:children]

        ninth = user.client.get(path, limit: 1000, after: eigth.body[:data][:after])
        posts << ninth.body[:data][:children]

        tenth = user.client.get(path, limit: 1000, after: ninth.body[:data][:after])
        posts << tenth.body[:data][:children]

        eleventh = user.client.get(path, limit: 1000, after: tenth.body[:data][:after])
        posts << eleventh.body[:data][:children]

        twelve = user.client.get(path, limit: 1000, after: eleventh.body[:data][:after])
        posts << twelve.body[:data][:children]

        thirteen = user.client.get(path, limit: 1000, after: twelve.body[:data][:after])
        posts << thirteen.body[:data][:children]

        fourteenth = user.client.get(path, limit: 1000, after: thirteen.body[:data][:after])
        posts << fourteenth.body[:data][:children]

        render('home', user: user, saved_content: posts.flatten.body[:children], helper: self)
      else
        render("sign_in", user: nil)
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
