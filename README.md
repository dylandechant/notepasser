# Notepasser

Pass notes to your friends with HTTP and ruby!

## Usage

Run `bundle exec camping -s webrick -h YOUR_IP_ADDRESS lib/notepasser.rb`
to get the server running. Have your friends write a client to send you
messages with HTTParty. Add a short two to three line decription to this
file's "API Calls" section whenever you add support for an API call.

The description should include the HTTP method to use,
the route, and any parameters and what they do.

## API Calls

### Users

####Create new user:

`POST /user`

:name - string - the username or name of the user 

:password - string - user password    


####Get all users
`GET /user`

####Get single user
`GET /user/:id`

####Delete a user
`DELETE /user/:id`

:id - integer - users unique identifier

:password - string - cleartext password of the user

### Messages
####Send a message

`POST /messages`

:recipient_id - integer - id of user who is to receive

:sender_id - integer - id of the user sending

:password - string - cleartext password of sending user

:title - string - title of the message

:content - string - body of the message

####Get a user's messages
`GET /messages/:users_id`

:users_id - integer - the users id

:password - string - cleartext password of the user

####See a users sent messages
`GET /messages/sent_by/:users_id`

:users_id - integer - the users id

:password - string - cleartext password of the user

####Mark a message as read
`GET /messages/:message_id/read`

:users_id - integer - users unique id

:password - string - cleartext password of the user

:message_id - integer - unique number identifying the message

### Blocking users
####Block a user

`POST /block/:blocked`

:users_id - integer - the user who is blocking's id

:password - string - cleartext password of the user

:blocked - integer - the unique id of the person whom you are blocking