#!/usr/bin/env perl -i -p

# Adds copyright headers to files passed in.
# Example:
# find . -name '*.rb' -exec bin/add-copyright-header.pl {} \;

$header = <<'END_HEADER';
#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#
END_HEADER

s/(# frozen_string_literal: true\n)/$1\n$header/
