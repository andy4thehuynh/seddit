require 'cuba'
require 'cuba/safe'

Cuba.plugin Cuba::Safe

Cuba.define do
  on get do
    on root do
      res.write 'hi andy'
    end
  end
end
