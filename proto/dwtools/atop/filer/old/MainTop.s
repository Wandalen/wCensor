( function _MainTop_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  require( './MainBase.s' );

}

//

let _ = _global_.wTools;
let Parent = _.Filer;
let Self = wFilerCli;
function wFilerCli( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FilerCli';

// --
// exec
// --

function Exec()
{
  let filer = new this.Self();
  return filer.exec();
}

//

function exec()
{
  let filer = this;

  filer.formAssociates();

  _.assert( _.instanceIs( filer ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  let logger = filer.logger;
  let fileProvider = filer.fileProvider;
  let appArgs = _.process.args({ keyValDelimeter : 0 });
  let ca = filer._commandsMake();

  return ca.appArgsPerform({ appArgs });
}

// --
// commands
// --

function _commandsMake()
{
  let filer = this;
  let logger = filer.logger;
  let fileProvider = filer.fileProvider;
  let appArgs = _.process.args();

  _.assert( _.instanceIs( filer ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  let commands =
  {

    'help' :                    { e : _.routineJoin( filer, filer.commandHelp ),                        h : 'Get help.' },
    'imply' :                   { e : _.routineJoin( filer, filer.commandImply ),                       h : 'Change state or imply value of a variable.' },

  }

  let ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands,
    commandPrefix : 'node ',
    logger : filer.logger,
  })

  _.assert( ca.logger === filer.logger );
  _.assert( ca.verbosity === filer.verbosity );

  //filer._commandsConfigAdd( ca );

  ca.form();

  return ca;
}


//

function commandHelp( e )
{
  let filer = this;
  let ca = e.ca;
  let logger = filer.logger;

  ca._commandHelp( e );

  if( !e.commandName )
  {
    _.assert( 0 );
  }

}

//

function commandImply( e )
{
  let filer = this;
  let ca = e.ca;
  let logger = filer.logger;

  let namesMap =
  {
    v : 'verbosity',
    verbosity : 'verbosity',
    beeping : 'beeping',
  }

  let request = filer.Resolver.strRequestParse( e.commandArgument );

  _.process.argsReadTo
  ({
    dst : filer,
    propertiesMap : request.map,
    namesMap,
  });

}

// --
// relations
// --

let Composes =
{
  beeping : 0,
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  Exec,
}

let Forbids =
{
}

let Accessors =
{
}

// --
// declare
// --

let Extend =
{

  // exec

  Exec,
  exec,

  // commands

  _commandsMake,
  commandHelp,
  commandImply,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

//_.EventHandler.mixin( Self );
//_.Instancing.mixin( Self );
//_.StateStorage.mixin( Self );
//_.StateSession.mixin( Self );
//_.CommandsConfig.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
wTools[ Self.shortName ] = Self;

if( !module.parent )
Self.Exec();

})();
