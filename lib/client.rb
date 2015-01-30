require "httparty"
require "pry"


class Notepassr
  include HTTParty
  base_uri 'http://10.0.0.21:3301'

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
    options = {:recipient_id => recipient_id, :title => title, :content => message, :sender_id => sender_id}
    resp = self.class.post("/message", :body => options)
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
  puts "99) Exit"
  exit = gets.chomp.to_i
  case exit
  when 1
    client.create_user
  when 2
    client.send_message
  when 4
    client.get_all_users
  end
end
end