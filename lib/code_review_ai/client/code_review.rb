# frozen_string_literal: true

require_relative '../prompts'

module CodeReviewAi
  class Client
    # Conduct an AI-powered code review on the current branch
    # Analyzes git diff and generates review comments using OpenAI
    #
    # @return [String] Generated code review comments
    def conduct_code_review
      prompt = generate_prompt(CodeReviewAi::Prompts::CODE_REVIEW_TEMPLATE, @language)
      response = @client.chat(
        parameters: {
          model: @ai_model,
          messages: [
            {
              role: 'system',
              content: 'You are an assistant generating code review comments based on repository changes.'
            },
            {
              role: 'user',
              content: prompt
            }
          ]
        }
      )
      code_review_comments = process_response(response)
      apply_code_review_comments(code_review_comments)
    rescue StandardError => e
      "Error communicating with OpenAI API: #{e.message}"
    end
  end
end
