class CompletionsController < ApplicationController
  def create
    language = params["language"]
    filename = params["filename"]
    technologies = params["technologies"]
    text_before_cursor = params["textBeforeCursor"]
    text_after_cursor = params["textAfterCursor"]

    system_prompt = <<~PROMPT
    You're working with a #{language} file named #{filename || 'unnamed'} in a project using #{technologies&.join(', ') || 'Ruby'}.
    PROMPT
    prompt = <<~PROMPT
    Complete the code after the cursor position with appropriate Ruby syntax. Ensure the code follows modern Ruby best practices and matches the style of the existing code.
    #{text_before_cursor}[CURSOR]#{text_after_cursor}
    PROMPT

    response = HTTP.post("https://api.deepseek.com/chat/completions", headers: {
      "Authorization" => "Bearer #{ENV["DEEPSEEK_API_KEY"]}"
    }, json: {
      model: "deepseek-chat",
      messages: [
        { role: "system", content: system_prompt },
        { role: "user", content: prompt }
      ]
    })

    code = JSON.parse(response.body.to_s).dig("choices", 0, "message", "content")

    puts code

    render json: { text: code }
  end
end
