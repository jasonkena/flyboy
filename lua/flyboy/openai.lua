local curl = require('plenary.curl')

local function get_chatgpt_completion(options, messages, on_delta, on_complete)
    curl.post(options.url,
        {
            headers = options.headers,
            body = vim.fn.json_encode(
                {
                    model = options.model,
                    temperature = options.temperature,
                    messages = messages,
                    stream = true
                }),
            stream = vim.schedule_wrap(
                function(_, data, _)
                    local raw_message = string.gsub(data, "^data: ", "")
                    if raw_message == "[DONE]" then
                        on_complete()
                    elseif (string.len(data) > 6) then
                        local status, result = pcall(vim.fn.json_decode, string.sub(data, 6))
                        if status then
                            on_delta(result)
                        else
                            print("Error decoding JSON:", result, data)
                        end
                    end
                end)
        })
end


return {
    get_chatgpt_completion = get_chatgpt_completion
}
