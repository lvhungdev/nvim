Keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>', MapOpts)
Keymap('n', '<leader>dc', ':DapContinue<CR>', MapOpts)
Keymap('n', '<leader>dt', ':DapTerminate<CR>', MapOpts)
Keymap('n', '<leader>do', ':DapStepOver<CR>', MapOpts)
Keymap('n', '<leader>di', ':DapStepInto<CR>', MapOpts)
Keymap('n', '<leader>dO', ':DapStepOut<CR>', MapOpts)

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },
  cmd = { 'DapToggleBreakpoint', 'DapContinue' },
  config = function()
    local dap, dapui = require('dap'), require('dapui')

    dapui.setup({
      layouts = {
        {
          elements = {
            { id = 'repl',    size = 0.4 },
            { id = 'scopes',  size = 0.4 },
            { id = 'watches', size = 0.2 },
          },
          position = 'right',
          size = 50
        },
      },
    })

    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    dap.adapters.delve = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
      }
    }
    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}'
      },
    }
  end
}
