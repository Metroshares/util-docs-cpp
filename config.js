#!/usr/bin/env node
const fs = require('fs')

// program
//   .version('0.1.0')
//   .parse(process.argv);

let obj = {}
    obj.versions = []

const user_config = JSON.parse( fs.readFileSync("eosio.docs.json") )
const config = JSON.parse( fs.readFileSync(".docs/book.default.json") )

config.logo = config.logo.replace("${project}", user_config.project)
config.base_path = config.base_path.replace("${project}", user_config.project)
config.text = config.text.replace("${project}", user_config.project)

fs.writeFile('.docs/book.json', JSON.stringify(config), 'utf8', () => {});
