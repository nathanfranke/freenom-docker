const http = require('http')
const { execFile } = require("child_process");
const process = require('process');

const PORT = 8080;

const args = process.argv.slice(2);

const server = http.createServer((req, res) => {
	process.stdout.write("Remotely executing freenom script... ");
	
	execFile("./freenom.sh", args, (error, stdout, stderr) => {
		if(error) {
			res.writeHead(500);
			res.end(error.message);
			console.log("ERR");
		} else {
			res.writeHead(200);
			res.end(stdout);
			console.log("OK");
		}
	});
});

console.log(`Server is listening on port ${PORT}.`);
server.listen(PORT);

process.on('SIGINT', () => process.exit(0));
