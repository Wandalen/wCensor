( function _Cui_s_( )
{

'use strict';

//

let _ = _global_.wTools;
let Parent = null;
let Self = wCensorCui;
function wCensorCui( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Cui';

// --
// inter
// --

function init( o )
{
  let cui = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( cui );
  Object.preventExtensions( cui );

  if( o )
  cui.copy( o );

}

//

function Exec()
{
  let cui = new this.Self();
  return cui.exec();
}

//

function exec()
{
  let cui = this;

  _.assert( arguments.length === 0 );

  let appArgs = _.process.args();
  let ca = cui._commandsMake();

  return _.Consequence
  .Try( () =>
  {
    return ca.programPerform({ program : appArgs.original });
    // return ca.appArgsPerform({ appArgs });
  })
  .catch( ( err ) =>
  {
    _.process.exitCode( -1 );
    logger.log( _.errOnce( err ) );
    _.procedure.terminationBegin();
    _.process.exit();
    return err;
  });
}

// --
// commands
// --

function _commandsMake()
{
  let cui = this;
  let appArgs = _.process.args();

  _.assert( _.instanceIs( cui ) );
  _.assert( arguments.length === 0 );

  let commands =
  {
    'help' :              { e : _.routineJoin( cui, cui.commandHelp )          },
    'version' :           { e : _.routineJoin( cui, cui.commandVersion )       },
    // 'imply' :             { e : _.routineJoin( cui, cui.commandImply )         },
    'storage reset' :     { e : _.routineJoin( cui, cui.commandStorageReset )  },
    'storage print' :     { e : _.routineJoin( cui, cui.commandStoragePrint )  },
    'status' :            { e : _.routineJoin( cui, cui.commandStatus )        },
    'replace' :           { e : _.routineJoin( cui, cui.commandReplace )       },
    'hlink' :             { e : _.routineJoin( cui, cui.commandHlink )         },
    'do' :                { e : _.routineJoin( cui, cui.commandDo )            },
    'redo' :              { e : _.routineJoin( cui, cui.commandRedo )          },
    'undo' :              { e : _.routineJoin( cui, cui.commandUndo )          },
  }

  let ca = _.CommandsAggregator
  ({
    basePath : _.path.current(),
    commands,
    commandPrefix : 'node ',
    commandsImplicitDelimiting : 1,
  })

  ca.form();

  return ca;
}

//

function _command_pre( routine, args )
{

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );

  let e = args[ 0 ];

  _.sure( _.mapIs( e.propertiesMap ), () => 'Expects map, but got ' + _.toStrShort( e.propertiesMap ) );
  _.sureMapHasOnly( e.propertiesMap, routine.commandProperties, `Command does not expect options:` );

  if( routine.commandProperties.v )
  if( e.propertiesMap.v !== undefined )
  {
    e.propertiesMap.verbosity = e.propertiesMap.v;
    delete e.propertiesMap.v;
  }

  return e;
}

//

function commandHelp( e )
{
  let cui = this;
  let ca = e.ca;

  ca._commandHelp( e );

  return cui;
}

commandHelp.hint = 'Get help.';

//

function commandVersion( e )
{
  let cui = this;
  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'wcensor!alpha',
  });
}

commandVersion.hint = 'Get information about version.';

// //
//
// function commandImply( e )
// {
//   let cui = this;
//   let ca = e.ca;
//   let isolated = ca.commandIsolateSecondFromArgument( e.commandArgument );
//
//   _.assert( !!isolated );
//   _.assert( 0, 'not tested' );
//
//   let request = _.strRequestParse( isolated.argument );
//
//   let namesMap =
//   {
//     v : 'verbosity',
//     verbosity : 'verbosity',
//   }
//
//   if( request.map.v !== undefined )
//   {
//     request.map.verbosity = request.map.v;
//     delete request.map.v;
//   }
//
//   _.process.argsReadTo
//   ({
//     dst : implied,
//     propertiesMap : request.map,
//     namesMap,
//   });
//
// }
//
// commandImply.hint = 'Change state or imply value of a variable.';
// commandImply.commandProperties =
// {
//   verbosity : 'Level of verbosity.',
//   v : 'Level of verbosity.',
// }

//

function commandStorageReset( e )
{
  let cui = this;
  let ca = e.ca;
  cui._command_pre( commandStorageReset, arguments );
  return _.censor.storageReset( e.propertiesMap );
}

commandStorageReset.hint = 'Delete current state forgetting everything.';
commandStorageReset.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
}

//

function commandStoragePrint( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandStoragePrint, arguments );
  let read = _.censor.storageRead( e.propertiesMap );

  logger.log( read );

}

commandStoragePrint.hint = 'Print content of storage file.';
commandStoragePrint.commandProperties =
{
}

//

function commandStatus( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandStatus, arguments );

  let status = _.censor.status( e.propertiesMap );

  logger.log( _.toStrNice( status ) );

}

commandStatus.hint = 'Get status of the current state.';
commandStatus.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
}

//

function commandReplace( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandReplace, arguments );
  op.logger = 1;

  return _.censor.filesReplace( op );
}

commandReplace.hint = 'Replace text in files.';
commandReplace.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  basePath : 'Base path of directory to look. Default = current path.',
  filePath : 'File path or glob to files to edit.',
  ins : 'Text to find in files to replace by {- sub -}.',
  sub : 'Text to put instead of ins.',
}

//

function commandHlink( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandHlink, arguments );
  op.logger = 1;

  if( op.verbosity === undefined )
  op.verbosity = 3;

  if( e.subject )
  op.basePath = _.arrayAppendArrays( _.arrayAs( e.subject ), op.basePath ? _.arrayAs( op.basePath ) : [] );

  if( !op.basePath )
  op.basePath = '.';

  op.basePath = _.path.s.resolve( op.basePath );

  return _.censor.filesHardLink( op );
}

commandHlink.hint = 'Hard links files with identical content in specified directory.';
commandHlink.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3.',
  v : 'Level of verbosity. Default = 3.',
  basePath : 'Base path to look for files. Default = current path.',
  includingPath : 'Glob or path to filter in.',
  excludingPath : 'Glob or path to filter out.',
  withHlink : 'To use path::hlink defined in config at ~/.censor/config.yaml. Default : true.'
}

//

function commandDo( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandDo, arguments );

  _.sure
  (
    e.subject === '',
    () => `Command ${e.subjectDescriptor.words.join( e.ca.lookingDelimeter )} does not expect subject`
    + `, but got "${e.subject}"`
  );

  op.logger = 1;

  if( op.d !== undefined )
  {
    op.depth = op.d;
    delete op.d;
  }

  return _.censor.do( op );
}

commandDo.hint = 'Do actions planned earlier. Alias of command redo.';
commandDo.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to do. Zero for no limit. Default = 0.',
  d : 'How many action to do. Zero for no limit. Default = 0.',
}

//

function commandRedo( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandRedo, arguments );

  _.sure
  (
    e.subject === '',
    () => `Command ${e.subjectDescriptor.words.join( e.ca.lookingDelimeter )} does not expect subject`
    + `, but got "${e.subject}"`
  );

  op.logger = 1;

  if( op.d !== undefined )
  {
    op.depth = op.d;
    delete op.d;
  }

  return _.censor.redo( op );
}

commandRedo.hint = 'Do actions planned earlier. Alias of command do.';
commandRedo.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to redo. Zero for no limit. Default = 0.',
  d : 'How many action to do. Zero for no limit. Default = 0.',
}

//

function commandUndo( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandUndo, arguments );

  _.sure
  (
    e.subject === '',
    () => `Command ${e.subjectDescriptor.words.join( e.ca.lookingDelimeter )} does not expect subject`
    + `, but got "${e.subject}"`
  );

  op.logger = 1;

  if( op.d !== undefined )
  {
    op.depth = op.d;
    delete op.d;
  }

  if( op.verbosity === undefined )
  op.verbosity = 3;

  return _.censor.undo( op );
}

commandUndo.hint = 'Undo an action done earlier.';
commandUndo.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to undo. Zero for no limit. Default = 0.',
  d : 'How many action to undo. Zero for no limit. Default = 0.',
}

// --
// relations
// --

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
  implied : _.define.own( {} ),
}

let Statics =
{
  Exec,
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

  init,
  Exec,
  exec,

  // commands

  _commandsMake,
  _command_pre,

  commandHelp,
  commandVersion, /* qqq : cover */
  // commandImply,

  // storage

  commandStorageReset,
  commandStoragePrint,
  commandStatus,

  // operation

  commandReplace,
  commandHlink, /* xxx : marry hlink with redo */

  // do

  commandDo,
  commandRedo,
  commandUndo,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.censor[ Self.shortName ] = Self;
if( !module.parent )
Self.Exec();

})();
