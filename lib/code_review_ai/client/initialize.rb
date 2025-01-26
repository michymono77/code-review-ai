# frozen_string_literal: true

module CodeReviewAi
  class Client
    # Initialize a new CodeReviewAi client
    #
    # @param api_token [String] OpenAI API access token for authentication
    # @param ai_model [String] OpenAI model to use (e.g., 'gpt-3.5-turbo', 'gpt-4')
    # @param language [String] Output language for generated content
    def initialize(api_token, ai_model, language)
      @client = create_openai_client(api_token)
      @ai_model = ai_model
      @language = language
    end

    private

    def create_openai_client(api_token)
      OpenAI::Client.new(
        access_token: api_token,
        log_errors: true
      )
    end
  end
end
