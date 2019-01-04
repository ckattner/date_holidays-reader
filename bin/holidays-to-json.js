#!/usr/bin/env node

'use strict'

/**
 * Adapted from sample.js (https://github.com/commenthol/date-holidays/blob/master/test/sample.js).
 * holidays-to-json.js sub_command [country.state.region] [year] [--lang en] [--state ca]
 * e.g.
 * holidays-to-json.js holidays at.b 2015
 */
var Holidays = require('date-holidays');

const COMMANDS = Object.freeze({
  holidays: (hd, opts) => hd.getHolidays(opts.year),
  countries: (hd, _) => hd.getCountries(),
  // Note that the language isn't working here. This appears to be a bug in the node module.
  states: (hd, opts) => hd.getStates(opts.country, opts.languages.first),
  regions: (hd, opts) => hd.getRegions(opts.country, opts.state, opts.languages.first),
  languages: (hd, _) => hd.getLanguages(),
  time_zones: (hd, _) => hd.getTimezones(),
});
const DEFAULT_LANGUAGE = 'en';

function extractData(cmd, hd, opts) {
  const extractor = COMMANDS[cmd]

  if (extractor) {
    return extractor(hd, opts);
  } else {
    console.error("Uknown sub-command: " + cmd);
    console.error("Valid sub-commands are: " + Object.keys(COMMANDS).join(', '));
    process.exit(1);
  }
}

if (module === require.main) {
  const opts = {};
  const args = process.argv.slice(2);
  const cmd = args.shift();
  var arg;

  while ((arg = args.shift())) {
    if (arg === '--lang') {
      opts.languages = args.shift();
    } else if (arg === '--state') {
      opts.state = args.shift();
    } else if (/^\d{4}$/.test(arg)) {
      opts.year = arg;
    } else if (/^[a-zA-Z]{2}/.test(arg)) {
      opts.country = arg;
    }
  }

  opts.year = opts.year || (new Date()).getFullYear();
  opts.languages = opts.languages || [DEFAULT_LANGUAGE];

  var hd = new Holidays(opts.country, { languages: opts.languages, state: opts.state } );
  console.log(JSON.stringify(extractData(cmd, hd, opts)));
}
