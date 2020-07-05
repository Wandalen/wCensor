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
    'help' :                    { e : _.routineJoin( cui, cui.commandHelp )                 },
    'version' :                 { e : _.routineJoin( cui, cui.commandVersion )              },
    // 'imply' :                { e : _.routineJoin( cui, cui.commandImply )                },
    'storage.reset' :           { e : _.routineJoin( cui, cui.commandStorageReset )         },
    'storage.log' :             { e : _.routineJoin( cui, cui.commandStorageLog )           },
    'profile.reset' :           { e : _.routineJoin( cui, cui.commandProfileReset )         },
    'profile.log' :             { e : _.routineJoin( cui, cui.commandProfileLog )           },
    'config.reset' :            { e : _.routineJoin( cui, cui.commandConfigReset )          },
    'config.log' :              { e : _.routineJoin( cui, cui.commandConfigLog )            },
    'arrangement.reset' :       { e : _.routineJoin( cui, cui.commandArrangementReset )     },
    'arrangement.log' :         { e : _.routineJoin( cui, cui.commandArrangementLog )       },
    'replace' :                 { e : _.routineJoin( cui, cui.commandReplace )              },
    'hlink' :                   { e : _.routineJoin( cui, cui.commandHlink )                },
    'do' :                      { e : _.routineJoin( cui, cui.commandDo )                   },
    'redo' :                    { e : _.routineJoin( cui, cui.commandRedo )                 },
    'undo' :                    { e : _.routineJoin( cui, cui.commandUndo )                 },
    'status' :                  { e : _.routineJoin( cui, cui.commandStatus )               },
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
  if( routine.commandProperties )
  _.sureMapHasOnly( e.propertiesMap, routine.commandProperties, `Command does not expect options:` );

  debugger;
  if( _.boolLikeFalse( routine.commandSubjectHint ) )
  if( e.subject.trim() !== '' )
  throw _.errBrief
  (
    `Command .${e.subjectDescriptor.phraseDescriptor.phrase} does not expect subject`
    + `, but got "${e.subject}"`
  );

  if( routine.commandProperties && routine.commandProperties.v )
  if( e.propertiesMap.v !== undefined )
  {
    e.propertiesMap.verbosity = e.propertiesMap.v;
    delete e.propertiesMap.v;
  }

  if( routine.commandProperties && routine.commandProperties.profile )
  if( e.propertiesMap.profile !== undefined )
  {
    e.propertiesMap.profileDir = e.propertiesMap.profile;
    delete e.propertiesMap.profile;
  }

  if( routine.commandProperties && routine.commandProperties.storage )
  if( e.propertiesMap.storage !== undefined )
  {
    e.propertiesMap.storageTerminal = e.propertiesMap.storage;
    delete e.propertiesMap.storage;
  }

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

  cui._command_pre( commandVersion, arguments );

  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'wcensor!alpha',
  });
}

commandVersion.hint = 'Get information about version.';
commandVersion.commandSubjectHint = false;

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

commandStorageReset.hint = 'Delete the storage including all profiles and arrangements, forgetting everything.';
commandStorageReset.commandSubjectHint = false;
commandStorageReset.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
}

//

function commandStorageLog( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandStorageLog, arguments );

  return _.censor.storageLog( e.propertiesMap );
}

commandStorageLog.hint = 'Log content of all files of the storage.';
commandStorageLog.commandSubjectHint = false;
commandStorageLog.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
}

//

function commandProfileReset( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandProfileReset, arguments );

  return _.censor.profileReset( e.propertiesMap );
}

commandProfileReset.hint = 'Delete the profile its arrangements.';
commandProfileReset.commandSubjectHint = false;
commandProfileReset.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandProfileLog( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandProfileLog, arguments );

  return _.censor.profileLog( e.propertiesMap );
}

commandProfileLog.hint = 'Log content of all files of the profile.';
commandProfileLog.commandSubjectHint = false;
commandProfileLog.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandConfigReset( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandConfigReset, arguments );

  return _.censor.configReset( e.propertiesMap );
}

commandConfigReset.hint = 'Delete current config.';
commandConfigReset.commandSubjectHint = false;
commandConfigReset.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandConfigLog( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandConfigLog, arguments );

  return _.censor.configLog( e.propertiesMap );
}

commandConfigLog.hint = 'Log content of config file.';
commandConfigLog.commandSubjectHint = false;
commandConfigLog.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandArrangementReset( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandArrangementReset, arguments );

  return _.censor.arrangementReset( e.propertiesMap );
}

commandArrangementReset.hint = 'Delete current arrangement.';
commandArrangementReset.commandSubjectHint = false;
commandArrangementReset.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandArrangementLog( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_pre( commandArrangementLog, arguments );

  return _.censor.arrangementLog( e.propertiesMap );
}

commandArrangementLog.hint = 'Log content of arrangment file.';
commandArrangementLog.commandSubjectHint = false;
commandArrangementLog.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandReplace( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandReplace, arguments );

  op.logger = 1;
  op.resetting = 1;

  return _.censor.filesReplace( op );
}

commandReplace.hint = 'Replace text in files.';
commandReplace.commandSubjectHint = false;
commandReplace.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  basePath : 'Base path of directory to look. Default = current path.',
  filePath : 'File path or glob to files to edit.',
  ins : 'Text to find in files to replace by {- sub -}.',
  sub : 'Text to put instead of ins.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
  resetting : 'Reset redo/undo list. Default is true',
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

commandHlink.hint = 'Hard links all files with identical content in specified directories.';
commandHlink.commandSubjectHint = 'basePath if specified';
commandHlink.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3.',
  v : 'Level of verbosity. Default = 3.',
  basePath : 'Base path to look for files. Default = current path.',
  includingPath : 'Glob or path to filter in.',
  excludingPath : 'Glob or path to filter out.',
  withHlink : 'To use path::hlink defined in config at ~/.censor/config.yaml. Default : true.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandDo( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandDo, arguments );

  op.logger = 1;

  if( op.d !== undefined )
  {
    op.depth = op.d;
    delete op.d;
  }

  return _.censor.do( op );
}

commandDo.hint = 'Do actions planned earlier. Alias of command redo.';
commandDo.commandSubjectHint = false;
commandDo.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to do. Zero for no limit. Default = 0.',
  d : 'How many action to do. Zero for no limit. Default = 0.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandRedo( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandRedo, arguments );

  op.logger = 1;

  if( op.d !== undefined )
  {
    op.depth = op.d;
    delete op.d;
  }

  return _.censor.redo( op );
}

commandRedo.hint = 'Do actions planned earlier. Alias of command do.';
commandRedo.commandSubjectHint = false;
commandRedo.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to redo. Zero for no limit. Default = 0.',
  d : 'How many action to do. Zero for no limit. Default = 0.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandUndo( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_pre( commandUndo, arguments );

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
commandUndo.commandSubjectHint = false;
commandUndo.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to undo. Zero for no limit. Default = 0.',
  d : 'How many action to undo. Zero for no limit. Default = 0.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
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
commandStatus.commandSubjectHint = false;
commandStatus.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
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

  commandStorageReset, /* qqq : cover */
  commandStorageLog, /* qqq : cover */
  commandProfileReset, /* qqq : cover */
  commandProfileLog, /* qqq : cover */
  commandConfigReset, /* qqq : cover */
  commandConfigLog, /* qqq : cover */
  commandArrangementReset, /* qqq : cover */
  commandArrangementLog, /* qqq : cover */

  // operation

  commandReplace,
  commandHlink, /* xxx : marry hlink with redo */

  // do

  commandDo,
  commandRedo,
  commandUndo,
  commandStatus,

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
