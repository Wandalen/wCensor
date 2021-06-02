( function _Namespace_s_( )
{

'use strict';

const _ = _global_.wTools;
_.censor = _.censor || Object.create( null );

let _vopts = { vectorizingContainerAdapter : 1, unwrapingContainerAdapter : 0 };
let vectorize = _.routineDefaults( null, _.vectorize, _vopts );
let vectorizeAll = _.routineDefaults( null, _.vectorizeAll, _vopts );
let vectorizeAny = _.routineDefaults( null, _.vectorizeAny, _vopts );
let vectorizeNone = _.routineDefaults( null, _.vectorizeNone, _vopts );

// --
// implement
// --

// --
// declare
// --

let Restricts =
{

  vectorize,
  vectorizeAll,
  vectorizeAny,
  vectorizeNone,

}

let Extension =
{

  _ : Restricts,

}

/* _.props.extend */Object.assign( _.censor, Extension );

})();
