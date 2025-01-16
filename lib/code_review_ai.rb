# frozen_string_literal: true

require 'openai'
require 'open3'
require_relative 'code_review_ai/version'

module CodeReviewAi
  # ================================================================================
  # This class interacts with the Commit Message AI service to process and generate
  # meaningful commit messages based on changes in the repository.
  # ================================================================================
  class Client
    def initialize(api_token)
      @client = OpenAI::Client.new(
        access_token: api_token,
        log_errors: true
      )
    end

    def generate_code_review
      prompt = generate_prompt
      response = @client.chat(
        parameters: {
          model: 'gpt-4o-mini',
          messages: [
            { role: 'system', content: 'You are an assistant generating code review comments based on repository changes.' },
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
      changes = fetch_branch_changes
      <<~PROMPT
        I will give you the changes in the repository between the current branch and main.

        Please review these changes and provide code improvement suggestions.
        Your response should only contain series of suggestions for each file and line number.
        For each suggestion, you must exactly use following format: # Add validation to ensure `file_path` exists before attempting to read it in `add_comments_to_file`.

        "File: lib/code_review_ai.rb  \nLine: 12  \nSuggestion: [👉SUGGESTION💡]Consider adding error handling for scenarios where the Git repository cannot be opened.\n\nFile: lib/code_review_ai.rb  \nLine: 24  \nSuggestion: [👉SUGGESTION💡]Add a comment to explain the purpose of the `generate_code_review` method.\n\nFile: lib/code_review_ai.rb  \nLine: 33  \nSuggestion: [👉SUGGESTION💡]Add a comment to clarify what the expected format of the prompt is.\n\nFile: lib/code_review_ai.rb  \nLine: 41  \nSuggestion: [👉SUGGESTION💡]Include a comment to describe what `apply_code_review_comments` does."

        Ensure that each suggestion is clearly associated with the relevant file and line of code.
        Do not return anything but the suggestions. No introduction or conclusion is needed.

        Here are the changes in the repository:
        #{changes}
      PROMPT
    end

    def fetch_branch_changes
      stdout, stderr, status = Open3.capture3('git diff main...HEAD')

      raise "Error getting git diff: #{stderr}" unless status.success?

      stdout.strip
    end

    def apply_code_review_comments(code_review_comments)
      comment_blocks = code_review_comments.scan(/File:\s+(.*?)\s+Line:\s+(\d+)\s+Suggestion:\s+(.*?)\s*(?:\n|$)/m)

      comment_blocks.each do |file_path, line_number, suggestion|
        add_comments_to_file(file_path, line_number.to_i, suggestion)
      end
    end

    def add_comments_to_file(file_path, line_number, suggestion)
      # Read the file content
      file_content = File.readlines(file_path)

      # Ensure the line number is within the bounds of the file's length
      if line_number <= file_content.size
        # Add the comment at the specified line
        file_content[line_number - 1] = "#{file_content[line_number - 1].chomp} # #{suggestion}\n"
        # Write the modified content back to the file
        File.write(file_path, file_content.join)
      else
        puts "Warning: Line #{line_number} does not exist in file #{file_path}."
      end
    end
  end
end
