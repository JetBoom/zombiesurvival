const fs = require('fs')

const regex_block_comments = /([\-]{2,}[\[]{2}[\s\S]*?[\]]{2})/igm
const regex_block_comments2 = /\/\*[\s\S]*?\*\//igm
const regex_tabs = /([\t]{1,})/ig
const regex_newlines = /(\n)/gm
const regex_block_str_to_normal_str = /([\[]{2}[\s\S]*?[\]]{2})/igm

const STR_OPEN = ['"', "'", '`']
const STR_CLOSE = ['"', "'", '`']

const SCOPE_IN = ['do', 'then', 'function']
const SCOPE_OUT = ['end', 'elseif']

/*function getRandomInt(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min
}

function randomWS(match, m) {
	return ' '.repeat(getRandomInt(1, 10))
}*/

const regex_newline = /(\n)/g
const regex_newline2 = /(\r)/g
const regex_quote = /(")/g
function replace_block_str(match, m, offset, string) {
	m = m.replace(regex_newline, '\\n')
	m = m.replace(regex_newline2, '')
	m = m.replace(regex_quote, '\\"')

	return '"' + m.substring(2, m.length - 2) + '"'
}

function replace_locals(str) {
	// TODO

	/*var varName
	var varId = 1

	varName = 'v' + varId
	varId++*/

	return str
}

function decomment_line(str) {
	if (str.substring(0, 2) === '--' || str.substring(0, 2) === '//')
		return ' '

	var si
	var in_string = null

	for (var i=0; i < str.length; i++) {
		if (in_string !== null) {
			if (str[i] === STR_CLOSE[in_string] && str[i - 1] !== '\\')
				in_string = null
		}
		else if (str[i] === '-' && str[i + 1] === '-' || str[i] === '/' && str[i + 1] === '/') {
			return str.substring(0, i) + ' '
		}
		else {
			si = STR_OPEN.indexOf(str[i])
			if (si >= 0)
				in_string = si
		}
	}

	return str
}

function obsfucate(str) {
	str = str.replace(/(\r)/g, '')

	str = str.replace(regex_block_comments, ' ')
	str = str.replace(regex_block_comments2, ' ')
	str = str.replace(regex_block_str_to_normal_str, replace_block_str)

	const lines = str.split('\n')
	for (var i=0; i < lines.length; i++) {
		lines[i] = decomment_line(lines[i])
	}
	str = lines.join(' ')

	str = str.replace(regex_tabs, ' ' /*randomWS*/)
	str = str.replace(regex_newlines, ' ')

	str = replace_locals(str)

	return str
}

const regex_to_out = /(^[a-z0-9_-]*?)\//im
function toOut(file) {
	return file.replace(regex_to_out, '$1_obsfucated/')
}

function obsfucateFile(file, skip) {
	var str = fs.readFileSync(file, 'utf8')

	if (skip)
		console.log('copying ' + file)
	else {
		console.log('obfuscating ' + file)
		str = obsfucate(str)
	}

	fs.writeFileSync(toOut(file), str)
}

function obfuscateDir(dir) {
	var out_dir = toOut(dir)
	if (!fs.existsSync(out_dir))
		fs.mkdirSync(out_dir)

	const readdir = fs.readdirSync(dir)

	for (var i=0; i < readdir.length; i++) {
		if (readdir[i].indexOf('.') >= 0) {
			if (readdir[i].indexOf('.lua') >= 0)
				obsfucateFile(dir + '/' + readdir[i], readdir[i] === 'init.lua' || readdir[i] === 'server.lua' || readdir[i].substr(0, 3) === 'sv_')
		}
		else {
			out_dir = toOut(dir + '/' + readdir[i])
			if (!fs.existsSync(out_dir))
				fs.mkdirSync(out_dir)

			obfuscateDir(dir + '/' + readdir[i])
		}
	}
}

function deleteFolderRecursive(path) {
	if (fs.existsSync(path)) {
		fs.readdirSync(path).forEach(function(file, index) {
			var curPath = path + "/" + file
			if (fs.lstatSync(curPath).isDirectory())
				deleteFolderRecursive(curPath)
			else
				fs.unlinkSync(curPath)
		})

		fs.rmdirSync(path)
	}
}

if (process.argv.length < 2)
	console.log('No folders specified')
else
	process.argv.forEach(function (val, index, array) {
		if (index >= 2) {
			const out_path = val + '_obsfucated'

			deleteFolderRecursive(out_path)

			fs.mkdirSync(out_path)

			obfuscateDir(val)
		}
	})
