# frozen_string_literal: true

require 'openai'
require 'open3'
require_relative 'code_review_ai/version'
require_relative 'code_review_ai/prompts'

module CodeReviewAi
  # ================================================================================
  # This class interacts with the Commit Message AI service to process and generate
  # meaningful commit messages based on changes in the repository.
  # ================================================================================
  class Client
    def initialize(api_token, ai_model, language)
      @client = create_openai_client(api_token)
      @ai_model = ai_model
      @language = language
    end

    def conduct_code_review
      prompt = generate_prompt
      response = get_ai_response(prompt)
      code_review_comments = process_code_review_response(response)
      apply_code_review_comments(code_review_comments)
    rescue StandardError => e
      "Error communicating with OpenAI API: #{e.message}"
    end

    private

    def create_openai_client(api_token)
      OpenAI::Client.new(
        access_token: api_token,
        log_errors: true
      )
    end

    def process_code_review_response(response)
      response.dig('choices', 0, 'message', 'content') || 'Error: Unable to generate code review.'
    end

    def get_ai_response(prompt)
      @client.chat(
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
    end

    def generate_prompt
      changes = fetch_branch_changes
      format(CodeReviewAi::Prompts::TEMPLATE, changes: changes, language: @language)
    end

    def fetch_branch_changes
      branch = check_for_default_branch('main') || check_for_default_branch('master')

      raise 'Neither main nor master branch found in the repository' unless branch

      stdout, stderr, status = Open3.capture3("git diff #{branch}...HEAD")

      raise "Error getting git diff: #{stderr}" unless status.success?

      stdout.strip
    end

    def check_for_default_branch(branch_name)
      _, _, status = Open3.capture3("git show-ref refs/heads/#{branch_name}")
      status.success? ? branch_name : nil
    end

    def apply_code_review_comments(code_review_comments)
      comment_blocks = code_review_comments.scan(/File:\s+(.*?)\s+Line:\s+(\d+)\s+Suggestion:\s+(.*?)\s*(?:\n|$)/m)

      comment_blocks.each do |file_path, line_number, suggestion|
        add_comments_to_file(file_path, line_number.to_i, suggestion)
      end
    end

    def add_comments_to_file(file_path, line_number, suggestion)
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
