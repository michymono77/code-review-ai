module CodeReviewAi
  module Prompts
    TEMPLATE = <<~PROMPT
      Act as a ruby developer who has intimate knowledge of OOP principles and best practices, please answer the following questions.
      You are tasked with reviewing the changes in the repository and providing code improvement suggestions.
      I will give you the changes in the repository between the "current branch" and "main(or master)" at the end.

      Please carefully review these changes and provide code improvement suggestions.

      Your response should only contain series of suggestions for each file and line number.
      For each suggestion, you must exactly use the following format:

      "File: lib/code_review_ai.rb  \nLine: 12  \nSuggestion: [👉SUGGESTION💡]Consider adding error handling for scenarios where the Git repository cannot be opened.\n\nFile: lib/code_review_ai.rb  \nLine: 24  \nSuggestion: [👉SUGGESTION💡]Add a comment to explain the purpose of the `generate_code_review` method.\n\nFile: lib/code_review_ai.rb  \nLine: 33  \nSuggestion: [👉SUGGESTION💡]Add a comment to clarify what the expected format of the prompt is.\n\nFile: lib/code_review_ai.rb  \nLine: 41  \nSuggestion: [👉SUGGESTION💡]Include a comment to describe what `apply_code_review_comments` does."

      Ensure that each suggestion is clearly associated with the relevant file and line of code.
      Make sure to FOLLOW THE FORMAT strictly to avoid any errors in processing the suggestions.

      If examples are appropriate, you can include them in the suggestions.

      Make sure NOT TO RETURN ANYTHING BUT SUGGESTIONS. No introduction or conclusion is needed.

      Here are the changes in the repository:
      %{changes}
    PROMPT
  end
end
