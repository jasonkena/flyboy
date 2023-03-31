local curl = require('plenary.curl')

local function get_chatgpt_completion(messages, callback)
	curl.post("https://api.openai.com/v1/chat/completions",
		{
			headers = {
				Authorization = "Bearer " .. vim.env.OPENAI_API_KEY,
				content_type = "application/json"
			},
			body = vim.fn.json_encode(
				{
					model = "gpt-3.5-turbo",
					messages = messages
				}),
			callback = function (response) callback(vim.fn.json_decode(response.body)) end
		})
end

local function get_code_edit(input, instruction, callback)
	curl.post("https://api.openai.com/v1/edits",
		{
			headers = {
				Authorization = "Bearer " .. vim.env.OPENAI_API_KEY,
				content_type = "application/json"
			},
			body = vim.fn.json_encode(
				{
					model = "code-davinci-edit-001",
					input = input,
					instruction = instruction
				}),
			callback = function (response) callback(vim.fn.json_decode(response.body)) end
		})
end

return {
	get_chatgpt_completion = get_chatgpt_completion,
	get_code_edit = get_code_edit

}
