# frozen_string_literal: true

require 'openai'
require 'git'
require_relative 'code_review_ai/version'

module CodeReviewAi
  # ================================================================================
  # This class interacts with the Commit Message AI service to process and generate
  # meaningful commit messages based on staged changes in the repository.
  # ================================================================================
  class Client
    def initialize(api_token, repo_path = '.')
      @client = OpenAI::Client.new(
        access_token: api_token,
        log_errors: true
      )
      @repo = Git.open(repo_path)
    end

    # Generates a code review with comments based on the staged changes.
    def generate_code_review
      prompt = generate_prompt
      response = @client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [
            { role: 'system', content: 'You are an assistant generating code review comments based on staged changes.' },
            { role: 'user', content: prompt }
          ]
        }
      )
      code_review_comments = response.dig('choices', 0, 'message', 'content') || 'Error: Unable to generate code review.'
      apply_code_review_comments(code_review_comments)
    rescue StandardError => e
      "Error communicating with OpenAI API: #{e.message}"
    end

    private

    # Generates the prompt to describe the current changes in the repository.
    def generate_prompt
      changes = @repo.diff('HEAD').patch
      <<~PROMPT
        The following are the current staged changes in the repository:

        #{changes}

        Please review these changes and provide code improvement suggestions. Format each suggestion as a comment to be added to the relevant lines in the changed files.
      PROMPT
    end

    # Applies the generated code review comments to the files.
    def apply_code_review_comments(comments)
      comment_blocks = comments.scan(/File: (.*?)\n(.*?)\n\n/m)
      comment_blocks.each do |file_path, comment|
        add_comments_to_file(file_path, comment)
      end
    end

    # Adds comments to the specified file.
    def add_comments_to_file(file_path, comments)
      lines_with_comments = comments.scan(/Line (\d+): (.*?)(?=\nLine|$)/m)
      file_content = File.readlines(file_path)

      lines_with_comments.each do |line_number, comment|
        line_index = line_number.to_i - 1
        file_content[line_index] = "#{file_content[line_index].chomp} # #{comment}\n"
      end

      File.write(file_path, file_content.join)
    end
  end
end
