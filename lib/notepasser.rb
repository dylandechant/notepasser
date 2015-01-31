require "notepasser/version"
require "notepasser/init_db"
require "camping"
require "pry"

Camping.goes :Notepasser

module Notepasser



end

module Notepasser::Models

    class User < ActiveRecord::Base
      has_many :messages
    end

    class Message < ActiveRecord::Base
      belongs_to :users
    end

    class Block < ActiveRecord::Base
      has_many :users
    end
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

  def authenticate(user, sent_password)
    if user[:password] == sent_password
      return true
    else
      return false
    end
  end

  class UserController < R '/user'

    # CREATE A NEW USER
    def post
      @input.symbolize_keys!
      new_user = User.new
      [:name, :password].each do |x|
        new_user[x] = @input[x]
      end
      new_user.save
      @status = 201
      {:message => "New user created",
       :code => 201}
    end

    # GET ALL USERS
    def get
      all_users = {}
      all_users = User.all.to_json
      "#{all_users}"
    end

  end

  #Individual Users
  class UsersController < R '/user/(\d+)'

    def get(id)
      @input.symbolize_keys!
      db = User.where(id).to_json
      "#{db}"
    end

    def delete(id)
      binding.pry # if record doesn't exist you get this: ActiveRecord::RecordNotFound
      begin
        delete = User.destroy(id)
        "User #{id} deleted"
      rescue ActiveRecord::RecordNotFound
        @status = 404
      end
    end
  end

  class MessageController < R '/message'

    def post
      @input.symbolize_keys!
      if authenticate(User.where(id: @input[:sender_id]).take, @input[:password])  #AUTHENTICATE PASSWORD
        new_message = Message.new
        [:recipient_id, :title, :content, :sender_id].each do |x|
          new_message[x] = @input[x]
        end
        new_message.save
        @status = 201
        "Created "
      else
        @status = 401
        {:message => "Incorrect password",
          :code => 401}
          "Incorrect Password"
      end
      # binding.pry
    end

    def get
       message = Message.all.to_json
       "#{message}"
     end
  end

  class IndividualMessage < R '/message/(\d+)'
    def get(user_id)
      # binding.pry
      @input.symbolize_keys!
      if authenticate(User.where(id: user_id).take, @input[:password])
        message = Message.where(recipient_id: user_id)
        message.each do |x|
          x.update(read: true)
          x.save
        end
        "#{message.to_json}"
      else
          @status = 401
          {:message => "Incorrect password",
          :code => 401}.to_json
      end
    end
  end
end
