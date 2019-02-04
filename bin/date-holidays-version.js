#!/usr/bin/env node

'use strict'

const path = require('path');
const fs = require('fs');

const dateHolidaysIndexJsPath = require.resolve('date-holidays');

const dateHolidaysPackageJsonPath = path.join(
  path.dirname(dateHolidaysIndexJsPath), '..', 'package.json'
);

console.log(JSON.parse(fs.readFileSync(dateHolidaysPackageJsonPath)).version);
