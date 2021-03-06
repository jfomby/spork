/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

%default tableName 'value to be skipped'
aa = load '/data/intermediate/pow/elcarobootstrap/account/full/weekly/data/$date' using PigStorage('\x01');
bb = filter aa by (ARITY == '16') and ( $4 eq '' or $4 eq 'NULL' or $4 eq 'ss') parallel 400;
a = foreach bb generate $0,$12,$7;
%declare tableName 'inactiveAccounts'
--generate inactive accts
$tableName = filter a by ($1 neq '') and ($1 == '2') parallel 400;
store $tableName into $destination;
grpInactiveAcct = group $tableName all;
countInactiveAcct = foreach grpInactiveAcct { generate COUNT( $tableName ); }
store countInactiveAcct into '/user/kaleidoscope/pow_stats/20080228/acct_stats/InactiveAcctCount';
