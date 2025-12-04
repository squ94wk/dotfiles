local M = {}

-- Focus a path in neo-tree without changing root
function M.neotree_focus_path(path)
  path = vim.fn.expand(path)
  local abs_path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")

  vim.schedule(function()
    vim.cmd("Neotree focus")

    vim.defer_fn(function()
      local state = require("neo-tree.sources.manager").get_state("filesystem")
      if not state then return end

      local renderer = require("neo-tree.ui.renderer")

      require("neo-tree.sources.filesystem").navigate(
        state,
        state.path,
        abs_path,
        function()
          vim.schedule(function()
            local node = state.tree:get_node(abs_path)
            if node then
              renderer.focus_node(state, node:get_id())

              if node.type == "directory" and not node:is_expanded() then
                require("neo-tree.sources.filesystem.commands").toggle_node(state)
              end
            end
          end)
        end
      )
    end, 50)
  end)
end

return M
