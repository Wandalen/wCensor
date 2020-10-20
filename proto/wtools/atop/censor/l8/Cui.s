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

  let appArgs = _.process.input();
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
    logger.error( _.errOnce( err ) );
    _.procedure.terminationBegin();
    _.process.exit();
    return err;
  });
}

// --
// meta commands
// --

function _commandsMake()
{
  let cui = this;
  let appArgs = _.process.input();

  _.assert( _.instanceIs( cui ) );
  _.assert( arguments.length === 0 );

  let commands =
  {
    'help' :                    { e : _.routineJoin( cui, cui.commandHelp )                 },
    'version' :                 { e : _.routineJoin( cui, cui.commandVersion )              },
    'imply' :                   { e : _.routineJoin( cui, cui.commandImply )                },
    'storage.del' :             { e : _.routineJoin( cui, cui.commandStorageDel )           },
    'storage.log' :             { e : _.routineJoin( cui, cui.commandStorageLog )           },
    'profile.del' :             { e : _.routineJoin( cui, cui.commandProfileDel )           },
    'profile.log' :             { e : _.routineJoin( cui, cui.commandProfileLog )           },
    'config.log' :              { e : _.routineJoin( cui, cui.commandConfigLog )            },
    'config.get' :              { e : _.routineJoin( cui, cui.commandConfigGet )            },
    'config.set' :              { e : _.routineJoin( cui, cui.commandConfigSet )            },
    'config.del' :              { e : _.routineJoin( cui, cui.commandConfigDel )            },
    'arrangement.del' :         { e : _.routineJoin( cui, cui.commandArrangementDel )       },
    'arrangement.log' :         { e : _.routineJoin( cui, cui.commandArrangementLog )       },
    'replace' :                 { e : _.routineJoin( cui, cui.commandReplace )              },
    'hlink' :                   { e : _.routineJoin( cui, cui.commandHlink )                },
    'entry.add' :               { e : _.routineJoin( cui, cui.commandEntryAdd )             },
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

function _command_head( o )
{
  let cui = this;

  if( arguments.length === 2 )
  o = { routine : arguments[ 0 ], args : arguments[ 1 ] }

  _.routineOptions( _command_head, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( o.args.length === 1 );

  let e = o.args[ 0 ];

  if( o.propertiesMapAsProperty )
  {
    let propertiesMap = Object.create( null );
    if( e.propertiesMap )
    propertiesMap[ o.propertiesMapAsProperty ] = e.propertiesMap;
    e.propertiesMap = propertiesMap;
  }

  if( cui.implied )
  {
    if( o.routine.commandProperties )
    _.mapExtend( e.propertiesMap, _.mapOnly( cui.implied, o.routine.commandProperties ) );
    else
    _.mapExtend( e.propertiesMap, cui.implied );
  }

  _.sure( _.mapIs( e.propertiesMap ), () => 'Expects map, but got ' + _.toStrShort( e.propertiesMap ) );
  if( o.routine.commandProperties )
  _.sureMapHasOnly( e.propertiesMap, o.routine.commandProperties, `Command does not expect options:` );

  if( _.boolLikeFalse( o.routine.commandSubjectHint ) )
  if( e.subject.trim() !== '' )
  throw _.errBrief
  (
    `Command .${e.subjectDescriptor.phraseDescriptor.phrase} does not expect subject`
    + `, but got "${e.subject}"`
  );

  if( o.routine.commandProperties && o.routine.commandProperties.v )
  if( e.propertiesMap.v !== undefined )
  {
    e.propertiesMap.verbosity = e.propertiesMap.v;
    delete e.propertiesMap.v;
  }

  if( o.routine.commandProperties && o.routine.commandProperties.profile )
  if( e.propertiesMap.profile !== undefined )
  {
    e.propertiesMap.profileDir = e.propertiesMap.profile;
    delete e.propertiesMap.profile;
  }

  if( o.routine.commandProperties && o.routine.commandProperties.storage )
  if( e.propertiesMap.storage !== undefined )
  {
    e.propertiesMap.storageTerminal = e.propertiesMap.storage;
    delete e.propertiesMap.storage;
  }

}

_command_head.defaults =
{
  routine : null,
  args : null,
  propertiesMapAsProperty : 0,
}

// --
// general commands
// --

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

  cui._command_head( commandVersion, arguments );

  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'wcensor!alpha',
  });
}

commandVersion.hint = 'Get information about version.';
commandVersion.commandSubjectHint = false;

//

function commandImply( e )
{
  let cui = this;
  let ca = e.ca;

  cui.implied = null;

  cui._command_head( commandImply, arguments );

  cui.implied = e.propertiesMap;

}

commandImply.hint = 'Change state or imply value of a variable.';
commandImply.commandSubjectHint = false;

// --
// storage commands
// --

function commandStorageDel( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head( commandStorageDel, arguments );

  return _.censor.storageDel( e.propertiesMap );
}

commandStorageDel.hint = 'Delete the storage including all profiles and arrangements, forgetting everything. Reset defaults.';
commandStorageDel.commandSubjectHint = false;
commandStorageDel.commandProperties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
}

//

function commandStorageLog( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head( commandStorageLog, arguments );

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

function commandProfileDel( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head( commandProfileDel, arguments );

  return _.censor.profileDel( e.propertiesMap );
}

commandProfileDel.hint = 'Delete the profile its arrangements.';
commandProfileDel.commandSubjectHint = false;
commandProfileDel.commandProperties =
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

  cui._command_head( commandProfileLog, arguments );

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

function commandConfigLog( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head( commandConfigLog, arguments );

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

function commandConfigGet( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head({ routine : commandConfigGet, args : arguments });

  if( !e.propertiesMap.selector )
  e.propertiesMap.selector = [];
  else
  e.propertiesMap.selector = _.arrayAs( e.propertiesMap.selector );

  if( e.subject )
  {
    _.arrayAppendArray( e.propertiesMap.selector, _.strSplitNonPreserving( e.subject ) );
  }

  _.sure
  (
    _.strsAreAll( e.propertiesMap.selector ),
    'Expects key or array of keys to read'
  );

  logger.log( _.censor.configGet( e.propertiesMap ) );

}

commandConfigGet.hint = 'Read one or several variables of config.';
commandConfigGet.commandSubjectHint = 'Key or array of keys to read. Could be selectors.';
commandConfigGet.commandProperties =
{
  selector : 'Key or array of keys to read. Could be selectors.',
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandConfigSet( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head({ routine : commandConfigSet, args : arguments, propertiesMapAsProperty : 'set' });

  _.sure
  (
    _.mapIs( e.propertiesMap.set ) && _.lengthOf( e.propertiesMap.set ),
    'Expects one or more pair "key:value" to append to the config'
  );

  return _.censor.configSet( e.propertiesMap );
}

commandConfigSet.hint = 'Set one or several variables of config persistently. Does not delete variables config have had before setting, but may rewrite them by new values.';
commandConfigSet.commandSubjectHint = false;
commandConfigSet.commandProperties =
{
  set : 'Map of pairs "key:value" to set. Key is selector.',
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandConfigDel( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head({ routine : commandConfigDel, args : arguments });

  if( !e.propertiesMap.selector )
  e.propertiesMap.selector = [];
  else
  e.propertiesMap.selector = _.arrayAs( e.propertiesMap.selector );

  if( e.subject )
  {
    _.arrayAppendArray( e.propertiesMap.selector, _.strSplitNonPreserving( e.subject ) );
  }

  // _.sure
  // (
  //   _.strsAreAll( e.propertiesMap.selector ),
  //   'Expects key or array of keys to delete'
  // );

  return _.censor.configDel( e.propertiesMap );
}

commandConfigDel.hint = 'Delete one or several variables of config persistently. Delete whole config if no keys are specified.';
commandConfigDel.commandSubjectHint = 'Key or array of keys to delete. Could be selectors.';
commandConfigDel.commandProperties =
{
  selector : 'Key or array of keys to delete. Could be selectors.',
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

// //
//
// function commandConfigDel( e )
// {
//   let cui = this;
//   let ca = e.ca;
//
//   cui._command_head( commandConfigDel, arguments );
//
//   return _.censor.configDel( e.propertiesMap );
// }
//
// commandConfigDel.hint = 'Delete current config.';
// commandConfigDel.commandSubjectHint = false;
// commandConfigDel.commandProperties =
// {
//   verbosity : 'Level of verbosity.',
//   v : 'Level of verbosity.',
//   profile : 'Name of profile to use. Default is "default"',
// }

//

function commandArrangementDel( e )
{
  let cui = this;
  let ca = e.ca;

  cui._command_head( commandArrangementDel, arguments );

  return _.censor.arrangementDel( e.propertiesMap );
}

commandArrangementDel.hint = 'Delete current arrangement.';
commandArrangementDel.commandSubjectHint = false;
commandArrangementDel.commandProperties =
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

  cui._command_head( commandArrangementLog, arguments );

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

// --
// operation commands
// --

function commandReplace( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_head( commandReplace, arguments );

  op.logger = 1;
  op.resetting = 1;

  if( !op.basePath )
  op.basePath = '.';
  op.basePath = _.path.s.resolve( op.basePath );
  if( !op.filePath )
  op.filePath = '**';

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
  resetting : 'Del redo/undo list. Default is true',
  fileSizeLimit : 'Max size of file to read',
  usingTextLink : 'Treat a file as a textlink. Default is 0'
}

//

function commandHlink( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_head( commandHlink, arguments );
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
  withConfigPath : 'To add path::hlink defined in config at ~/.censor/default/config.yaml. Default : true.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandEntryAdd( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_head( commandEntryAdd, arguments );
  op.logger = 1;

  if( op.verbosity === undefined )
  op.verbosity = 3;

  if( e.subject )
  op.appPath = e.subject;
  if( op.appPath )
  op.appPath = _.path.s.resolve( op.appPath );
  if( op.entryDirPath )
  op.entryDirPath = _.path.s.resolve( op.entryDirPath );
  if( op.addingRights !== undefined && !_.numberIs( op.addingRights ) )
  op.addingRights = null;

  return _.censor.systemEntryAdd( op );
}

commandEntryAdd.hint = 'Add entry for application making it available globally on your machine.';
commandEntryAdd.commandSubjectHint = 'Set option appPath if specified';
commandEntryAdd.commandProperties =
{
  verbosity : 'Level of verbosity. Default = 3.',
  v : 'Level of verbosity. Default = 3.',
  entryDirPath : 'Path to directory to put entry. This path should be in evnironment valriable $PATH. If not specified variable "path/entry" of config "~/.censor/default/config.json" used.',
  appPath : 'Path to application for which entry will be added.',
  name : 'Name of entry. If not specified, deduced from appPath.',
  platform : 'Platform. If not specified then add entry of both kind, for Windows and Posix platforms. "windows" for Windows, "posix" for posix OSs, "multiple" for both kind of platforms. By default deduced from current OS.',
  relative : 'Relativize path to application from the entry. Default : 1',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
  prefix : 'Prefix to use to prepend starting of the application. Default is "node ".',
  addingRights : 'Setting rights of the entry file. Default is 0o777.',
  allowingMissed : 'Allowing creating entry on application file which does not exist. Default is 0.',
  allowingNotInPath : 'Allowing creating entry in the entryDirPath which is not in the environment variable $PATH. Default is 0.',
  forcing : 'Allowing ignoring fail of safegaurd checks. Default is 0.',
}

// --
// do commands
// --

function commandDo( e )
{
  let cui = this;
  let ca = e.ca;
  let op = e.propertiesMap;

  cui._command_head( commandDo, arguments );

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

  cui._command_head( commandRedo, arguments );

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

  cui._command_head( commandUndo, arguments );

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

  cui._command_head( commandStatus, arguments );

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

let Extension =
{

  // inter

  init,
  Exec,
  exec,

  // meta commands

  _commandsMake,
  _command_head,

  // general commands

  commandHelp,
  commandVersion, /* qqq : cover */
  commandImply,

  // storage commands

  commandStorageDel, /* qqq : cover | aaa : Done. Yevhen S.*/
  commandStorageLog, /* qqq : cover | aaa : Done. Yevhen S.*/
  commandProfileDel, /* qqq : cover | aaa : Done. Yevhen S.*/
  commandProfileLog, /* qqq : cover | aaa : Done. Yevhen S.*/
  commandConfigLog, /* qqq : cover | aaa : Done. Yevhen S.*/
  commandConfigGet,
  commandConfigSet,
  commandConfigDel,
  commandArrangementDel, /* qqq : cover | aaa : Done. Yevhen S.*/
  commandArrangementLog, /* qqq : cover | aaa : Done. Yevhen S.*/

  // operation commands

  commandReplace,
  commandHlink, /* xxx : marry hlink with redo */
  commandEntryAdd,

  // do commands

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
  extend : Extension,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.censor[ Self.shortName ] = Self;
if( !module.parent )
Self.Exec();

})();
