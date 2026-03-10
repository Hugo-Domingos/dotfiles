return {
	'richwomanbtc/overleaf.nvim',
	config = function()
		require('overleaf').setup()
	end,
	build = 'cd node && npm install',
}
