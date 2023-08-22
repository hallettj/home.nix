return {
  'akinsho/toggleterm.nvim',
  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return 140
      end
    end,
    persist_size = false,
    open_mapping = [[<c-\>]],
    direction = 'vertical',
    shade_terminals = true,
  },
}
