local LOG = require("llm.common.log")
local state = require("llm.state")

local function init(opts)
  if not state.completion.backend then
    if opts.api_type == "ollama" then
      local ollama = require("llm.common.completion.backends.ollama")
      state.completion.backend = ollama
      LOG:TRACE(string.format("llm.nvim completion provider: %s", opts.api_type))
      return ollama
    elseif opts.api_type == "openai" or opts.api_type == "deepseek" then
      local deepseek = require("llm.common.completion.backends.deepseek")
      state.completion.backend = deepseek
      LOG:TRACE(string.format("llm.nvim completion provider: %s", opts.api_type))
      return deepseek
    elseif opts.api_type == "codeium" then
      local codeium = require("llm.common.completion.backends.codeium"):init(opts)

      state.completion.backend = codeium
      LOG:TRACE(string.format("llm.nvim completion provider: %s", opts.api_type))
      return codeium
    elseif opts.api_type == "vllm" then
      local vllm = require("llm.common.completion.backends.vllm")
      state.completion.backend = vllm
      LOG:TRACE(string.format("llm.nvim completion provider: %s", opts.api_type))
      return vllm
    end
  else
    return state.completion.backend
  end
end

return setmetatable({}, {
  __call = function(_, opts)
    return init(opts)
  end,
})
