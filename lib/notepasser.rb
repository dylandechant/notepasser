require "notepasser/version"
require "notepasser/init_db"
require "camping"
require "pry"

Camping.goes :Notepasser

module Notepasser

    class User < ActiveRecord::Base
      has_many :messages
    end

    class Message < ActiveRecord::Base
    end

end

module Notepasser::Models
end




module Notepasser::Controllers

  #hmmmm, how should this work based on a post id or a user
  # => user regex: ([^/]+)
  # => id regex: (\d+)

  class Intro < R '/'
    def get
      "<html><head><title>welcome to terrible messages</title></head><body><h1>Welcome</h1></body>"
    end
  end

  class UserController < R '/user/new'

    def get
      User.create(name: "test")
      "trying to create a new user, eh?"
    end

  end

  class UsersController < R '/user/(\d+)'

    def get(id)
       db = User.find(id)
      "#{db.name}"
    end
  end

  # class UserController < R '/user/new'

  #   def get
  #     Notepasser::User.create_user
  #   end

  # end

end
