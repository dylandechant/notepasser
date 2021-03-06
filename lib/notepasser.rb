require "notepasser/version"
require "notepasser/init_db"
require "camping"
require "pry"

Camping.goes :Notepasser

module Notepasser
end

module Notepasser::Models

    class User < ActiveRecord::Base
      validates :name, length: { minimum: 3 }
      has_many :messages
    end

    class Message < ActiveRecord::Base
      validates :title, presence: true
      validates :content, presence: true, length: { minimum: 4 }
      validates :recipient_id, presence: true
      validates :sender_id, presence: true
      belongs_to :users
    end

    class Block < ActiveRecord::Base
      has_many :users
    end
end

module Notepasser::Controllers

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

  def blocked?(sender, recipient_id)
    if sender == nil  #the sender hasn't been blocked at all
      return false
    end
    blocks = Notepasser::Models::Block.all
    blocks.each do |x|
      if sender.blocked == x.blocked_by
        return true
        break
      end
    end
  end

  class UserController < R '/user'
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

    def get
      all_users = {}
      all_users = User.all.to_json
      "#{all_users}"
    end
  end

  class UsersController < R '/user/(\d+)'

    def get(id)
      @input.symbolize_keys!
      db = User.where(id).to_json
      "#{db}"
    end

    def delete(id)
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
        if !blocked?(Block.where(blocked: @input[:sender_id]).take, @input[:recipient_id]) #IS THE USER BLOCKED?
          new_message = Message.new
          [:recipient_id, :title, :content, :sender_id].each do |x|
            new_message[x] = @input[x]
          end
          new_message.save
          @status = 201
          "Created "
        else
          @status = 403
          {:message => "You are blocked by the recipient",
            :code => 403}.to_json
        end
      else
        @status = 401
        {:message => "Incorrect password",
          :code => 401}
          "Incorrect Password"
      end
    end

    def get
       message = Message.all.to_json
       "#{message}"
     end
  end

  class IndividualMessage < R '/message/(\d+)'
    def get(user_id)
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

  class BlockUsers < R '/block/(\d+)'
    
    def post(id)
      @input.symbolize_keys
      if authenticate(User.where(id: @input[:users_id]).take, @input[:password])
        new_block = Block.create
        new_block[:blocked_by] = @input[:users_id]
        new_block[:blocked] = id
        new_block.save
        @status = 201
        {:message => "User blocked",
          :code => 201}.to_json
      else
        @status = 401
        {:message => "Incorrect Password",
          :code => 401}.to_json
      end
    end
  end
  
  class TrackMessages < R '/messages/sent_by/(\d+)'
    
    def get(id)
      @input.symbolize_keys!
      if authenticate(User.where(id: id).take, @input[:password])
        mess = Message.where(sender_id: id)
        mess.to_json
      else
        @status = 401
        {:message => "Incorrect Password",
         :code => 401}.to_json
      end
    end
  end

  class MarkRead < R '/messages/(\d+)/read'
    
    def get(message_id)
      if authenticate(User.where(id: @input[:users_id]).take, @input[:password])
        message = Message.where(id: message_id)
        message.update(read: true)
        message.save
        "#{message.to_json}"
      else
        @status = 401
        {:message => "Incorrect Password",
          :code => 401}.to_json
      end
    end
  end
end










