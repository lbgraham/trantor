# Login to the Trantor API

require 'net/http'
require 'CGI'

class TrantorClient

   def login username, password
      uri = URI.parse "https://trantor.artlogic.com"
      params = { user_name: username, password: password, login: 'Login' }
      uri.query = URI.encode_www_form params
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      # Grab the TrantorVisit part of the cookie
      trantorCookie = response['Set-Cookie']
   end

# -- PROJECTS ----------------------------------------------
   def GetProject projectId, trantorCookie
      GetRequest "/api/projects/#{projectId}", trantorCookie
   end

# -- MILESTONES --------------------------------------------
   def GetMilestones projectId, trantorCookie
      GetRequest "/api/projects/#{projectId}/milestones", trantorCookie
   end

private

   def GetRequest api, trantorCookie
      uri = URI.parse("https://trantor.artlogic.com")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(api)
      request['Cookie'] = trantorCookie
      response = http.request(request)
      p response.body
      trantorCookie = response.response['set-cookie']
   end

end