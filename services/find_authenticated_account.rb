require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedAccount
  def self.call(account:, password:)
    response = HTTP.post("#{ENV['API_HOST']}/accounts/authenticate",
                         json: {account: account, password: password})
    response.code == 200 ? response.parse : nil
  end
end
