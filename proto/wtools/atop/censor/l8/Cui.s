( function _Cui_s_( )
{

'use strict';

//

const _ = _global_.wTools;
const Parent = null;
const Self = wCensorCui;
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
    'help' :                    { ro : _.routineJoin( cui, cui.commandHelp ) },
    'version' :                 { ro : _.routineJoin( cui, cui.commandVersion ) },
    'imply' :                   { ro : _.routineJoin( cui, cui.commandImply ) },

    'storage.del' :             { ro : _.routineJoin( cui, cui.commandStorageDel ) },
    'storage.log' :             { ro : _.routineJoin( cui, cui.commandStorageLog ) },
    'profile.del' :             { ro : _.routineJoin( cui, cui.commandProfileDel ) },
    'profile.log' :             { ro : _.routineJoin( cui, cui.commandProfileLog ) },
    'config.log' :              { ro : _.routineJoin( cui, cui.commandConfigLog ) },
    'config.get' :              { ro : _.routineJoin( cui, cui.commandConfigGet ) },
    'config.set' :              { ro : _.routineJoin( cui, cui.commandConfigSet ) },
    'config.del' :              { ro : _.routineJoin( cui, cui.commandConfigDel ) },
    'arrangement.del' :         { ro : _.routineJoin( cui, cui.commandArrangementDel ) },
    'arrangement.log' :         { ro : _.routineJoin( cui, cui.commandArrangementLog ) },
    'identity list' :           { ro : _.routineJoin( cui, cui.commandIdentityList ) },
    'identity copy' :           { ro : _.routineJoin( cui, cui.commandIdentityCopy ) },
    'identity new' :            { ro : _.routineJoin( cui, cui.commandIdentityNew ) },
    'git identity new' :        { ro : _.routineJoin( cui, cui.commandGitIdentityNew ) },
    'identity remove' :         { ro : _.routineJoin( cui, cui.commandIdentityRemove ) },

    'replace' :                 { ro : _.routineJoin( cui, cui.commandReplace ) },
    'listing.reorder' :         { ro : _.routineJoin( cui, cui.commandListingReorder ) },
    'listing.squeeze' :         { ro : _.routineJoin( cui, cui.commandListingSqueeze ) },

    'hlink' :                   { ro : _.routineJoin( cui, cui.commandHlink ) },
    'entry.add' :               { ro : _.routineJoin( cui, cui.commandEntryAdd ) },
    'do' :                      { ro : _.routineJoin( cui, cui.commandDo ) },
    'redo' :                    { ro : _.routineJoin( cui, cui.commandRedo ) },
    'undo' :                    { ro : _.routineJoin( cui, cui.commandUndo ) },
    'status' :                  { ro : _.routineJoin( cui, cui.commandStatus ) },
  }

  let ca = _.CommandsAggregator
  ({
    basePath : _.path.current(),
    commands,
    // commandPrefix : 'node ',
    commandsImplicitDelimiting : 1,
  })

  ca.form();

  ca.logger.verbosity = 0;

  return ca;
}

//

function _command_head( o )
{
  let cui = this;

  if( arguments.length === 2 )
  o = { routine : arguments[ 0 ], args : arguments[ 1 ] }

  _.routine.options_( _command_head, o );
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
    if( o.routine.command.properties )
    _.props.extend( e.propertiesMap, _.mapOnly_( null, cui.implied, o.routine.command.properties ) );
    else
    _.props.extend( e.propertiesMap, cui.implied );
  }

  _.sure( _.mapIs( e.propertiesMap ), () => 'Expects map, but got ' + _.entity.exportStringDiagnosticShallow( e.propertiesMap ) );
  if( o.routine.command.properties )
  _.map.sureHasOnly( e.propertiesMap, o.routine.command.properties, `Command does not expect options:` );

  if( _.boolLikeFalse( o.routine.command.subjectHint ) )
  if( e.subject.trim() !== '' )
  throw _.errBrief
  (
    `Command .${e.phraseDescriptor.phrase} does not expect subject`
    + `, but got "${e.subject}"`
  );

  if( o.routine.command.properties && o.routine.command.properties.v )
  if( e.propertiesMap.v !== undefined )
  {
    e.propertiesMap.verbosity = e.propertiesMap.v;
    delete e.propertiesMap.v;
  }

  if( o.routine.command.properties && o.routine.command.properties.profile )
  if( e.propertiesMap.profile !== undefined )
  {
    e.propertiesMap.profileDir = e.propertiesMap.profile;
    delete e.propertiesMap.profile;
  }

  if( o.routine.command.properties && o.routine.command.properties.storage )
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
  let ca = e.aggregator;

  ca._commandHelp( e );

  return cui;
}

var command = commandHelp.command = Object.create( null );
command.hint = 'Get help.';

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

var command = commandVersion.command = Object.create( null );
command.hint = 'Get information about version.';
command.subjectHint = false;

//

function commandImply( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui.implied = null;

  cui._command_head( commandImply, arguments );

  cui.implied = e.propertiesMap;

}

var command = commandImply.command = Object.create( null );
command.hint = 'Change state or imply value of a variable.';
command.subjectHint = false;

// --
// storage commands
// --

function commandStorageDel( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head( commandStorageDel, arguments );

  return _.censor.storageDel( e.propertiesMap );
}

var command = commandStorageDel.command = Object.create( null );
command.hint = 'Delete the storage including all profiles and arrangements, forgetting everything. Reset defaults.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
}

//

function commandStorageLog( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head( commandStorageLog, arguments );

  return _.censor.storageLog( e.propertiesMap );
}

var command = commandStorageLog.command = Object.create( null );
command.hint = 'Log content of all files of the storage.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
}

//

function commandProfileDel( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head( commandProfileDel, arguments );

  return _.censor.profileDel( e.propertiesMap );
}

var command = commandProfileDel.command = Object.create( null );
command.hint = 'Delete the profile its arrangements.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandProfileLog( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head( commandProfileLog, arguments );

  return _.censor.profileLog( e.propertiesMap );
}

var command = commandProfileLog.command = Object.create( null );
command.hint = 'Log content of all files of the profile.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandConfigLog( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head( commandConfigLog, arguments );

  return _.censor.configLog( e.propertiesMap );
}

var command = commandConfigLog.command = Object.create( null );
command.hint = 'Log content of config file.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
}

//

function commandConfigGet( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandConfigGet, args : arguments });

  if( e.propertiesMap.selector )
  e.propertiesMap.selector = _.array.as( e.propertiesMap.selector );
  else
  e.propertiesMap.selector = [];

  // if( !e.propertiesMap.selector )
  // e.propertiesMap.selector = [];
  // else
  // e.propertiesMap.selector = _.array.as( e.propertiesMap.selector );

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

var command = commandConfigGet.command = Object.create( null );
command.hint = 'Read one or several variables of config.';
command.subjectHint = 'Key or array of keys to read. Could be selectors.';
command.properties =
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
  let ca = e.aggregator;

  cui._command_head({ routine : commandConfigSet, args : arguments, propertiesMapAsProperty : 'set' });

  _.sure
  (
    _.mapIs( e.propertiesMap.set ) && _.entity.lengthOf( e.propertiesMap.set ),
    'Expects one or more pair "key:value" to append to the config'
  );

  return _.censor.configSet( e.propertiesMap );
}

var command = commandConfigSet.command = Object.create( null );
command.hint = 'Set one or several variables of config persistently. Does not delete variables config have had before setting, but may rewrite them by new values.';
command.subjectHint = false;
command.properties =
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
  let ca = e.aggregator;

  cui._command_head({ routine : commandConfigDel, args : arguments });

  if( e.propertiesMap.selector )
  e.propertiesMap.selector = _.array.as( e.propertiesMap.selector );
  else
  e.propertiesMap.selector = [];

  // if( !e.propertiesMap.selector )
  // e.propertiesMap.selector = [];
  // else
  // e.propertiesMap.selector = _.array.as( e.propertiesMap.selector );

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

var command = commandConfigDel.command = Object.create( null );
command.hint = 'Delete one or several variables of config persistently. Delete whole config if no keys are specified.';
command.subjectHint = 'Key or array of keys to delete. Could be selectors.';
command.properties =
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
//   let ca = e.aggregator;
//
//   cui._command_head( commandConfigDel, arguments );
//
//   return _.censor.configDel( e.propertiesMap );
// }
//
// var command = commandHelp.command = Object.create( null );
// command.hint = 'Delete current config.';
// command.subjectHint = false;
// command.properties =
// {
//   verbosity : 'Level of verbosity.',
//   v : 'Level of verbosity.',
//   profile : 'Name of profile to use. Default is "default"',
// }

//

function commandArrangementDel( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head( commandArrangementDel, arguments );

  return _.censor.arrangementDel( e.propertiesMap );
}

var command = commandArrangementDel.command = Object.create( null );
command.hint = 'Delete current arrangement.';
command.subjectHint = false;
command.properties =
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
  let ca = e.aggregator;

  cui._command_head( commandArrangementLog, arguments );

  return _.censor.arrangementLog( e.propertiesMap );
}

var command = commandArrangementLog.command = Object.create( null );
command.hint = 'Log content of arrangment file.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandIdentityList( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityList, args : arguments });

  const list =_.censor.identityList( e.propertiesMap );
  logger.log( 'List of identities :' );
  logger.log( _.entity.exportStringNice( list ) );
}

var command = commandIdentityList.command = Object.create( null );
command.hint = 'List all identies.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
};

//

function commandIdentityCopy( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityCopy, args : arguments });

  const identityNames = _.strSplit({ src : e.subject, preservingDelimeters : 0 });
  _.sure( identityNames.length === 2, 'Expects names of src and dst identities' );
  e.propertiesMap.identitySrcName = identityNames[ 0 ];
  e.propertiesMap.identityDstName = identityNames[ 1 ];
  e.propertiesMap = _.mapOnly_( null, e.propertiesMap, _.censor.identityCopy.defaults );
  return _.censor.identityCopy( e.propertiesMap );
}

var command = commandIdentityCopy.command = Object.create( null );
command.hint = 'Copy data of source identity to destination identity.';
command.subjectHint = 'Names of source and destination identities.';
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
};

//

function commandIdentityNew( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityNew, args : arguments, propertiesMapAsProperty : 'identity' });

  _.sure
  (
    _.mapIs( e.propertiesMap.identity ) && _.entity.lengthOf( e.propertiesMap.identity ),
    'Expects one or more pair "key:value" to append to the config'
  );

  e.propertiesMap.identity.name = e.subject;
  e.propertiesMap = _.mapOnly_( null, e.propertiesMap, _.censor.identityNew.defaults );
  return _.censor.identityNew( e.propertiesMap );
}

var command = commandIdentityNew.command = Object.create( null );
command.hint = 'Create new identity. Cannot rewrite existed identities.';
command.subjectHint = 'A name of identity.';
command.properties =
{
  identity : 'Map of pairs "key:value" to set identity.',
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
};

//

function commandGitIdentityNew( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandGitIdentityNew, args : arguments, propertiesMapAsProperty : 'identity' });

  _.sure
  (
    _.mapIs( e.propertiesMap.identity ) && _.entity.lengthOf( e.propertiesMap.identity ),
    'Expects one or more pair "key:value" to append to the config'
  );
  _.sure( !e.propertiesMap.identity.type, 'Expects no property `type`.' );

  e.propertiesMap.identity.name = e.subject;
  e.propertiesMap.identity.type = 'git';
  e.propertiesMap = _.mapOnly_( null, e.propertiesMap, _.censor.identityNew.defaults );
  return _.censor.identityNew( e.propertiesMap );
}

var command = commandGitIdentityNew.command = Object.create( null );
command.hint = 'Create new git identity. Cannot rewrite existed identities.';
command.subjectHint = 'A name of identity.';
command.properties =
{
  identity : 'Map of pairs "key:value" to set identity.',
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
};

//

function commandIdentityRemove( e )
{
  let cui = this;
  let ca = e.aggregator;

  cui._command_head({ routine : commandIdentityRemove, args : arguments });

  e.propertiesMap.selector = e.subject;
  e.propertiesMap = _.mapOnly_( null, e.propertiesMap, _.censor.identityDel.defaults );
  return _.censor.identityDel( e.propertiesMap );
}

var command = commandIdentityRemove.command = Object.create( null );
command.hint = 'Remove identity(es).';
command.subjectHint = 'A name of identity(es) to remove. Could be selectors.';
command.properties =
{
  verbosity : 'Level of verbosity.',
  v : 'Level of verbosity.',
  profile : 'Name of profile to use. Default is "default"',
};

// --
// operation commands
// --

function commandReplace( e )
{
  let cui = this;
  let ca = e.aggregator;
  let op = e.propertiesMap;

  cui._command_head( commandReplace, arguments );

  op.logger = 1;
  // op.resetting = 1;

  if( !op.basePath )
  op.basePath = '.';
  op.basePath = _.path.s.resolve( op.basePath );
  if( !op.filePath )
  op.filePath = '**';

  return _.censor.filesReplace( op );
}

var command = commandReplace.command = Object.create( null );
command.hint = 'Replace text in files.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  basePath : 'Base path of directory to look. Default = current path.',
  filePath : 'File path or glob to files to edit.',
  ins : 'Text to find in files to replace by {- sub -}.',
  sub : 'Text to put instead of ins.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
  resetting : 'Del redo/undo list. Default is false',
  fileSizeLimit : 'Max size of file to read',
  usingTextLink : 'Treat a file as a textlink. Default is 0'
}

//

function commandHlink( e )
{
  let cui = this;
  let ca = e.aggregator;
  let op = e.propertiesMap;

  cui._command_head( commandHlink, arguments );
  op.logger = new _.Logger({ output : logger });

  if( op.verbosity === undefined )
  op.verbosity = 3;

  if( op.verbosity )
  op.logger.verbosity = op.verbosity;
  delete op.verbosity;

  if( e.subject )
  op.basePath = _.arrayAppendArrays( _.array.as( e.subject ), op.basePath ? _.array.as( op.basePath ) : [] );

  if( !op.basePath )
  op.basePath = '.';

  op.basePath = _.path.s.resolve( op.basePath );

  return _.censor.filesHardLink( op );
}

var command = commandHlink.command = Object.create( null );
command.hint = 'Hard links all files with identical content in specified directories.';
command.subjectHint = 'basePath if specified';
command.properties =
{
  verbosity : 'Level of verbosity. Default = 3.',
  v : 'Level of verbosity. Default = 3.',
  basePath : 'Base path to look for files. Default = current path.',
  includingPath : 'Glob or path to filter in.',
  excludingPath : 'Glob or path to filter out.',
  excludingHyphened : 'Glob or path that starts with "-" to filter in/out',
  withShared : 'To add path::hlink defined in config at ~/.censor/default/config.yaml. Default : true.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandEntryAdd( e )
{
  let cui = this;
  let ca = e.aggregator;
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

var command = commandEntryAdd.command = Object.create( null );
command.hint = 'Add entry for application making it available globally on your machine.';
command.subjectHint = 'Set option appPath if specified';
command.properties =
{
  verbosity : 'Level of verbosity. Default = 3.',
  v : 'Level of verbosity. Default = 3.',
  entryDirPath : 'Path to directory to put entry. This path should be in evnironment valriable $PATH. If not specified variable "path/entry" of config "~/.censor/default/config.json" used.',
  appPath : 'Path to application for which entry will be added.',
  name : 'Name of entry. If not specified, deduced from appPath.',
  platform : 'Platform. If not specified then add entry of both kind, for Windows and Posix platforms. "windows" for Windows, "posix" for posix OSs, "multiple" for both kind of platforms. By default deduced from current OS.',
  relative : 'Relativize path to application from the entry. Default : 1',
  // profile : 'Name of profile to use. Default is "default"',
  // session : 'Name of session to use. Default is "default"',
  prefix : 'Prefix to use to prepend starting of the application. Default is "node ".',
  addingRights : 'Setting rights of the entry file. Default is 0o777.',
  allowingMissed : 'Allowing creating entry on application file which does not exist. Default is 0.',
  allowingNotInPath : 'Allowing creating entry in the entryDirPath which is not in the environment variable $PATH. Default is 0.',
  forcing : 'Allowing ignoring fail of safegaurd checks. Default is 0.',
}

//

function commandListingReorder( e )
{
  let cui = this;
  let ca = e.aggregator;
  let op = e.propertiesMap;

  cui._command_head( commandListingReorder, arguments );

  op.dirPath = op.dirPath || _.path.current();

  return _.censor.listingReorder( op );
}

var command = commandListingReorder.command = Object.create( null );
command.hint = 'Reorder a ordered list of files in the directory';
command.properties =
{
  verbosity : 'Level of verbosity. Default = 3.',
  v : 'Level of verbosity. Default = 3.',
  dirPath : 'Path to directory. Default is current path.',
  first : 'First element of the listing will take the cardinal. Default is 10.',
  step : 'Width of one step. Default is 10',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

//

function commandListingSqueeze( e )
{
  let cui = this;
  let ca = e.aggregator;
  let op = e.propertiesMap;

  cui._command_head( commandListingSqueeze, arguments );

  op.dirPath = op.dirPath || _.path.current();

  return _.censor.listingSqueeze( op );
}

var command = commandListingSqueeze.command = Object.create( null );
command.hint = 'Squeeze a ordered list of files in the directory';
command.properties =
{
  verbosity : 'Level of verbosity. Default = 3.',
  v : 'Level of verbosity. Default = 3.',
  dirPath : 'Path to directory. Default is current path.',
  first : 'First element of the listing will take the cardinal. Default is 1.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
}

// --
// do commands
// --

function commandDo( e )
{
  let cui = this;
  let ca = e.aggregator;
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

var command = commandDo.command = Object.create( null );
command.hint = 'Do actions planned earlier. Alias of command redo.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to do. Zero for no limit. Default = 0.',
  d : 'How many action to do. Zero for no limit. Default = 0.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
  usingTextLink : 'Treat a file as a textlink. Default is 0'
}

//

function commandRedo( e )
{
  let cui = this;
  let ca = e.aggregator;
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

var command = commandRedo.command = Object.create( null );
command.hint = 'Do actions planned earlier. Alias of command do.';
command.subjectHint = false;
command.properties =
{
  verbosity : 'Level of verbosity. Default = 3',
  v : 'Level of verbosity. Default = 3',
  depth : 'How many action to redo. Zero for no limit. Default = 0.',
  d : 'How many action to do. Zero for no limit. Default = 0.',
  profile : 'Name of profile to use. Default is "default"',
  session : 'Name of session to use. Default is "default"',
  usingTextLink : 'Treat a file as a textlink. Default is 0'
}

//

function commandUndo( e )
{
  let cui = this;
  let ca = e.aggregator;
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

var command = commandUndo.command = Object.create( null );
command.hint = 'Undo an action done earlier.';
command.subjectHint = false;
command.properties =
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
  let ca = e.aggregator;

  cui._command_head( commandStatus, arguments );

  let status = _.censor.status( e.propertiesMap );

  logger.log( _.entity.exportStringNice( status ) );

}

var command = commandStatus.command = Object.create( null );
command.hint = 'Get status of the current state.';
command.subjectHint = false;
command.properties =
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
  commandVersion,
  commandImply,

  // storage commands

  commandStorageDel,
  commandStorageLog,

  commandProfileDel,
  commandProfileLog,

  commandConfigLog,
  commandConfigGet,
  commandConfigSet,
  commandConfigDel,

  commandArrangementDel,
  commandArrangementLog,

  commandIdentityList,
  commandIdentityCopy,
  commandIdentityNew,
  commandGitIdentityNew,
  commandIdentityRemove,

  // operation commands

  commandReplace,
  commandListingReorder,
  commandListingSqueeze,

  // instant operation commands

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
