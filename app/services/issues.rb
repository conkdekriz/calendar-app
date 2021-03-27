# frozen_string_literal: true

class Issues < Service # rubocop:todo Style/Documentation
  ISSUES_URL = "https://api.github.com/issues"

  def self.show(user_token:)
    url = "#{ISSUES_URL}"
    get(url: url, xheaders: { 'Authorization' => "token #{user_token}" })
  end

end
