require 'httparty'
require 'json'
require_relative './roadmap'

class Kele
include HTTParty
include Roadmap
attr_accessor :username, :password, :api_url, :auth_token

  def initialize(username, password)
    @username = username
    @password = password
    @api_url =  "https://www.bloc.io/api/v1/"
    @auth_token = self.class.post(
          @api_url + 'sessions',
          body: {
            "email": username,
            "password": password
          }
        )
  end

  def get_me
response = self.class.get(@api_url + "users/me", headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(@api_url + "mentors/#{mentor_id}/student_availability", headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
  		JSON.parse(response.body)
  	end

    def get_messages(value = 0)
    		if value > 0
          response = self.class.get(@api_url + "message_threads", body: {"page": value}, headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
            JSON.parse(response.body)
        else
          response = self.class.get(@api_url + "message_threads", headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
            JSON.parse(response.body)
    		end
    	end


      def create_message(sender, recipient_id, token, subject, stripped_text)

      		response = self.class.post(@api_url + "messages", body: {
      				        "sender": sender,
                      "recipient_id": recipient_id,
                      "token": token,
                      "subject": subject,
                      "stripped-text": stripped-text
      			},
      			headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
            JSON.parse(response.body)

        end




end
