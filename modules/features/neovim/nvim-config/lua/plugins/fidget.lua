-- show progress messages from language servers
return {
  'j-hui/fidget.nvim',
  tag = 'legacy',
  event = 'LspAttach',
  opts = {
    text = {
      spinner = 'dots_ellipsis'
    },
    window = {
      blend = 0,
    },
  },
}
