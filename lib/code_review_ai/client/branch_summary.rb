# frozen_string_literal: true
require_relative '../prompts'

module CodeReviewAi
  class Client
    def generate_branch_summary
      prompt = generate_prompt(CodeReviewAi::Prompts::BRANCH_SUMMARY_TEMPLATE, @language)
      response = @client.chat(
        parameters: {
          model: @ai_model,
          messages: [
            {
              role: 'system',
              content: 'You are an assistant summarizing git branch changes clearly and concisely.'
            },
            {
              role: 'user',
              content: prompt
            }
          ]
        }
      )
      summary = process_response(response)
      puts summary
    rescue StandardError => e
      "Error generating branch summary: #{e.message}"
    end
  end
end
