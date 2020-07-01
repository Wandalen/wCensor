#! /usr/bin/env node

/**
 * Utility to edit files massively from console and with undo.
  @module Tools/top/Filer
*/

let _ = require( '../include/Top.s' );
module[ 'exports' ] = _;
if( !module.parent )
_.filer.Cui.Exec();
