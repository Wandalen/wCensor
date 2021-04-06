( function _Top_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( './Mid.s' );

  _.include( 'wCommandsAggregator' );

  require( '../l8/Cui.s' );

  module.exports = _;
}

})();
