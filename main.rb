require 'cuba'
require 'cuba/safe'
require 'cuba/contrib'
require 'mote'

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Mote

Cuba.use Rack::Session::Cookie, :secret => '__a_very_long_string__'

Cuba.define do
  on get do
    on root do
      render("index")
    end
  end
end
