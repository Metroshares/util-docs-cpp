#!/usr/bin/env node
const fs = require('fs')

// program
//   .version('0.1.0')
//   .parse(process.argv);

let obj = {}
    obj.versions = []

const user_config = JSON.parse( fs.readFileSync("eosio.docs.json") )
const config = JSON.parse( fs.readFileSync(".docs/book.default.json") )

config["pluginsConfig"]["custom-header-next"].logo = config["pluginsConfig"]["custom-header-next"].logo.replace("${project}", user_config.project)
config["pluginsConfig"]["custom-header-next"].base_path = config["pluginsConfig"]["custom-header-next"].base_path.replace("${project}", user_config.project)
config["pluginsConfig"]["custom-header-next"].text = config["pluginsConfig"]["custom-header-next"].text.replace("${project}", user_config.project)

fs.writeFile('.docs/book.json', JSON.stringify(config), 'utf8', () => {});
