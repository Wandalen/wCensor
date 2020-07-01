( function _MainBase_s_( )
{

'use strict';

/**
 * Utility to manage files from console.
  @module Tools/Filer
*/

//

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

}

//

let _ = _global_.wTools;
let Parent = null;
let Self = wFiler;
function wFiler( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Filer';

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
  let filer = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let logger = filer.logger = new _.Logger({ output : _global_.logger, name : 'filer' });

  _.workpiece.initFields( filer );
  Object.preventExtensions( filer );

  _.assert( logger === filer.logger );

  if( o )
  filer.copy( o );

}

//

function unform()
{
  let filer = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !!filer.formed );

  /* begin */

  /* end */

  filer.formed = 0;
  return filer;
}

//

function form()
{
  let filer = this;

  if( filer.formed >= 1 )
  return filer;

  filer.formAssociates();

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !filer.formed );

  /* begin */

  /* end */

  filer.formed = 1;
  return filer;
}

//

function formAssociates()
{
  let filer = this;
  let logger = filer.logger;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !filer.formed );
  _.assert( !!logger );
  _.assert( logger.verbosity === filer.verbosity );

  if( !filer.fileProvider )
  {

    let hub = _.FileProvider.System({ providers : [] });

    _.FileProvider.Git().providerRegisterTo( hub );
    _.FileProvider.Npm().providerRegisterTo( hub );
    _.FileProvider.Http().providerRegisterTo( hub );
    _.FileProvider.HardDrive().providerRegisterTo( hub );
    hub.defaultProvider = hub.providersWithProtocolMap.hd;
    filer.fileProvider = hub;
    _.assert( !!hub.defaultProvider );

  }

  let logger2 = new _.Logger({ output : logger, name : 'filer.providers' });

  filer.fileProvider.logger = logger2;
  for( var f in filer.fileProvider.providersWithProtocolMap )
  {
    let fileProvider = filer.fileProvider.providersWithProtocolMap[ f ];
    fileProvider.logger = logger2;
  }

  _.assert( filer.fileProvider.logger === logger2 );
  _.assert( logger.verbosity === filer.verbosity );
  _.assert( filer.fileProvider.logger !== filer.logger );

  filer._verbosityChange();

  _.assert( logger2.verbosity <= logger.verbosity );
}

// --
// etc
// --

function _verbosityChange()
{
  let filer = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( !filer.fileProvider || filer.fileProvider.logger !== filer.logger );

  if( filer.fileProvider )
  filer.fileProvider.verbosity = filer.verbosity-2;

}

//

function vcsProviderFor( o )
{
  let filer = this;
  let fileProvider = filer.fileProvider;
  let path = fileProvider.path;

  if( !_.mapIs( o ) )
  o = { filePath : o }

  _.assert( arguments.length === 1 );
  _.routineOptions( vcsProviderFor, o );
  _.assert( !!filer.formed );

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
  let fileProvider = self.fileProvider;
  let path = fileProvider.path;

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
  logger.log( ' * Linking', _.toStr( self.basePath ) );

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

let Extend =
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
  extend : Extend,
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
