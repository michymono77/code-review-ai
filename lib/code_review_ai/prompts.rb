module CodeReviewAi
  module Prompts
    CODE_REVIEW_TEMPLATE = <<~PROMPT
      Act as a Ruby developer with expert-level knowledge of OOP principles and best practices.
      You are tasked with reviewing the changes in the repository and providing ACTIONABLE code improvement suggestions.

      I will specifiy the language(e.g., English) of the code review and provide the differences between the "current branch" and "main (or master)" branch at the end of this prompt.

      Instructions for your response:

      1. Carefully analyze the changes in terms of Object-Oriented Principles, performance, readability and maintainability, scalability, and error handling.
      2. Provide improvement suggestions for each file and line number where applicable.
      3. Use the exact format like below for every suggestion:

      "File: lib/code_review_ai.rb  \nLine: 12  \nSuggestion: [👉SUGGESTION💡]Consider adding error handling for scenarios where the Git repository cannot be opened.\n\nFile: lib/code_review_ai.rb  \nLine: 24  \nSuggestion: [👉SUGGESTION💡]Add a comment to explain the purpose of the `generate_code_review` method.\n\nFile: lib/code_review_ai.rb  \nLine: 33  \nSuggestion: [👉SUGGESTION💡]Add a comment to clarify what the expected format of the prompt is.\n\nFile: lib/code_review_ai.rb  \nLine: 41  \nSuggestion: [👉SUGGESTION💡]Include a comment to describe what `apply_code_review_comments` does."

      Ensure that each suggestion is clearly associated with the relevant file and line of code.
      Make sure to FOLLOW THE FORMAT strictly to avoid any errors in processing the suggestions.

      If code examples are available, make your best effort to include them in the suggestions.

      Make sure NOT TO RETURN ANYTHING OUTSIDE OF THE REQUIRED FORMAT. No introduction or conclusion is needed.

      Please generate the code review suggestions in following language:
      %<language>s

      Here are the changes in the repository:
      %<changes>s
    PROMPT

    BRANCH_SUMMARY_TEMPLATE = <<~PROMPT
      You are a Ruby developer with expert-level proficiency in OOP principles and best practices.
      Your task is to provide a concise, well-structured summary of the changes made in the following branch.

      Please ensure that all output is written in %<language>s.

      Follow this format for your summary:

      1. **Overview**: A high-level summary of the changes made in the branch, written in %<language>s.

      2. **File-wise Breakdown**: For each file, list the key changes in bullet points. Be specific and concise:
        - **Summary**: A brief description of the change.
        - **Impact**: How the change affects the functionality or performance.
        - **Potential Issues**: Any concerns or potential pitfalls with the change.
        - **Suggestions for Improvement**: Recommendations for enhancing the change or code.
        - **Other Notes**: Any additional relevant details or context.

      Changes:
      %<changes>s
    PROMPT
  end
end
