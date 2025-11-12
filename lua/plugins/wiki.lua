return {
	"lervag/wiki.vim",
	init = function()
		-- Define the root for your main wiki
		vim.g.wiki_root = "~/Documents/notes/" -- Replace with your desired path, e.g., "~/wiki" or "/home/user/wiki"

		-- Add other wiki.vim options here as needed
		vim.g.wiki_filetypes = { "md", "wiki" } -- Example: enable for Markdown and Wiki files
		vim.g.wiki_index_name = "index" -- Default index name   -- wiki.vim configuration goes here, e.g.
	end,
}
