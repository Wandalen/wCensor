( function _MainBase_s_( )
{

'use strict';

/**
 * Utility to manage files from console.
  @module Tools/Censor
*/

//

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

}

//

const _ = _global_.wTools;
const Parent = null;
const Self = wCensor;
function wCensor( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Censor';

// --
// inter
// --

function finit()
{
  if( this.formed )
  this.unform();
  return _.Copyable.prototype.finit.apply( this, arguments );
}

//

function init( o )
{
  let censor = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let logger = censor.logger = new _.Logger({ output : _global_.logger, name : 'censor' });

  _.workpiece.initFields( censor );
  Object.preventExtensions( censor );

  _.assert( logger === censor.logger );

  if( o )
  censor.copy( o );

}

//

function unform()
{
  let censor = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !!censor.formed );

  /* begin */

  /* end */

  censor.formed = 0;
  return censor;
}

//

function form()
{
  let censor = this;

  if( censor.formed >= 1 )
  return censor;

  censor.formAssociates();

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !censor.formed );

  /* begin */

  /* end */

  censor.formed = 1;
  return censor;
}

//

function formAssociates()
{
  let censor = this;
  let logger = censor.logger;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !censor.formed );
  _.assert( !!logger );
  _.assert( logger.verbosity === censor.verbosity );

  if( !censor.fileProvider )
  {

    let hub = _.FileProvider.System({ providers : [] });

    _.FileProvider.Git().providerRegisterTo( hub );
    _.FileProvider.Npm().providerRegisterTo( hub );
    _.FileProvider.Http().providerRegisterTo( hub );
    _.FileProvider.HardDrive().providerRegisterTo( hub );
    hub.defaultProvider = hub.providersWithProtocolMap.hd;
    censor.fileProvider = hub;
    _.assert( !!hub.defaultProvider );

  }

  let logger2 = new _.Logger({ output : logger, name : 'censor.providers' });

  censor.fileProvider.logger = logger2;
  for( var f in censor.fileProvider.providersWithProtocolMap )
  {
    const fileProvider = censor.fileProvider.providersWithProtocolMap[ f ];
    fileProvider.logger = logger2;
  }

  _.assert( censor.fileProvider.logger === logger2 );
  _.assert( logger.verbosity === censor.verbosity );
  _.assert( censor.fileProvider.logger !== censor.logger );

  censor._verbosityChange();

  _.assert( logger2.verbosity <= logger.verbosity );
}

// --
// etc
// --

function _verbosityChange()
{
  let censor = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !censor.fileProvider || censor.fileProvider.logger !== censor.logger );

  if( censor.fileProvider )
  censor.fileProvider.verbosity = censor.verbosity-2;

}

//

function vcsProviderFor( o )
{
  let censor = this;
  const fileProvider = censor.fileProvider;
  const path = fileProvider.path;

  if( !_.mapIs( o ) )
  o = { filePath : o }

  _.assert( arguments.length === 1 );
  _.routineOptions( vcsProviderFor, o );
  _.assert( !!censor.formed );

  if( _.arrayIs( o.filePath ) && o.filePath.length === 0 )
  return null;

  if( !o.filePath )
  return null;

  let result = fileProvider.providerForPath( o.filePath );

  if( !result )
  return null

  if( !result.isVcs )
  return null

  return result;
}

vcsProviderFor.defaults =
{
  filePath : null,
}

//

function operationLink()
{
  let self = this;
  const fileProvider = self.fileProvider;
  const path = fileProvider.path;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !!self.libraryPath, 'Please define {-libraryPath-} first' );
  _.assert( self.opened );

  self.basePath = path.s.resolve( self.basePath );

  self.basePath = _.arrayAs( self.basePath );

  _.arrayAppendOnce( self.basePath, path.resolve( self.libraryPath ) );

  self.maskAll = _.RegexpObject( self.maskAll || {}, 'includeAny' );

  let excludeMask = _.RegexpObject
  ({
    excludeAny : self.excludeAny,
  });

  self.maskAll = _.RegexpObject.And( self.maskAll, excludeMask );
  // self.maskAll = _.files.regexpMakeSafe( self.maskAll );

  if( self.verbosity )
  logger.log( ' * Linking', _.entity.exportString( self.basePath ) );

  fileProvider.archive.basePath = self.basePath;
  fileProvider.archive.fileMapAutosaving = 1;
  fileProvider.archive.mask = self.maskAll;

  _.assert( _.all( fileProvider.statsResolvedRead( self.basePath ) ) );

  fileProvider.archive.filesUpdate();
  fileProvider.archive.filesLinkSame();

  if( self.beeping )
  _.diagnosticBeep();

  return self;
}

// --
// relations
// --

let Composes =
{
  verbosity : 3,
}

let Aggregates =
{
}

let Associates =
{

  fileProvider : null,
  logger : null,

}

let Restricts =
{
  formed : 0,
}

let Statics =
{
}

let Forbids =
{
}

// --
// declare
// --

let Extension =
{

  // inter

  finit,
  init,
  unform,
  form,
  formAssociates,

  // etc

  _verbosityChange,
  vcsProviderFor,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
wTools[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
require( './IncludeMid.s' );

})();
