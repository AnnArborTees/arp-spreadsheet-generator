require 'active_resource'

module MockBot
  class Idea < ActiveResource::Base
    include RemoteModel

    self.settings_class = MockBotSettings

    authenticates_with_email_and_token

  end
end

