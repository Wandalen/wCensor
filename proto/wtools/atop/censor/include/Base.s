( function _Base_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../node_modules/Tools' );

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wCensorBasic' );

  module.exports = _;
}

})();
