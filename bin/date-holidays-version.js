#!/usr/bin/env node

/*
 Copyright(c) 2019 - present, Blue Marble Payroll, LLC

 This source code is licensed under the MIT license found in the
 LICENSE file in the root directory of this source tree.
*/

'use strict'

const path = require('path');
const fs = require('fs');

const dateHolidaysIndexJsPath = require.resolve('date-holidays');

const dateHolidaysPackageJsonPath = path.join(
  path.dirname(dateHolidaysIndexJsPath), '..', 'package.json'
);

console.log(JSON.parse(fs.readFileSync(dateHolidaysPackageJsonPath)).version);
