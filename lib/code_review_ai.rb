# frozen_string_literal: true

require 'openai'
require 'open3'
require_relative 'code_review_ai/client/initialize'
require_relative 'code_review_ai/client/code_review'
require_relative 'code_review_ai/client/branch_summary'
require_relative 'code_review_ai/client/utils'

# module CodeReviewAi
#   # ================================================================================
#   # This class interacts with the OpenAI API to process and generate
#   # a branch summary as well as code review comments using AI models.
#   # ================================================================================
#   class Client
#     # Initialize a new CodeReviewAi client
#     #
#     # @param api_token [String] OpenAI API access token for authentication
#     # @param ai_model [String] OpenAI model to use (e.g., 'gpt-3.5-turbo', 'gpt-4')
#     # @param language [String] Output language for generated content
#     def initialize(api_token, ai_model, language)
#       @client = create_openai_client(api_token)
#       @ai_model = ai_model
#       @language = language
#     end

#     # Conduct an AI-powered code review on the current branch
#     # Analyzes git diff and generates review comments using OpenAI
#     #
#     # @return [String] Generated code review comments
#     def conduct_code_review
#       prompt = generate_prompt(CodeReviewAi::Prompts::CODE_REVIEW_TEMPLATE)
#       response = @client.chat(
#         parameters: {
#           model: @ai_model,
#           messages: [
#             {
#               role: 'system',
#               content: 'You are an assistant generating code review comments based on repository changes.'
#             },
#             {
#               role: 'user',
#               content: prompt
#             }
#           ]
#         }
#       )
#       code_review_comments = process_response(response)
#       apply_code_review_comments(code_review_comments)
#     rescue StandardError => e
#       "Error communicating with OpenAI API: #{e.message}"
#     end

#     def generate_branch_summary
#       prompt = generate_prompt(CodeReviewAi::Prompts::BRANCH_SUMMARY_TEMPLATE)
#       response = @client.chat(
#         parameters: {
#           model: @ai_model,
#           messages: [
#             {
#               role: 'system',
#               content: 'You are an assistant summarizing git branch changes clearly and concisely.'
#             },
#             {
#               role: 'user',
#               content: prompt
#             }
#           ]
#         }
#       )
#       summary = process_response(response)
#       puts summary
#     rescue StandardError => e
#       "Error generating branch summary: #{e.message}"
#     end

#     private

#     def create_openai_client(api_token)
#       OpenAI::Client.new(
#         access_token: api_token,
#         log_errors: true
#       )
#     end

#     def process_response(response)
#       response.dig('choices', 0, 'message', 'content') || 'Error: Unable to generate code review.'
#     end

#     def generate_prompt(template)
#       format(template, changes: fetch_branch_changes, language: @language)
#     end

#     def fetch_branch_changes
#       current_branch = get_current_branch
#       default_branch = check_for_default_branch('main') || check_for_default_branch('master')

#       raise 'Neither main nor master branch found in the repository' unless default_branch
#       raise 'Could not determine current branch' unless current_branch

#       stdout, stderr, status = Open3.capture3("git diff #{default_branch}..#{current_branch}")

#       raise "Error getting git diff: #{stderr}" unless status.success?

#       stdout.strip
#     end

#     def check_for_default_branch(branch_name)
#       _, _, status = Open3.capture3("git show-ref refs/heads/#{branch_name}")
#       status.success? ? branch_name : nil
#     end

#     def get_current_branch
#       stdout, _, status = Open3.capture3('git rev-parse --abbrev-ref HEAD')
#       return stdout.strip if status.success?

#       nil
#     end

#     def apply_code_review_comments(code_review_comments)
#       comment_blocks = code_review_comments.scan(/File:\s+(.*?)\s+Line:\s+(\d+)\s+Suggestion:\s+(.*?)\s*(?:\n|$)/m)

#       comment_blocks.each do |file_path, line_number, suggestion|
#         add_comments_to_file(file_path, line_number.to_i, suggestion)
#       end
#     end

#     def add_comments_to_file(file_path, line_number, suggestion)
#       file_content = File.readlines(file_path)

#       # Ensure the line number is within the bounds of the file's length
#       if line_number <= file_content.size
#         # Add the comment at the specified line
#         file_content[line_number - 1] = "#{file_content[line_number - 1].chomp} # #{suggestion}\n"
#         # Write the modified content back to the file
#         File.write(file_path, file_content.join)
#       else
#         puts "Warning: Line #{line_number} does not exist in file #{file_path}."
#       end
#     end
#   end
# end
