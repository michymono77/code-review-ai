# frozen_string_literal: true

module CodeReviewAi
  class Client
    private

    def process_response(response)
      response.dig('choices', 0, 'message', 'content') || 'Error: Unable to generate code review.'
    end

    def generate_prompt(template, language)
      format(template, changes: fetch_branch_changes, language: language)
    end

    def fetch_branch_changes
      current_branch = get_current_branch
      default_branch = check_for_default_branch('main') || check_for_default_branch('master')

      raise 'Neither main nor master branch found in the repository' unless default_branch
      raise 'Could not determine current branch' unless current_branch

      stdout, stderr, status = Open3.capture3("git diff #{default_branch}..#{current_branch}")

      raise "Error getting git diff: #{stderr}" unless status.success?

      stdout.strip
    end

    def check_for_default_branch(branch_name)
      _, _, status = Open3.capture3("git show-ref refs/heads/#{branch_name}")
      status.success? ? branch_name : nil
    end

    def get_current_branch
      stdout, _, status = Open3.capture3('git rev-parse --abbrev-ref HEAD')
      return stdout.strip if status.success?

      nil
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
      if (1..file_content.size).cover?(line_number)
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
