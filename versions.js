#!/usr/bin/env node
const fs = require('fs');
const program = require('commander');

program
  .version('0.1.0')
  .option('-p, --path', 'Absolute path to directory containing "versions" directories [docs/history]', 'docs/history')
  .parse(process.argv);

const json = []

fs.readdir(program.path, (err, files) => {
  files.forEach(file => {
    json.push({
      value: file
    })
  });
})

var fs = require('fs');
fs.writeFile('versions.json', json, 'utf8', (err, data) => {
  console.log(data)
});
