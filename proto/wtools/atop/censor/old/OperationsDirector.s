( function _OperationsDirector_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../node_modules/Tools' );

  _.include( 'wArraySparse' );
  _.include( 'wCopyable' );
  _.include( 'wVerbal' );
  _.include( 'wFiles' );
  _.include( 'wTemplateTreeResolver' );
  _.include( 'wCommandsAggregator' );
  _.include( 'wStateSession' );

}

//

const _ = _global_.wTools;
const Parent = null;
const Self = wFilesOperationsDirector;
function wFilesOperationsDirector( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'FilesOperationsDirector';

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( self.fileProvider === null )
  self.fileProvider = new _.FileProvider.Default();

  if( self.logger === null )
  self.logger = new _.Logger({ output : logger });

  // if( self.Self === Self )
  // self.form();

}

//

function form()
{
  let self = this;
  const fileProvider = self.fileProvider;
  let currentPath = fileProvider.path.current();

  _.assert( arguments.length === 0, 'Expects no arguments' );
  // _.assert( _.strDefined( self.filePath ), 'Expects defined {-self.filePath-}' );
  _.assert( !self.formed, 'Already formed' );

  self.formed = 1;

  if( !self.foundFilePath )
  self.foundFilePath = fileProvider.path.resolve( currentPath, './.replace.found.s' );

  if( !self.undoFilePath )
  self.undoFilePath = fileProvider.path.resolve( currentPath, './.replace.undo.s' );

  return self;
}

// --
// exec
// --

function Exec()
{
  let self = new this.Self();

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.exec();

  return self;
}

//

function exec()
{
  let self = this;
  let logger = self.logger;
  const fileProvider = self.fileProvider;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  let appArgs = _.process.input();
  let commands =
  {

    'help' :                    { ro : _.routineJoin( self, self.commandHelp ), h : 'Get help' },

    'session clear' :           { ro : _.routineJoin( self, self.commandConfigClear ), h : 'Clear options and persistent state' },
    'session define' :          { ro : _.routineJoin( self, self.commandConfigDefine ), h : 'Define options for the following operation' },
    'session append' :          { ro : _.routineJoin( self, self.commandConfigAppend ), h : 'Append defined options' },
    'session delete' :          { ro : _.routineJoin( self, self.commandConfigDelete ), h : 'Delete field or several from defined options' },
    'session define path' :     { ro : _.routineJoin( self, self.commandConfigDefinePath ), h : 'Define file path' },

    'find' :                    { ro : _.routineJoin( self, self.commandFind ), h : 'Find text' },
    'if replace' :              { ro : _.routineJoin( self, self.commandIfReplace ), h : 'Pretend replacement proceeding to see result' },
    'replace' :                 { ro : _.routineJoin( self, self.commandReplace ), h : 'Proceed replacement' },
    'undo' :                    { ro : _.routineJoin( self, self.commandUndo ), h : 'Restore the previous state of files changed by the recent operation' },

    'find similar' :            { ro : _.routineJoin( self, self.commandFindSimilar ), h : 'Find similar files at a specific path' },
    'tokenize' :                { ro : _.routineJoin( self, self.commandTokenize ), h : 'Tokenize source files' },

  }

  var ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands,
    commandPrefix : 'node ',
  }).form();

  return ca.programPerform({ program : appArgs.original });
  // return ca.appArgsPerform({ appArgs });
}

//

function commandHelp( e )
{
  let self = this;
  let ca = e.aggregator;
  let logger = self.logger;

  ca._commandHelp( e );

  // if( !e.commandName )
  // {
  //   logger.log( 'Use ' + logger.colorFormat( '"fslink prepare libraryPath:/some/path"', 'code' ) + ' to prepare config' );
  //   logger.log( 'Use ' + logger.colorFormat( '"fslink"', 'code' ) + ' to link all files in the current directory with each other and with files from the library' );
  // }

}

//

function commandConfigClear( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.form();

  self.stateDeleteAwaiting();
  self.sessionOpenOrCreate();
  self.storage = Object.create( null );
  self.sessionSave();

  return self;
}

//

function commandConfigDefine( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.sessionOpenOrCreate();

  debugger;
  self.storage = _.mapExtend( self.storage, e.propertiesMap );

  self.sessionSave();

  return self;
}

//

function commandConfigAppend( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.sessionOpenOrCreate();

  debugger;
  self.storage = _.mapExtendAppendingArraysRecursive( self.storage, e.propertiesMap );

  self.sessionSave();

  return self;
}

//

function commandConfigDelete( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.sessionOpenOrCreate();

  self.storage = self.storage || Object.create( null );
  _.mapDelete( self.storage, e.propertiesMap );

  self.sessionSave();

  return self;
}

//

function commandConfigDefinePath( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  let defaults =
  {
    filePath : null,
  }

  self.sessionOpenOrCreate();
  self.storage = self.storage || Object.create( null );

  _.mapSupplement( self.storage, defaults );

  _.process.inputReadTo
  ({
    dst : self.storage,
    only : 1,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'path' : 'filePath',
      'filePath' : 'filePath',
    },
  });

  if( !self.filePath )
  throw _.errBrief( 'Not clear where to look for, please define {-filePath-}' + '\nfilePath : ' + _.entity.exportStringShallow( self.storage.filePath ) );

  self.storage.filePath = fileProvider.path.resolve( self.storage.filePath );

  self.sessionSave();

  return self;
}

//

function commandFind( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;
  let o2 = Object.create( null );

  self.sessionOpen();

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );
  _.mapSupplement( o2, self.find.defaults );
  _.mapExtend( self, _.mapOnly_( null, self.storage, self ) );
  _.mapExtend( o2, _.mapOnly_( null, self.storage, o2 ) );

  _.process.inputReadTo
  ({
    dst : self,
    only : 0,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'path' : 'filePath',
      'filePath' : 'filePath',
    },
  });

  _.process.inputReadTo
  ({
    dst : o2,
    only : 1,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'for' : 'ins',
      'ins' : 'ins',
      'sub' : 'sub',
      'stringWithRegexp' : 'stringWithRegexp',
      'toleratingSpaces' : 'toleratingSpaces',
    },
  });

  if( !self.filePath )
  throw _.errBrief( 'Not clear where to look for, please define {-self.filePath-}' + '\nself.filePath : ' + _.entity.exportStringShallow( self.filePath ) );

  self.filePath = fileProvider.path.s.resolve( self.filePath );
  o2.filePath = self.filePath;

  self.form();
  self.find( o2 );
  self.save();

  return self;
}

//

function _execReplace( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;
  let o2 = Object.create( null );

  self.sessionOpen();

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );
  _.mapSupplement( o2, self.replace.defaults );
  _.mapExtend( self, _.mapOnly_( null, self.storage, self ) );
  _.mapExtend( o2, _.mapOnly_( null, self.storage, o2 ) );

  /* xxxyyy */

  _.process.inputReadTo
  ({
    dst : self,
    only : 0,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'path' : 'filePath',
      'filePath' : 'filePath',
    },
  });

  _.process.inputReadTo
  ({
    dst : o2,
    only : 1,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'sub' : 'sub',
    },
  });

  if( !self.filePath )
  throw _.errBrief( 'Not clear where to look for, please define {-self.filePath-}' + '\nself.filePath : ' + _.entity.exportStringShallow( self.filePath ) );

  self.filePath = fileProvider.path.s.resolve( self.filePath );
  // o2.filePath = self.filePath;

  self.form();
  self.load();
  self.replace( o2 );

  return self;
}

//

function commandIfReplace( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.changing = 0;

  return self._execReplace( e );
}

//

function commandReplace( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.changing = 1;

  return self._execReplace( e );
}

//

function commandUndo( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;
  let o2 = Object.create( null );

  self.sessionOpen();

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );
  _.mapSupplement( o2, self.replace.defaults );
  _.mapExtend( self, _.mapOnly_( null, self.storage, self ) );
  _.mapExtend( o2, _.mapOnly_( null, self.storage, o2 ) );

  _.process.inputReadTo
  ({
    dst : self,
    only : 0,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'path' : 'filePath',
      'filePath' : 'filePath',
    },
  });

  _.process.inputReadTo
  ({
    dst : o2,
    only : 1,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
    },
  });

  if( !self.filePath )
  throw _.errBrief( 'Not clear where to look for, please define {-self.filePath-}' + '\nself.filePath : ' + _.entity.exportStringShallow( self.filePath ) );

  self.filePath = fileProvider.path.s.resolve( self.filePath );
  o2.filePath = self.filePath;

  self.form();
  self.load();
  self.undo();

  return self;
}

//

function commandFindSimilar( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;
  let o2 = Object.create( null );

  self.sessionOpen();

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );
  _.mapSupplement( o2, self.findSimilar.defaults );
  _.mapExtend( self, _.mapOnly_( null, self.storage, self ) );
  _.mapExtend( o2, _.mapOnly_( null, self.storage, o2 ) );

  _.process.inputReadTo
  ({
    dst : self,
    only : 0,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'path' : 'filePath',
      'filePath' : 'filePath',
    },
  });

  _.process.inputReadTo
  ({
    dst : o2,
    only : 1,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'relativePaths' : 'relativePaths',
      'similarityLimit' : 'simsilarityLimit',
      's' : 'similarityLimit',
    },
  });

  if( !self.filePath )
  throw _.errBrief( 'Not clear where to look for, please define {-self.filePath-}' + '\nself.filePath : ' + _.entity.exportStringShallow( self.filePath ) );

  self.filePath = fileProvider.path.s.resolve( self.filePath );
  o2.filePath = self.filePath;

  self.form();
  self.findSimilar( o2 );
  // self.save();

  return self;
}

//

function commandTokenize( e )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger= self.logger;
  let o2 = Object.create( null );

  self.sessionOpen();

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );
  _.mapSupplement( o2, self.tokenize.defaults );
  _.mapExtend( self, _.mapOnly_( null, self.storage, self ) );
  _.mapExtend( o2, _.mapOnly_( null, self.storage, o2 ) );

  _.process.inputReadTo
  ({
    dst : self,
    only : 0,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
      'path' : 'filePath',
      'filePath' : 'filePath',
    },
  });

  _.process.inputReadTo
  ({
    dst : o2,
    only : 1,
    propertiesMap : e.propertiesMap,
    namesMap :
    {
    },
  });

  if( !self.filePath )
  throw _.errBrief( 'Not clear where to look for, please define {-self.filePath-}' + '\nself.filePath : ' + _.entity.exportStringShallow( self.filePath ) );

  self.filePath = fileProvider.path.s.resolve( self.filePath );
  o2.filePath = self.filePath;

  self.form();
  self.tokenize( o2 );

  return self;
}

//

function appArgsRead( appArgs )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  appArgs = appArgs || _.process.input();

  _.process.inputReadTo
  ({
    dst : self,
    propertiesMappArgs : propertiesMappArgs.map,
    only : 0,
    namesMap :
    {
      'v' : 'verbosity',
      'verbosity' : 'verbosity',
      'coloring' : 'coloring',
      'perFile' : 'perFileReporting',
    },
  });

  _.process.inputReadTo
  ({
    dst : self.logger,
    propertiesMappArgs : propertiesMappArgs.map,
    only : 0,
    namesMap :
    {
      'logger.inputGray' : 'inputGray',
      'logger.inputRaw' : 'inputRaw',
      'logger.outputGray' : 'outputGray',
      'logger.outputRaw' : 'outputRaw',
      'logger.rawAll' : 'rawAll',
    },
  });

  if( appArgs.subject )
  self.filePath = self.fileProvider.path.resolve( appArgs.subject );

  return self;
}

//

function useCurrentPath()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  if( self.filePath === null )
  self.filePath = _.path.current();
  return self;
}

// --
// log
// --

function topicBegin( making, how )
{
  let self = this;
  let logger = self.logger;
  logger.rbegin({ verbosity : -1 });
  logger.topic( making + ( _.strIsMultilined( how ) ? '\n' : ' ' ) + how );
  logger.rend({ verbosity : -1 });
}

//

function topicEnd( msg )
{
  let self = this;
  let logger = self.logger;

  logger.topic( msg );

}

//

function similarGroupsLog( found )
{
  let self = this;
  let logger = self.logger;

  _.assert( arguments.length === 1 );

  self.topicBegin( 'Similar groups', '' );

  logger.rbegin({ verbosity : -1 });

  found.similarGroupsArray.forEach( ( group, g ) =>
  {
    groupPathEachLog( group )
    logger.log();
  });

  logger.rend({ verbosity : -1 });

  function cyan( e )
  {
    return logger.colorFormat( e, { fg : 'cyan' } );
  }

  function yellow( e )
  {
    return logger.colorFormat( e, { fg : 'yellow' } );
  }

  function groupPathEachLog( group )
  {
    group.paths.forEach( ( path, p ) =>
    {
      let line = logger.colorFormat( path, 'path' );

      let linked;
      let linkedStr = '';
      let linkGroup = found.linkedFilesMap[ path ];
      if( linkGroup !== undefined )
      {
        debugger;
        linkGroup = found.linkGroupsArray[ linkGroup ];
        linked = group.paths.map( ( path2, p2 ) =>
        {
          if( p === p2 )
          return false;
          return _.longHas( linkGroup.paths, path2 );
        });
        linkedStr = linked.map( ( e ) => e ? '+' : '-' );
        linkedStr = linkedStr.map( ( e ) => logger.colorFormat( e, { fg : 'orange' } ) ).join( ', ' );
      }

      let similarities = _.select( found.similarMaps[ path ], '*/similarity' );
      similarities = _.mapVals( _.mapVaslWithKeys( similarities, group.paths ) );
      let similaritiesStr = similarities.map( ( e ) => logger.colorFormat( _.entity.exportString( e ), { fg : 'cyan' } ) ).join( ', ' );

      debugger;
      let combined = similarities.map( ( s, key ) =>
      {
        if( linked && linked[ key ] )
        return yellow( '   +  ' );
        if( key === p )
        return yellow( '   .  ' );
        if( s === undefined )
        return yellow( '   -  ' );
        return s.toFixed( 4 );
      });

      let combinedStr = combined.map( ( e ) => cyan( e ) ).join( ' ' );

      line = combinedStr + ' | ' + line;
      // line += ' s> ' + similaritiesStr + ' l> ' + linkedStr;
      logger.log( line );
    });
  }

}

//

function linkGroupsLog( found )
{
  let self = this;
  let logger = self.logger;

  _.assert( arguments.length === 1 );

  self.topicBegin( 'Linked groups', '' );

  logger.rbegin({ verbosity : -1 });

  for( let g = 0 ; g < found.linkGroupsArray.length ; g++ )
  {
    let group = found.linkGroupsArray[ g ];
    for( let f = 0 ; f < group.paths.length ; f++ )
    {
      let line = group.paths[ f ];
      line = logger.colorFormat( line, 'path' );
      logger.log( line );
    }
    logger.log();
  }

  logger.rend({ verbosity : -1 });

}

// --
// match
// --

function matchExecSub( match )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( _.routineIs( match.sub ) )
  {
    let r = match.sub.call( match.ins, match );
    _.assert( _.strIs( r ) );
    match.sub = r;
  }

  if( self.templating )
  {
    let resolver = new _.TemplateTreeResolver({ tree : match });
    match.sub = resolver.resolve( match.sub );
  }

}

//

function matchMakeUndoInstruction( match )
{
  let self = this;

  _.assert( arguments.length === 1 );

  let instruction = self.undoInstructionsMap[ match.file.absolute ];
  if( instruction )
  return instruction;
  instruction = Object.create( null );
  instruction.file = match.file;
  instruction.read = match.read || self.fileProvider.fileRead( match.file.absolute );
  // self.undoInstructions.push( instruction );
  self.undoInstructionsMap[ match.file.absolute ] = instruction;
  return instruction;
}

//

function matchEach( o )
{
  let self = this;
  let logger = self.logger;
  let nreplacements = 0;

  if( _.routineIs( arguments[ 0 ] ) )
  o = { onEach : arguments[ 0 ] };
  o = _.routineOptions( matchEach, o );

  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( o.replacementsLimit ) );

  _.process.inputReadTo
  ({
    dst : o,
    only : 0,
    namesMap :
    {
      'replacementsLimit' : 'replacementsLimit',
    },
  });

  /* */

  try
  {

    if( o.checkingConsistency )
    self.found.forEach( ( match ) =>
    {
      let stat = self.fileProvider.statResolvedRead( match.file.absolute );
      if( stat.size !== match.file.stat.size || stat.mtimeMs !== match.file.stat.mtimeMs )
      {
        debugger;
        throw _.err( 'Files are outdated, please rerun Find', '\nOutdated file :', match.file.absolute );
      }
    });

    /* */

    self.found.every( ( match ) =>
    {

      if( nreplacements > o.replacementsLimit )
      return false;

      let stat = self.fileProvider.statResolvedRead( match.file.absolute );

      let r = o.onEach.call( self, match );

      _.assert( r === undefined );

      nreplacements += 1;

      return true;
    });
    debugger;

  }
  catch( err )
  {
    self.err = _.errLogOnce( err );
  }

  /* */

  return nreplacements;
}

matchEach.defaults =
{
  onEach : null,
  replacementsLimit : Infinity,
  checkingConsistency : 1,
}

//

function matchLog( match, pre )
{
  let self = this;
  let logger = self.logger;
  pre = pre || '';

  let info = '';
  info += logger.escape( match.nearest[ 0 ] );
  info += logger.colorFormat( logger.escape( match.nearest[ 1 ] ), { fg : 'yellow' } );
  info += logger.escape( match.nearest[ 2 ] );

  // xxx

  let f = match.linesOffsets[ 0 ];
  info = _.strLinesNumber
  ({
    src : info,
    first : f,
    onLine : handleLine,
  });

  let fileReport = self.usedFile( match.file.absolute );
  let mid = logger.colorFormat( match.file.absolute + ':' + match.linesRange[ 0 ], 'path' );

  logger.rbegin({ verbosity : -1 });

  pre = logger.colorFormat( pre, { fg : 'bright white' } );

  if( self.verbosity >= 3 )
  logger.log( logger.colorFormat( pre + mid, { bg : 'dark black' } ) );
  else
  logger.log( pre + mid );

  logger.rbegin({ verbosity : -1 });
  logger.log( info );
  logger.rend({ verbosity : -1 });

  logger.rend({ verbosity : -1 });

  /* */

  function handleLine( line )
  {
    return line.join( '' );
  }

}
// --
// etc
// --

function usedFile( path )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ), 'Expects string' );

  let result = self.filesMap[ path ];
  if( !result )
  {
    result = self.filesMap[ path ] = Object.create( null );
    result.path = path;
    result.counter = 0;
  }

  result.counter += 1;

  return result;
}

// --
//
// --

function findSimilar( o )
{
  let self = this;
  let logger = self.logger;

  logger.rbegin({ verbosity : -1 });
  self.topicBegin( 'Looking for similar files at', logger.colorFormat( self.filePath, 'path' ) );

  _.routineOptions( findSimilar, o );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self.formed );

  // let findOptions =
  // {
  //   filePath : self.filePath,
  //   relativePaths : 1,
  //   similarityLimit : 0.95,
  // }
  //
  // _.process.inputReadTo
  // ({
  //   dst : findOptions,
  //   only : 1,
  //   namesMap :
  //   {
  //     'relativePaths' : 'relativePaths',
  //     'similarityLimit' : 'simsilarityLimit',
  //     's' : 'similarityLimit',
  //   },
  // });

  o.filePath = self.filePath;
  self.found = self.fileProvider.filesFindSame( o );

  self.similarGroupsLog( self.found );
  logger.rbegin({ verbosity : -1 });
  self.linkGroupsLog( self.found );
  logger.rend({ verbosity : -1 });

  /* */

  let g = logger.colorFormat( self.found.similarGroupsArray.length, { fg : 'green' } );
  let f = logger.colorFormat( self.found.similarFilesInTotal, { fg : 'green' } );
  self.topicEnd( 'Found ' + g + ' similar groups with ' + f + ' files' )

  logger.rend({ verbosity : -1 });

  // console.log( 'self.coloring', self.coloring );
  // console.log( 'logger.coloring', logger.coloring );

  return self;
}

findSimilar.defaults =
{
  relativePaths : 1,
  similarityLimit : 0.95,
}

//

function find( o )
{
  let self = this;
  let logger = self.logger;
  o = _.routineOptions( find, o );
  _.assert( self.formed );

  // _.process.inputReadTo
  // ({
  //   dst : o,
  //   only : 1,
  //   namesMap :
  //   {
  //     'for' : 'ins',
  //     'ins' : 'ins',
  //     'sub' : 'sub',
  //     'stringWithRegexp' : 'stringWithRegexp',
  //     'toleratingSpaces' : 'toleratingSpaces',
  //   },
  // });

  let supplement =
  {
    filePath : self.filePath,
    // ins,
  }

  if( !o.ends )
  o.ends = self.exts;

  _.mapSupplementNulls( o, supplement );
  if( o.dictionary )
  _._strReplaceMapPrepare( o );

  /* */

  _.assert( o.outputFormat === 'absolute' );
  _.assert( !!o.ins, () => 'Not clear what too look for, please define {-o.ins-}' + '\no.ins : ' + _.strQuote( o.ins ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  o.ins = _.regexpsMaybeFrom
  ({
    srcStr : o.ins,
    stringWithRegexp : o.stringWithRegexp,
    toleratingSpaces : o.toleratingSpaces,
  });

  /* */

  let ins = _.entity.exportString( o.ins );
  ins = logger.colorFormat( ins, { fg : 'bright yellow' } );
  let at = o.filePath
  at = logger.colorFormat( at, 'path' );

  logger.rbegin({ verbosity : -1 });

  self.topicBegin( 'Looking for', ins + ' at ' + at );
  // logger.log( 'sub', o.sub );

  let o2 = _.mapExtend( null, o );
  delete o2.sub;
  delete o2.dictionary;
  self.found = self.fileProvider.filesSearchText( o2 );

  self.found.forEach( ( match ) =>
  {
    match.sub = o.sub;
    if( _.arrayIs( match.sub ) )
    match.sub = match.sub[ match.tokenId ];
    delete match.input;
    self.matchExecSub( match );
    self.matchMakeUndoInstruction( match );
    self.matchLog( match, ' . ' + 'found at ' );
    _.assert( _.strIs( match.sub ) || match.sub === null );
  });

  let nmatches = logger.colorFormat( self.found.length, { fg : 'green' } );
  let nfiles = logger.colorFormat( _.mapKeys( self.filesMap ).length, { fg : 'green' } );
  self.topicEnd( 'Found ' + nmatches + ' match(es)' + ' in ' + nfiles + ' file(s)' );

  logger.rend({ verbosity : -1 });

  return self;
}

var defaults = find.defaults = Object.create( _.FileProvider.Default.prototype.filesSearchText.defaults );

defaults.stringWithRegexp = 1;
defaults.toleratingSpaces = 1;
defaults.determiningLineNumber = 1;
defaults.maskAll = _.files.regexpMakeSafe();
defaults.ends = null;
defaults.outputFormat = 'absolute';
defaults.recursive = 1;
defaults.sub = null;
defaults.dictionary = null;

//

function tokenize( o )
{
  let self = this;
  let logger = self.logger;

  o = o || Object.create( null );
  if( !o.filePath )
  o.filePath = self.filePath;
  o = _.routineOptions( tokenize, o );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self.formed );

  /* */

  let at = logger.colorFormat( o.filePath, 'path' );

  logger.rbegin({ verbosity : -1 });

  self.topicBegin( 'Tokenizing ' + at, '' );

  let o2 = _.mapOnly_( null, o, self.fileProvider.filesFindRecursive.defaults );
  self.found = self.fileProvider.filesFindRecursive( o2 );

  self.found.forEach( ( file ) =>
  {
    let read = self.fileProvider.fileRead( file.absolute );
    let tokens = _.strTokenizeJs({ src : read, tokenizingUnknown : 0 });
    // let tokens = _.strTokenizeJs({ src : read, tokenizingUnknown : 1 });

    let ranges = _.arrayFlatten( null, _.select( tokens, '*/range' ) );
    let gaps = _.sparse.invertFinite( _.sparse.minimize( ranges ) );

    if( gaps.length/2-2 > 0 )
    {

      if( gaps.length/2-2 <= 3 )
      _.sparse.eachRange( gaps, ( range ) =>
      {

        if( range[ 1 ]-range[ 0 ] <= 0 )
        return;

        let report = _.strLinesNearestLog
        ({
          src : read,
          charsRangeLeft : range,
          gray : 0,
        });

        // if( _.strHas( report.report, 'image/png' ) )
        // xxx

        logger.log( report.report );

      });

    }

    logger.log( ' .', file.relative, 'has', tokens.length, 'tokens', gaps.length/2-2, 'gaps' );
  });

  logger.rend({ verbosity : -1 });

  return self;
}

var defaults = tokenize.defaults = Object.create( _.FileProvider.Default.prototype.filesFindRecursive.defaults );

// defaults.stringWithRegexp = 1;
// defaults.toleratingSpaces = 1;
// defaults.determiningLineNumber = 1;
defaults.maskAll = _.files.regexpMakeSafe();
defaults.withDirs = 0;
defaults.withTransient = 0;
defaults.ends = [ '.s', '.ss', '.js' ];
// defaults.ends = null;
// defaults.outputFormat = 'absolute';
// defaults.recursive = 1;
// defaults.sub = null;
// defaults.dictionary = null;

//

function replace( o )
{
  let self = this;
  let logger = self.logger;

  if( !_.mapIs( o ) )
  o = { sub : o }

  _.routineOptions( replace, o );

  logger.rbegin({ verbosity : -1 });

  let sub = _.entity.exportString( o.sub );
  sub = logger.colorFormat( sub, { fg : 'cyan' } );
  self.topicBegin( 'Replacing with', sub );

  // _.assert( _.strIs( o.sub ) || _.routineIs( o.sub ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self.formed );

  /* */

  let nreplacements = 0;
  self.matchEach( matchReplace );

  /* */

  nreplacements = logger.colorFormat( nreplacements, { fg : 'green' } );
  let nfiles = logger.colorFormat( _.mapKeys( self.filesMap ).length, { fg : 'green' } );
  self.topicEnd( 'Made ' + nreplacements + ' replacement(s)' + ' in ' + nfiles + ' file(s)' );

  logger.rend({ verbosity : -1 });

  return self;

  /* */

  function matchReplace( match )
  {
    match.read = self.fileProvider.fileRead( match.file.absolute );
    // match.resolver = new _.TemplateTreeResolver({ tree : match });

    let charsRangeLeft = [ match.read.length - match.charsRangeRight[ 0 ], match.read.length - match.charsRangeRight[ 1 ] ];
    let was = match.read.substring( charsRangeLeft[ 0 ], charsRangeLeft[ 1 ] );

    if( was !== match.nearest[ 1 ] )
    {
      logger.log( ' x already changed', logger.colorFormat( match.file.absolute, 'path' ) );
      return;
    }

    match.before = match.read.substring( 0, charsRangeLeft[ 0 ] );
    match.after = match.read.substring( charsRangeLeft[ 1 ], match.read.length );

    match.sub = match.sub || o.sub;
    self.matchExecSub( match );

    if( match.sub === null )
    {
      logger.log( ' x no substitution', match.file.absolute );
    }
    else
    {
      _.assert( _.strIs( match.sub ) );
      if( self.changing )
      {
        self.fileProvider.fileWrite( match.file.absolute, match.before + match.sub + match.after );
        nreplacements += 1;
      }
      match.nearest[ 1 ] = match.sub;
      self.matchLog( match, ' + replacement at ' );
    }

    // if( match.sub !== null )
    // {
    //   _.assert( _.strIs( match.sub ) );
    //   if( self.changing )
    //   {
    //     self.fileProvider.fileWrite( match.file.absolute, match.before + match.sub + match.after );
    //     nreplacements += 1;
    //   }
    //   match.nearest[ 1 ] = match.sub;
    //   self.matchLog( match, ' + replacement at ' );
    // }
    // else
    // {
    //   logger.log( ' x no substitution', match.file.absolute );
    // }

  }

}

replace.defaults =
{
  sub : null,
}

//

function undo()
{
  let self = this;
  let logger = self.logger;

  _.assert( self.formed );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  for( let i in self.undoInstructionsMap )
  {
    let instruction = self.undoInstructionsMap[ i ];
    if( self.changing )
    self.fileProvider.fileWrite( instruction.file.absolute, instruction.read );
    logger.log( ' + undo ' + logger.colorFormat( instruction.file.absolute, 'path' ) );
  }

  _.mapDelete( self.undoInstructionsMap );

  return self;
}

// --
// state
// --

function _storageFileWrite( o )
{
  let self = this;
  const fileProvider = self.fileProvider;
  let logger = self.logger;

  _.routineOptions( _storageFileWrite, o );
  _.assert( o.storage !== undefined && !_.routineIs( o.storage ), () => 'Expects defined data {-self.storageToSave-}' );
  _.assert( arguments.length === 1 );

  if( logger.verbosity >= 3 )
  {
    let title = _.strQuote( _.strCapitalize( _.strToTitle( self.storageFileName ) ) );
    logger.log( ' + saving config ' + title + ' at ' + _.strQuote( o.storageFilePath ) );
    logger.log( 'Storage' );
    logger.log( _.entity.exportString( o.storage, { levels : 3 } ) );
  }

  fileProvider.fileWriteJson
  ({
    filePath : o.storageFilePath,
    data : o.storage,
    pretty : 1,
    sync : 1,
  });

}

_.routineExtend( _storageFileWrite, _.StateStorage.prototype._storageFileWrite );

//

function stateDelete()
{
  let self = this;
  let logger = self.logger;

  logger.rbegin({ verbosity : -1 });
  logger.log( ' - deleting ' + self.foundFilePath );
  logger.log( ' - deleting ' + self.undoFilePath );
  logger.rend({ verbosity : -1 });

  if( self.changing )
  self.fileProvider.fileDelete({ filePath : self.foundFilePath, throwing : 0 });
  if( self.changing )
  self.fileProvider.fileDelete({ filePath : self.undoFilePath, throwing : 0 });

  return self;
}

//

function stateDeleteAwaiting()
{
  let self = this;
  let logger = self.logger;

  logger.rbegin({ verbosity : -1 });
  logger.log( ' - deleting ' + self.foundFilePath );
  logger.rend({ verbosity : -1 });

  if( self.changing )
  self.fileProvider.fileDelete({ filePath : self.foundFilePath, throwing : 0 });

  return self;
}

//

function stateSave()
{
  let self = this;
  let logger = self.logger;

  logger.rbegin({ verbosity : -1 });
  logger.log( ' + saving ' + self.foundFilePath );
  logger.log( ' + saving ' + self.undoFilePath );
  logger.rend({ verbosity : -1 });

  if( self.changing )
  self.fileProvider.fileWriteJs({ filePath : self.foundFilePath, data : self.found, cloning : 1 });
  if( self.changing )
  self.fileProvider.fileWriteJs({ filePath : self.undoFilePath, data : self.undoInstructionsMap, cloning : 1 });

  return self;
}

//

function stateLoad()
{
  let self = this;
  let logger = self.logger;

  logger.rbegin({ verbosity : -1 });
  logger.log( ' . loading ' + self.foundFilePath );
  logger.log( ' . loading ' + self.undoFilePath );
  logger.rend({ verbosity : -1 });

  self.found = self.fileProvider.fileReadJs( self.foundFilePath );
  self.undoInstructionsMap = self.fileProvider.fileReadJs( self.undoFilePath );

  return self;
}

// --
// relations
// --

let Composes =
{

  filePath : null,
  foundFilePath : null,
  undoFilePath : null,

  verbosity : 3,
  coloring : 1,
  changing : 1,
  perFileReporting : 0,
  templating : 1,

  exts : _.define.own([ '.js', '.s', '.ss', '.c', '.cpp', '.h', '.hpp' ]),
  storageFileName : '.operations.director',

}

let Aggregates =
{
  storage : null,
}

let Associates =
{
  found : null,
  fileProvider : null,
  logger : null,
}

let Restricts =
{
  opened : 0,
  formed : 0,
  err : null,
  undoInstructionsMap : _.define.own({}),
  filesMap : _.define.own({}),
}

let Medials =
{
}

let Statics =
{
  Exec
}

let Events =
{
}

let Forbids =
{
  sub : 'sub',
  ins : 'ins',
  replacementsLimit : 'replacementsLimit',
  subFilePath : 'subFilePath',
  nreplacements : 'nreplacements',
  undoInstructions : 'undoInstructions',
}

// --
// proto
// --

let Proto =
{

  init,
  form,

  // exec

  Exec,
  exec,

  commandHelp,

  commandConfigClear,
  commandConfigDefine,
  commandConfigAppend,
  commandConfigDelete,
  commandConfigDefinePath,

  commandFind,
  _execReplace,
  commandIfReplace,
  commandReplace,
  commandUndo,

  commandFindSimilar,
  commandTokenize,

  appArgsRead,
  useCurrentPath,

  // log

  topicBegin,
  topicEnd,
  similarGroupsLog,
  linkGroupsLog,

  // match

  matchExecSub,
  matchMakeUndoInstruction,
  matchEach,
  matchLog,

  // etc

  usedFile,

  //

  findSimilar,

  find,
  replace,

  tokenize,

  undo,

  // state

  _storageFileWrite,

  stateDelete,
  stateDeleteAwaiting,
  stateSave,
  stateLoad,
  save : stateSave,
  load : stateLoad,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Medials,
  Statics,
  Events,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );
_.StateStorage.mixin( Self );
_.StateSession.mixin( Self );

//

_global_[ Self.name ] = wTools[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' && !module.parent )
Self.Exec();

})();
