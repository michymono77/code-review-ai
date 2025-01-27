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
    Act as a seasoned Ruby developer with expert-level knowledge of OOP principles, best practices, and clean code standards.
    Your task is to provide a concise, well-structured summary of the changes made in the following branch.

    **Guidelines**:
    - Ensure the output is written entirely in **%<language>s**.
    - Provide clear, actionable insights in the summary.
    - Your recommendations should reflect OOP principles, performance, readability, and maintainability.
    - If possible, provide detailed suggestions for improvement.
    - Use the exact format specified below for consistency.
    - If you spot any codes that can be abstracted or refactored, please mention them.

    **Use the following format for the summary:**

    1. **Overview**
      A high-level summary of the changes made in the branch, describing their purpose and context in **%<language>s**.

    2. **File-wise Breakdown**
      For each file, list key changes with the following details:
      - **Summary**: A brief description of what was changed. Make sure too include which lines were added, removed, or modified.
      - **Impact**: How the change affects functionality, performance, or the codebase.
      - **Potential Issues**: Any concerns or risks introduced by the change.
      - **Suggestions for Improvement**: Recommendations for refining the code or changes.
      - **Other Notes**: Any additional context or points to consider.

    3. **Overall Impression**
      Your general recommendations on the inter file changes and the overall quality of the codebase.
      If refactoring or restructuring is possible, please mention it here in details.

    **Changes to Analyze:**
    %<changes>s
  PROMPT

  end
end
