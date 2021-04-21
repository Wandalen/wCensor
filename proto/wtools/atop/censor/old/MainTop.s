( function _MainTop_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  require( './MainBase.s' );

}

//

const _ = _global_.wTools;
const Parent = _.Censor;
const Self = wCensorCli;
function wCensorCli( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'CensorCli';

// --
// exec
// --

function Exec()
{
  let censor = new this.Self();
  return censor.exec();
}

//

function exec()
{
  let censor = this;

  censor.formAssociates();

  _.assert( _.instanceIs( censor ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  let logger = censor.logger;
  const fileProvider = censor.fileProvider;
  let appArgs = _.process.input({ keyValDelimeter : 0 });
  let ca = censor._commandsMake();

  return ca.programPerform({ program : appArgs.original });
  // return ca.appArgsPerform({ appArgs });
}

// --
// commands
// --

function _commandsMake()
{
  let censor = this;
  let logger = censor.logger;
  const fileProvider = censor.fileProvider;
  let appArgs = _.process.input();

  _.assert( _.instanceIs( censor ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  let commands =
  {

    'help' :                    { ro : _.routineJoin( censor, censor.commandHelp ), h : 'Get help.' },
    'imply' :                   { ro : _.routineJoin( censor, censor.commandImply ), h : 'Change state or imply value of a variable.' },

  }

  let ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands,
    commandPrefix : 'node ',
    logger : censor.logger,
  })

  _.assert( ca.logger === censor.logger );
  _.assert( ca.verbosity === censor.verbosity );

  //censor._commandsConfigAdd( ca );

  ca.form();

  return ca;
}


//

function commandHelp( e )
{
  let censor = this;
  let ca = e.aggregator;
  let logger = censor.logger;

  ca._commandHelp( e );

  if( !e.commandName )
  {
    _.assert( 0 );
  }

}

//

function commandImply( e )
{
  let censor = this;
  let ca = e.aggregator;
  let logger = censor.logger;

  let namesMap =
  {
    v : 'verbosity',
    verbosity : 'verbosity',
    beeping : 'beeping',
  }

  let request = censor.Resolver.strRequestParse( e.instructionArgument );

  _.process.inputReadTo
  ({
    dst : censor,
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

let Extension =
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
  extend : Extension,
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
