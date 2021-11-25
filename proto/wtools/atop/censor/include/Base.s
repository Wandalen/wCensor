( function _Base_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wCensorBasic' );
  _.include( 'wIdentity' );

  module.exports = _;
}

})();
