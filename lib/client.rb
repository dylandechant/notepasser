require "httparty"
require "pry"


class Notepassr
  include HTTParty
  base_uri 'http://192.168.1.8:3301'

  # def initialize(user = 'apitestfun', pass = 'ironyard1')
  #   @auth = {:username => user, :password => pass}
  # end

  #takes a username and returns a list of their followers usernames via the [followers call][followers]
  # def get_followers(input = 'redline6561')
  #   resp = self.class.get("/users/#{input}/followers")
  #   data = JSON.parse(resp.body)
  #   users_info = []
  #   data.each do |x|
  #     users_info << get_user_info(x['login'])
  #   end
  # end

  def create_user
    print "Enter username: "
    username = gets.chomp
    print "Enter password: "
    password = gets.chomp
    options = {:name => username, :password => password}
    resp = self.class.post("/user", :body => options)
    binding.pry
  end

  def send_message
    print "ID of person you are sending it to: "
    recipient_id = gets.chomp
    print "Message title: "
    title = gets.chomp
    print "Body of message: "
    message = gets.chomp
    print "What is your id: "
    sender_id = gets.chomp
    print "What is your password: "
    password = gets.chomp
    options = {:recipient_id => recipient_id, :title => title, :content => message, :sender_id => sender_id, :password => password}
    resp = self.class.post("/message", :body => options)
    binding.pry
  end

  def get_all_users
    resp = self.class.get("/user")
    users = JSON.parse(resp.body)
    users.each do |x|
      puts x
    end
    gets
    #binding.pry
  end

  def get_single_user
    print "What user would you like to see: "
    user = gets.chomp.to_i
    resp = self.class.get("/user/#{user}")
    user_profile = JSON.parse(resp)
    puts user_profile
    gets
  end

  def delete_user
    print "What user would you like to delete: "
    d_user = gets.chomp.to_i
    resp = self.class.delete("/user/#{d_user}")
    binding.pry
  end

  def get_all_messages
    system 'clear'
    resp = self.class.get("/message")
    message = JSON.parse(resp.body)
    puts message
    gets
  end

exit = 0
system 'clear'
puts "Notepassr Client"
client = Notepassr.new
while exit != 99
  system 'clear'
  puts "1) Create a new user"
  puts "2) Send message"
  puts "3) Get 1 user"
  puts "4) Get all users"
  puts "5) Delete a user"
  puts "6) Get all messages"
  puts "99) Exit"
  exit = gets.chomp.to_i
  case exit
  when 1
    client.create_user
  when 2
    client.send_message
  when 3
    client.get_single_user
  when 4
    client.get_all_users
  when 5
    client.delete_user
  when 6
    client.get_all_messages
  end
end
end