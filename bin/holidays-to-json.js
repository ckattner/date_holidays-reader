'use strict'

/**
 * Adapted from sample.js (https://github.com/commenthol/date-holidays/blob/master/test/sample.js).
 * holidays-to-json.js <country.state> <year> <langs>
 * e.g.
 * holidays-to-json.js at.b 2015 1
 */
var Holidays = require('date-holidays');

var days = 'Sun,Mon,Tue,Wed,Thu,Fri,Sat'.split(',');
function weekday (i) {
  return days[new Date(i.date).getDay()];
}

if (module === require.main) {
  var cmd = {};
  var opts = {};
  var args = process.argv.slice(2);
  var arg;

  while ((arg = args.shift())) {
    if (arg === '--lang') {
      opts.languages = args.shift();
    } else if (/^\d{4}$/.test(arg)) {
      opts.year = arg;
    } else if (/^[a-zA-Z]{2}/.test(arg)) {
      opts.country = arg;
    }
  }

  opts.year = opts.year || (new Date()).getFullYear();
  opts.languages = opts.languages || ['en'];
  console.log("opts")
  console.log(opts)

  var hd = new Holidays(opts.country, { languages: opts.languages } );
  var res = hd.getHolidays(opts.year);
  console.log(JSON.stringify(res));
}
