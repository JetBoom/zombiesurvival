const fs = require('fs')

var walkSync = function(dir, filelist) {
	const files = fs.readdirSync(dir);
	filelist = filelist || [];
	files.forEach(function(file) {
		if (fs.statSync(dir + '/' + file).isDirectory())
			filelist = walkSync(dir + '/' + file, filelist)
		else
			filelist.push(dir + '/' + file)
	})
	return filelist
}

const files = walkSync('./weapons')

var contents
var replaced

function replacer(s, a, b) {
	replaced = true
	return 'SWEP.Cone' + a + ' = ' + parseFloat(b) * 50
}

for (var i=0; i < files.length; i++) {
	if (files[i].substr(-4) == '.lua') {
		replaced = false

		contents = fs.readFileSync(files[i], {encoding: 'utf8'}).toString()
		contents = contents.replace(/SWEP.Cone(M..) = ([0-9\.]+)/g, replacer)

		if (replaced)
			fs.writeFileSync(files[i], contents)
	}
}