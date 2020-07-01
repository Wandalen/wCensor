( function _Base_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../dwtools/Tools.s' );

  _.include( 'wCopyable' );
  // _.include( 'wVerbal' );
  _.include( 'wFiles' );
  _.include( 'wCensorBasic' );
  // _.include( 'wTemplateTreeEnvironment' );
  // _.include( 'wServletTools' );
  // _.include( 'wLoggerSocket' );

  module.exports = _;
}

})();
