'use strict'

/**
 * Adapted from sample.js (https://github.com/commenthol/date-holidays/blob/master/test/sample.js).
 * holidays-to-json.js <country.state> <year> <langs>
 * e.g.
 * holidays-to-json.js at.b 2015 1
 */
var Holidays = require('date-holidays')

var days = 'Sun,Mon,Tue,Wed,Thu,Fri,Sat'.split(',')
function weekday (i) {
  return days[new Date(i.date).getDay()]
}

if (module === require.main) {
  var cmd = {}
  var opts = {}
  var args = process.argv.slice(2)
  var arg

  while ((arg = args.shift())) {
    if (arg === '--lang') {
      opts.languages = args.shift()
    } else if (/^\d{4}$/.test(arg)) {
      cmd.year = arg
    } else if (/^[a-zA-Z]{2}/.test(arg)) {
      cmd.country = arg
    }
  }

  cmd.year = cmd.year || (new Date()).getFullYear()

  var hd = new Holidays(cmd.country, opts)
  var res = hd.getHolidays(cmd.year)
  console.log(JSON.stringify(res))
}
