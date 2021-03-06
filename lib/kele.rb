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

  def get_messages(value = nil)
    if value != nil
      response = self.class.get(@api_url + "message_threads", body: {"page": value}, headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
      JSON.parse(response.body)
    else
      value = 1
      while value != nil
        response = self.class.get(@api_url + "message_threads", body: {"page": value}, headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
        messages = JSON.parse(response.body)
        if messages["items"].empty?
          return "End of messages"
        else
          puts messages
        end
        value += 1
      end
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

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)

    response = self.class.post(@api_url + "checkpoint_submissions", body: {
      "assignment_branch": assignment_branch,
      "assignment_commit_link": assignment_commit_link,
      "checkpoint_id": checkpoint_id,
      "comment": comment,
      "enrollment_id": self.get_me["current_enrollment"]["id"]
    },
    headers: { "authorization" => JSON.parse(@auth_token.body)["auth_token"] })
    JSON.parse(response.body)

  end





end
