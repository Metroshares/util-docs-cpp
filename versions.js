#!/usr/bin/env node
const fs = require('fs');
const program = require('commander');

program
  .version('0.1.0')
  .option('-p, --path', 'Absolute path to directory containing "versions" directories [docs/history]', 'docs/history')
  .parse(process.argv);

let obj = {}
    obj.versions = []

fs.readdir(program.path, (err, files) => {
  files.forEach(file => {
    obj.versions.push({
      value: file,
      latest: false,
      beta: false,
      public: true
    })
  });

  fs.writeFile('versions.json', JSON.stringify(obj), 'utf8', () => {});
})
