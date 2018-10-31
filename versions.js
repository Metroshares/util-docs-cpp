#!/usr/bin/env node
const fs = require('fs');
const program = require('commander');

program
  .version('0.1.0')
  .option('-p, --path', 'Absolute path to directory containing "versions" directories [docs/history]', 'history')
  .parse(process.argv);

fs.readdir(program.path, (err, files) => {
  files.forEach(file => {
    console.log(file);
  });
})
