return {
  enabled = false,
  dir = "~/sandbox/tas-copilot",
  name = "tas-copilot",
  dev = { true },
  config = function()
    require("tas-copilot").setup()
  end,
}
