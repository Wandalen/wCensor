( function _Ext_test_s_( )
{

'use strict';

/* xxx : qqq : check no garbage left in ~/.censor/* */
/* xxx : qqq : check default profile is not demaged in ~/.censor/default/* especiall ~/.censor/default/config.yaml */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../censor/entry/Include.s' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = __.path.tempOpen( __.path.join( __dirname, '../..' ), 'censor' );
  context.assetsOriginalPath = __.path.join( __dirname, '_asset' );
  // context.appJsPath = __.path.nativize( __.module.resolve( 'wCensor' ) );
  context.appJsPath = __.path.join( __dirname, '../censor/entry/Exec' );
}

//

function onSuiteEnd()
{
  let context = this;
  __.assert( __.strHas( context.suiteTempPath, '/censor' ) )
  __.path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function help( test )
{
  let context = this;
  let a = test.assetFor( false );
  a.reflect();

  /* */

  a.appStartNonThrowing( `.` )
  .then( ( op ) =>
  {
    test.case = '.';
    test.notIdentical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, 'Ambiguity. Did you mean?' ), 1 );
    test.identical( __.strCount( op.output, '.help - Get help.' ), 1 );
    return null;
  });

  /* */

  a.appStartNonThrowing( `` )
  .then( ( op ) =>
  {
    test.case = '';
    test.notIdentical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, 'Illformed command ""' ), 1 );
    test.identical( __.strCount( op.output, '.help - Get help.' ), 1 );
    return null;
  });

  /* */

  return a.ready;
}

//

function where( test )
{
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );

  /* - */

  a.appStart( '.where' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Censor::local : ' ), 1 );
    test.identical( _.strCount( op.output, 'Censor::entry : ' ), 1 );
    test.identical( _.strCount( op.output, 'Censor::remote : ' ), 1 );
    test.identical( _.strCount( op.output, 'Censor::default : ' ), 1 );
    test.identical( _.strCount( op.output, 'Git::global : ' ), 1 );
    return null;
  });

  /* - */

  return a.ready;
}

//

// function runDebugCensor( test )
// {
//   let context = this;
//   let a = test.assetFor( false );
//   let con = __.take( null );
//   a.reflect();
//
//   /* */
//
//   con.then( () =>
//   {
//     test.case = 'debug-censor .help';
//
//     var debugCensorPath = a.abs( a.path.dir( context.appJsPath ), 'ExecDebug' );
//     var o =
//     {
//       execPath : debugCensorPath + ' .help',
//       currentPath : a.routinePath,
//       outputCollecting : 1,
//       throwingExitCode : 0,
//       outputGraying : 1,
//       ready : a.ready,
//       mode : 'fork',
//     };
//     __.process.start( o );
//
//     return a.ready.then( ( op ) =>
//     {
//       if( op.exitCode === 0 )
//       {
//         test.description = 'utility debugnode exists';
//         test.identical( __.strCount( op.output, 'debugnode/node_modules/electron/dist/electron --no-sandbox' ), 1 );
//         test.identical( __.strCount( op.output, 'debugnode/proto/wtools/atop/nodeWithDebug/browser/electron/ElectronProcess.ss' ), 1 );
//         test.identical( __.strCount( op.output, '.help - Get help.' ), 1 );
//         test.identical( __.strCount( op.output, '.version - Get information about version.' ), 1 );
//       }
//       else
//       {
//         test.description = 'utility debugnode not exists';
//         test.identical( __.strCount( op.output, 'spawn debugnode ENOENT' ), 1 );
//         test.identical( __.strCount( op.output, 'code : \'ENOENT\'' ), 1 );
//         test.identical( __.strCount( op.output, 'syscall : \'spawn debugnode\'' ), 1 );
//         test.identical( __.strCount( op.output, 'path : \'debugnode\'' ), 1 );
//         test.identical( __.strCount( op.output, 'spawnargs' ), 1 );
//         test.identical( __.strCount( op.output, 'Error starting the process' ), 1 );
//       }
//       return null;
//     });
//   });
//
//   return con;
// }

//

function configGetBasic( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );

  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'single selector';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.set path/key1:val1 path/key2:val2` )
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.get path/key1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, 'val1\n' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.get path/key2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, 'val2\n' );
    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'several selectors';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.set path/key1:val1 path/key2:val2 path/key3:val3` )
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.get path/key1 path/key1 path/key3` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '[ val1, val1, val3 ]\n' );
    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function configSetBasic( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );

  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = '.config.set ab:cd';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, 'null\n' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.set ab:cd` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '{ "about" : {}, "path" : {}, "ab" : `cd` }' ), 1 );

    var exp = { 'about' : {}, 'path' : {}, 'ab' : 'cd' };
    var got = _global_.wTools.censor.configOpen({ profileDir : profile, locking : 0 });
    test.identical( got.storage, exp );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = '.config.set key1:val1 key2:val2';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.set key1:val1 key2:val2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var exp = { 'about' : {}, 'path' : {}, 'key1' : 'val1', 'key2' : 'val2' };
    var got = _global_.wTools.censor.configOpen({ profileDir : profile, locking : 0 });
    test.identical( got.storage, exp );
    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = '.config.set path/key1:val1 about/key2:val2';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.set path/key1:val1 about/key2:val2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var exp =
    {
      'about' : { 'key2' : 'val2' },
      'path' : { 'key1' : 'val1' },
    }
    var got = _global_.wTools.censor.configOpen({ profileDir : profile, locking : 0 });
    test.identical( got.storage, exp );
    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function configDelBasic( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );

  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = '.config.del path/key1';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.set path/key1:val1 path/key2:val2` )
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.del path/key1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
    {
      'about' : {},
      'path' : { 'key2' : 'val2' }
    }
    var got = _global_.wTools.censor.configOpen({ profileDir : profile, locking : 0 });
    test.identical( got.storage, exp );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = '.config.del path/key1 path/key3';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.set path/key1:val1 path/key2:val2 path/key3:val3` )
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.del path/key1 path/key3` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
    {
      'about' : {},
      'path' : { 'key2' : 'val2' }
    }
    var got = _global_.wTools.censor.configOpen({ profileDir : profile, locking : 0 });
    test.identical( got.storage, exp );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = '.config.del';
    a.reflect();
    return null;
  })

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.set path/key1:val1 path/key2:val2` )
  a.appStart( `.imply profile:${profile} .config.log` )
  a.appStart( `.imply profile:${profile} .config.del` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    return null;
  })

  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, 'null\n' );
    var exp = { 'about' : {}, 'path' : {} };
    // var exp = {};
    var got = _global_.wTools.censor.configOpen({ profileDir : profile, locking : 0 });
    test.identical( got.storage, exp );
    return null;
  })

  /* - */

  // a.ready.then( ( op ) =>
  // {
  //   test.case = '.config.del "path/key 1" path/key3`';
  //   a.reflect();
  //   return null;
  // })
  //
  // a.appStart( `.profile.del profile:${profile}` );
  // a.appStart( `.imply profile:${profile} .config.log` )
  // a.appStart( `.imply profile:${profile} .config.set "path/key 1":val1 "path/key 2":val2 "path/key3":'val3'` )
  // a.appStart( `.imply profile:${profile} .config.log` )
  // a.appStart( `.imply profile:${profile} .config.del "path/key 1" path/key3` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //   test.identical( op.output, '' );
  //   return null;
  // })
  //
  // a.appStart( `.imply profile:${profile} .config.log` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //
  //   var exp =
  //   {
  //     'about' : {},
  //     'path' : { 'key 2' : 'val2' }
  //   }
  //   var got = _global_.wTools.censor.configOpen({ profileDir : profile, locking : 0 });
  //   test.identical( got.storage, exp );
  //
  //   return null;
  // })
  // /* xxx qqq : should work after fix of strRequestParse */

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function configLogBasic( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );

  a.reflect();

  /* - */

  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    var exp = 'null';
    test.case = 'not empty config'
    test.identical( op.exitCode, 0 );
    test.eq( op.output, exp );
    return null;
  });

  /* - */

  a.appStart( `.imply profile:${profile} .config.set path/key1:val1 path/key2:val2` )
  a.appStart( `.imply profile:${profile} .config.log` )
  .then( ( op ) =>
  {
    console.log( 'OUTPUT: ', op.output );
    var exp =
`
{
  "about" : {},
  "path" : { "key1" : \`val1\`, "key2" : \`val2\` }
}
`;
    test.case = 'not empty config'
    test.identical( op.exitCode, 0 );
    test.eq( op.output, exp );
    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function version( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );

  a.reflect();

  /* - */

  a.appStart( `.version profile:${profile}` )
  .then( ( op ) =>
  {
    var exp = 'null';
    test.case = 'version'
    test.identical( op.exitCode, 0 );
    test.true( __.strHas( op.output, 'Current version :' ) );
    test.true( __.strHas( op.output, 'Latest version of wcensor!alpha :' ) );
    return null;
  });

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function arrangementLog( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  /* - */

  a.appStart( `.arrangement.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'no arrangements';
    test.identical( op.exitCode, 0 );

    var exp1 = 'null';
    var got1 = op.output;
    test.equivalent( got1, exp1 );

    var got2 = _global_.wTools.censor.arrangementOpen({ profileDir : profile, locking : 0 }).storage;
    var exp2 = { redo : [], undo : [] };
    test.equivalent( got2, exp2 );

    return null;
  })

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.arrangement.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '1 arrangement';
    test.identical( op.exitCode, 0 );

    var got1 =  _global_.wTools.censor.arrangementOpen({ profileDir : profile, locking : 0 }).storage;
    test.equivalent( got1.undo, [] );
    test.equivalent( got1.redo[ 0 ].name, `action::replace 3 in ${a.abs( 'before/File1.txt' )}` )
    var expDesc1 =
`
+ replace 3 in ❮foreground : dark cyan❯${a.abs( 'before/File1.txt' )}❮foreground : default❯\n`
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯1❮foreground : default❯ : ❮inputRaw:1❯First ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯2❮foreground : default❯ : ❮inputRaw:1❯Second line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯1❮foreground : default❯ : ❮inputRaw:1❯First line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯2❮foreground : default❯ : ❮inputRaw:1❯Second ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯3❮foreground : default❯ : ❮inputRaw:1❯Third line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯2❮foreground : default❯ : ❮inputRaw:1❯Second line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯3❮foreground : default❯ : ❮inputRaw:1❯Third ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯4❮foreground : default❯ : ❮inputRaw:1❯Last one❮inputRaw:0❯'

    test.equivalent( got1.redo[ 0 ].redoDescription2, expDesc1 )

    test.equivalent( got1.redo[ 1 ].name, `action::replace 5 in ${a.abs( 'before/File2.txt' )}` )
    var expDesc2 =
`
+ replace 5 in ❮foreground : dark cyan❯${a.abs( 'before/File2.txt' )}❮foreground : default❯\n`
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯1❮foreground : default❯ : ❮inputRaw:1❯First ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯2❮foreground : default❯ : ❮inputRaw:1❯Second line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯1❮foreground : default❯ : ❮inputRaw:1❯First line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯2❮foreground : default❯ : ❮inputRaw:1❯Second ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯3❮foreground : default❯ : ❮inputRaw:1❯Third line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯2❮foreground : default❯ : ❮inputRaw:1❯Second line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯3❮foreground : default❯ : ❮inputRaw:1❯Third ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯4❮foreground : default❯ : ❮inputRaw:1❯Fourth line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯3❮foreground : default❯ : ❮inputRaw:1❯Third line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯4❮foreground : default❯ : ❮inputRaw:1❯Fourth ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯5❮foreground : default❯ : ❮inputRaw:1❯Fifth line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯4❮foreground : default❯ : ❮inputRaw:1❯Fourth line❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯5❮foreground : default❯ : ❮inputRaw:1❯Fifth ❮inputRaw:0❯❮foreground : red❯line❮foreground : default❯❮foreground : green❯abc❮foreground : default❯❮inputRaw:1❯❮inputRaw:0❯\n'
+ '❮foreground : bright black❯❮foreground : default❯❮foreground : bright black❯6❮foreground : default❯ : ❮inputRaw:1❯Last one❮inputRaw:0❯'

    test.equivalent( got1.redo[ 1 ].redoDescription2, expDesc2 );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function arrangementDel( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();
  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    var exp =
`
+ replace 3 in ${ a.abs( 'before/File1.txt' )}
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 5 in ${a.abs( 'before/File2.txt' )}
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s).
`
    test.equivalent( op.output, exp );
    return null;
  } );
  a.appStart( `.arrangement.del profile:${profile}` );
  a.appStart( `.arrangement.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'delete arrangement';

    console.log( op.output )
    test.equivalent( op.output, 'null' );

    return null;
  });
  a.appStart( `.status profile:${profile}` )
  .then( ( op ) =>
  {
    test.equivalent( op.output, '' );

    return null;
  })

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.arrangement.del profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` );
  a.appStart( `.arrangement.del profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:abc2 sub:abc3 profile:${profile}` );
  a.appStart( `.arrangement.del profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:abc3 sub:abc4 profile:${profile}` );
  a.appStart( `.arrangement.del profile:${profile}` );
  a.appStart( `.arrangement.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'delete arrangement multiple times';

    console.log( op.output )
    test.equivalent( op.output, 'null' );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function storageLog( test )
{

  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let profile2 = `test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();
  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.storage.log verbosity:1` )
  .then( ( op ) =>
  {
    test.case = '1 replace command, 1 file in storage';
    var gotStr = JSON.stringify( op );

    test.true( gotStr.includes( 'arrangement.default.json' ) );
    test.identical( __.strCount( gotStr, 'arrangement.default.json' ), 1 );

    return null;
  })

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile2}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile2}` );
  a.appStart( `.storage.log verbosity:1` )
  .then( ( op ) =>
  {
    test.case = '4 replace commands, 2 profiles, 2 files in storage';
    var gotStr = JSON.stringify( op );

    test.true( gotStr.includes( 'arrangement.default.json' ) );
    test.identical( __.strCount( gotStr, 'arrangement.default.json' ), 2 );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.profile.del profile:${profile2}` );
  return a.ready;
}

storageLog.experimental = true;

//

function storageDel( test )
{

  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();
  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.storage.log` )
  .then( ( op ) =>
  {
    var exp = 'null';
    test.neq( op.output, exp );

    return null;
  });

  if( __.process.insideTestContainer() )
  a.appStart( '.storage.del' );

  a.appStart( '.storage.log' )
  .then( ( op ) =>
  {
    test.case = 'empty storage, after being full';

    test.equivalent( op.output, 'null' );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

storageDel.experimental = true;

//

function statusBasic( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  /* - */

  a.appStart( `.status profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'status empty';
    test.equivalent( op.output, '' );

    return null;
  } )

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.status profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'status not empty'
    var exp =
`
redo :
     + replace 3 in ${a.abs( 'before/File1.txt' )}
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Last one
     + replace 5 in ${a.abs( 'before/File2.txt' )}
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Fourth line
     3 : Third line
     4 : Fourth lineabc
     5 : Fifth line
     4 : Fourth line
     5 : Fifth lineabc
     6 : Last one

`
    test.eq( op.output, exp );

    return null;
  } )

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function statusOptionSession( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );
  let session1 = 'ses1';
  let session2 = 'ses2';

  a.reflect();

  /* - */

  a.appStart( `.status profile:${profile} session:${session1}` )
  .then( ( op ) =>
  {
    test.case = 'status empty';
    test.equivalent( op.output, '' );

    return null;
  } )

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session1}` );
  a.appStart( `.status profile:${profile} session:${session1}` )
  .then( ( op ) =>
  {
    test.case = 'not empty'
    var exp =
`
redo :
     + replace 3 in ${a.abs( 'before/File1.txt' )}
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Last one
     + replace 5 in ${a.abs( 'before/File2.txt' )}
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Fourth line
     3 : Third line
     4 : Fourth lineabc
     5 : Fifth line
     4 : Fourth line
     5 : Fifth lineabc
     6 : Last one
`
    test.eq( op.output, exp );

    return null;
  } )

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session1}` );
  a.appStart( `.status profile:${profile} session:${session2}` )
  .then( ( op ) =>
  {
    test.case = 'not empty, wrong session'
    var exp = ``;
    test.eq( op.output, exp );

    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

statusOptionSession.experimental = true;

//

function profileLog( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let profile2 = 'another_profile';
  let a = test.assetFor( 'basic' );

  a.reflect();

  /* - */

  a.appStart( `.profile.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'empty profile';

    test.equivalent( op.output, 'null' );

    return null;
  });

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.profile.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'profile with info';

    test.neq( op.output, 'null' );

    return null;
  });

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.profile.log profile:${profile2}` )
  .then( ( op ) =>
  {
    test.case = 'profile with info, wrong profile';

    test.eq( op.output, 'null' );

    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.profile.del profile:${profile2}` );
  return a.ready;
}

//

function profileDel( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.profile.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'profile with info';

    test.neq( op.output, 'null' );

    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );
  a.appStart( `.profile.log profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'deleted profile';

    test.eq( op.output, 'null' );

    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function identityList( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'list no identities';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.list` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, 'List of identities :\n{-no identies found-}\n' );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'list identities';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` )
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin type:git` )
  a.appStart( `.imply profile:${profile} .identity.list` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of identities :' ), 1 );
    test.identical( _.strCount( op.output, 'user :' ), 1 );
    test.identical( _.strCount( op.output, 'user2 :' ), 1 );
    test.identical( _.strCount( op.output, 'login : userLogin' ), 2 );
    test.identical( _.strCount( op.output, 'type : git' ), 2 );
    return null;
  });

  /* - */

  return a.ready;
}

//

function identityCopy( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'copy identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .identity.copy user user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function identitySet( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'rewrite all fields of identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.set user login:user type:npm` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : user, type : npm }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'rewrite one field of identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.set user login:user` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : user, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'extend identity by new fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.set user 'npm.login':user` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git, npm.login : user }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function identityNew( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login and type';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin type:git` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, type : git }' ), 1 );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login, type and user fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user3 login:userLogin type:git email:user@domain.com token:123` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user3` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'login : userLogin,' ), 1 );
    test.identical( _.strCount( op.output, 'type : git,' ), 1 );
    test.identical( _.strCount( op.output, 'email : user@domain.com,' ), 1 );
    test.identical( _.strCount( op.output, 'token : 123' ), 1 );
    return null;
  });

  /* - */

  a.appStartNonThrowing( `.imply profile:${profile} .identity.new user login:userLogin` )
  .then( ( op ) =>
  {
    test.case = 'declared no type';
    test.notIdentical( op.exitCode, 0 );
    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function gitIdentityNew( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user login:userLogin` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ git.login : userLogin, type : git }' ), 1 );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login, user fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user2 login:userLogin email:user@domain.com token:123` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'git.login : userLogin,' ), 1 );
    test.identical( _.strCount( op.output, 'type : git' ), 1 );
    test.identical( _.strCount( op.output, 'git.email : user@domain.com,' ), 1 );
    test.identical( _.strCount( op.output, 'git.token : 123' ), 1 );
    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function npmIdentityNew( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login';
    return null;
  });

  a.appStart( `.imply profile:${profile} .npm.identity.new user login:userLogin` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ npm.login : userLogin, type : npm }' ), 1 );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'subject and login, user fields';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user2 login:userLogin email:user@domain.com token:123` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity/user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'git.login : userLogin,' ), 1 );
    test.identical( _.strCount( op.output, 'type : git' ), 1 );
    test.identical( _.strCount( op.output, 'git.email : user@domain.com,' ), 1 );
    test.identical( _.strCount( op.output, 'git.token : 123' ), 1 );
    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function identityFromGit( test )
{
  let a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true );

  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  a.fileProvider.dirMake( a.abs( '.' ) );

  const originalConfig = a.fileProvider.fileRead( a.fileProvider.configUserPath( '.gitconfig' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'create new identity from git';
    return null;
  });

  a.appStart( `.imply profile:${profile} .git.identity.new user login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` );
  a.appStart( `.imply profile:${profile} .config.get identity/git` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.from.git git` )
  a.appStart( `.imply profile:${profile} .config.get identity/git` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ type : git, git.login : userLogin, git.email : user@domain.com }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'extend existed identity, force - 1';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin email:'user@domain.com' type:git` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login : userLogin, email : user@domain.com, type : git }' ), 1 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .identity.from.git user force:1` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'login : userLogin' ), 2 );
    test.identical( _.strCount( op.output, 'email : user@domain.com' ), 2 );
    test.identical( _.strCount( op.output, 'type : git' ), 1 );
    test.identical( _.strCount( op.output, 'git.login : userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'git.email : user@domain.com' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( () =>
  {
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), originalConfig );
    return null;
  })

  /* - */

  return a.ready;
}

//

function identityFromSsh( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  let a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profile }` );
  let originalExists = false;
  const originalPath = a.fileProvider.configUserPath( '.ssh' );
  const backupPath = a.fileProvider.configUserPath( '.ssh.bak' );
  if( _.fileProvider.fileExists( originalPath ) )
  originalExists = true;

  /* - */

  begin().then( ( op ) =>
  {
    test.case = 'create new identity from ssh';
    return null;
  });
  writeKey( 'id_rsa' );
  a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './ssh', './ssh/user', './ssh/user/id_rsa' ] );
    test.identical( _.strCount( op.output, `{ type : ssh, ssh.login : user, ssh.path : .censor/${profile}/ssh/user }` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  writeKey( 'id_rsa' );
  a.appStart( `.imply profile:${profile} .identity.from.ssh user` );
  a.appStart( `.imply profile:${profile} .identity.from.ssh user force:1` );
  a.appStart( `.imply profile:${profile} .config.get identity/user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './ssh', './ssh/user', './ssh/user/id_rsa' ] );
    test.identical( _.strCount( op.output, `{ type : ssh, ssh.login : user, ssh.path : .censor/${profile}/ssh/user }` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.filesDelete( originalPath );
    if( originalExists )
    {
      a.fileProvider.filesReflect
      ({
        reflectMap : { [ backupPath ] : originalPath }
      });
      a.fileProvider.filesDelete( backupPath );
    }
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      if( originalExists )
      {
        a.fileProvider.filesReflect
        ({
          reflectMap : { [ originalPath ] : backupPath }
        });
        a.fileProvider.filesDelete( originalPath );
      }
      return null;
    });
  }

  /* */

  function writeKey( name )
  {
    return a.ready.then( () =>
    {
      a.fileProvider.filesDelete( originalPath );
      a.fileProvider.fileWrite( a.abs( originalPath, name ), name );
      return null;
    });
  }
}

//

function identityRemove( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'remove single identity';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin2 type:git` );
  a.appStart( `.imply profile:${profile} .identity.remove user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user2' ), 1 );
    test.identical( _.strCount( op.output, 'user' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'try to remove with glob';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git` );
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin2 type:git` );
  a.appStart( `.imply profile:${profile} .identity.remove user*` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .config.get identity` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'user2' ), 1 );
    test.identical( _.strCount( op.output, 'user' ), 2 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function gitIdentityScript( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'get default script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:git login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /function .*\( identity, options \)/ ), 1 );
    test.identical( _.strCount( op.output, 'module.exports = onIdentity;' ), 0 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'get user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:git login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .git.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, script ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function npmIdentityScript( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'get default script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:npm login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /function .*\( identity, options \)/ ), 1 );
    test.identical( _.strCount( op.output, 'module.exports = onIdentity;' ), 0 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'get user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:super identities:'{user2:true}'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .npm.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, script ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function sshIdentityScript( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'get default script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .ssh.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /function .*\( identity, options \)/ ), 1 );
    test.identical( _.strCount( op.output, 'module.exports = onIdentity;' ), 0 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'get user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .ssh.identity.script` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, script ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function gitIdentityScriptSet( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'set git script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:git login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ type: \'git\', login: \'userLogin\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function npmIdentityScriptSet( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  a.reflect();

  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'set git script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user type:npm login:userLogin email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .npm.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ type: \'npm\', login: \'userLogin\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function sshIdentityScriptSet( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  let a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profile }` );
  let originalExists = false;
  const originalPath = a.fileProvider.configUserPath( '.ssh' );
  const backupPath = a.fileProvider.configUserPath( '.ssh.bak' );
  if( _.fileProvider.fileExists( originalPath ) )
  originalExists = true;
  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  begin()

  /* - */

  writeKey( 'id_rsa' ).then( ( op ) =>
  {
    test.case = 'set ssh script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.appStart( `.imply profile:${profile} .ssh.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'type: \'ssh\',' ), 1 );
    test.identical( _.strCount( op.output, '\'ssh.login\': \'user\',' ), 1 );
    test.identical( _.strCount( op.output, `'ssh.path': '.censor/${profile}/ssh/user'` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.filesDelete( originalPath );
    if( originalExists )
    {
      a.fileProvider.filesReflect
      ({
        reflectMap : { [ backupPath ] : originalPath }
      });
      a.fileProvider.filesDelete( backupPath );
    }
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      if( originalExists )
      {
        a.fileProvider.filesReflect
        ({
          reflectMap : { [ originalPath ] : backupPath }
        });
        a.fileProvider.filesDelete( originalPath );
      }
      return null;
    });
  }

  /* */

  function writeKey( name )
  {
    return a.ready.then( () =>
    {
      a.fileProvider.filesDelete( originalPath );
      a.fileProvider.fileWrite( a.abs( originalPath, name ), name );
      return null;
    });
  }
}

//

function gitIdentityUse( test )
{
  const a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true );

  a.fileProvider.dirMake( a.abs( '.' ) );
  const originalConfig = a.fileProvider.fileRead( a.fileProvider.configUserPath( '.gitconfig' ) );
  const profile = `censor-test-${ __.intRandom( 1000000 ) }`;

  const script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'use default identity scripts';
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'change identities';
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .identity.new user2 login:userLogin2 type:git email:'user2@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  a.appStart( `.imply profile:${profile} .git.identity.use user2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin2' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user2@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'custom user script';
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:git email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .git.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login: \'userLogin\', type: \'git\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( op.output, '' );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  // a.ready.then( ( op ) => /* qqq : for Dmytro : repair */
  // {
  //   test.case = 'custom user script, type - super';
  //   a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
  //   return null;
  // });
  //
  // a.appStart( `.imply profile:${profile} .identity.new user login:userLogin email:'user@domain.com' type:git` );
  // a.appStart( `.imply profile:${profile} .identity.new user2 type:super identities:{user:true}` );
  // a.appStart( `.imply profile:${profile} .git.identity.script.set '${ script }'` )
  // a.appStart( `.imply profile:${profile} .git.identity.use user2` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //   test.identical( _.strCount( op.output, '{ login: \'userLogin\', email: \'user@domain.com\', type: \'git\' }' ), 1 );
  //   return null;
  // });
  // a.shell( 'git config --global --list' )
  // .then( ( op ) =>
  // {
  //   test.identical( op.output, '' );
  //   return null;
  // });
  // a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), originalConfig );
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;
}

//

function npmIdentityUse( test )
{
  const a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  const profile = `censor-test-${ __.intRandom( 1000000 ) }`;

  const script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'custom user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.new user login:userLogin type:npm email:'user@domain.com'` );
  a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .npm.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '{ login: \'userLogin\', type: \'npm\', email: \'user@domain.com\' }' ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  // a.ready.then( ( op ) => /* qqq2 : for Dmytro : repair */
  // {
  //   test.case = 'custom user script, type - general';
  //   return null;
  // });
  //
  // a.appStart( `.imply profile:${profile} .identity.new user login:userLogin email:'user@domain.com'` );
  // a.appStart( `.imply profile:${profile} .npm.identity.script.set '${ script }'` )
  // a.appStart( `.imply profile:${profile} .npm.identity.use user` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //   test.identical( _.strCount( op.output, '{ login: \'userLogin\', email: \'user@domain.com\', type: \'general\' }' ), 1 );
  //   return null;
  // });
  // a.appStart( `.profile.del profile:${profile}` );

  /* - */

  return a.ready;
}

//

function sshIdentityUse( test )
{
  if( !_.process.insideTestContainer() )
  return test.true( true );

  let a = test.assetFor( false );
  a.fileProvider.dirMake( a.abs( '.' ) );
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profile }` );
  let originalExists = false;
  const originalPath = a.fileProvider.configUserPath( '.ssh' );
  const backupPath = a.fileProvider.configUserPath( '.ssh.bak' );
  if( _.fileProvider.fileExists( originalPath ) )
  originalExists = true;
  let script =
`
function onIdentity( identity )
{
  console.log( identity );
}
module.exports = onIdentity;
`;

  begin()
  writeKey( 'id_rsa' );

  /* - */


  a.ready.then( ( op ) =>
  {
    test.case = 'custom user script';
    return null;
  });

  a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  a.appStart( `.imply profile:${profile} .ssh.identity.use user` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'type: \'ssh\',' ), 1 );
    test.identical( _.strCount( op.output, '\'ssh.login\': \'user\',' ), 1 );
    test.identical( _.strCount( op.output, `'ssh.path': '.censor/${profile}/ssh/user'` ), 1 );
    return null;
  });
  a.appStart( `.profile.del profile:${profile}` );

  /* */

  // a.ready.then( ( op ) => /* qqq2 : for Dmytro : repair */
  // {
  //   test.case = 'custom user script, type - general';
  //   return null;
  // });
  //
  // a.appStart( `.imply profile:${profile} .identity.from.ssh user` )
  // a.appStart( `.imply profile:${profile} .identity.set user login:userLogin type:general email:'user@domain.com'` );
  // a.appStart( `.imply profile:${profile} .ssh.identity.script.set '${ script }'` )
  // a.appStart( `.imply profile:${profile} .ssh.identity.use user` )
  // .then( ( op ) =>
  // {
  //   test.identical( op.exitCode, 0 );
  //   test.identical( _.strCount( op.output, 'login: \'userLogin\',' ), 1 );
  //   test.identical( _.strCount( op.output, 'email: \'user@domain.com\'' ), 1 );
  //   test.identical( _.strCount( op.output, 'type: \'general\',' ), 1 );
  //   test.identical( _.strCount( op.output, '\'ssh.login\': \'user\',' ), 1 );
  //   test.identical( _.strCount( op.output, `'ssh.path': '.censor/${profile}/ssh/user'` ), 1 );
  //   return null;
  // });
  // a.appStart( `.profile.del profile:${profile}` );

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.filesDelete( originalPath );
    if( originalExists )
    {
      a.fileProvider.filesReflect
      ({
        reflectMap : { [ backupPath ] : originalPath }
      });
      a.fileProvider.filesDelete( backupPath );
    }
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      if( originalExists )
      {
        a.fileProvider.filesReflect
        ({
          reflectMap : { [ originalPath ] : backupPath }
        });
        a.fileProvider.filesDelete( originalPath );
      }
      return null;
    });
  }

  /* */

  function writeKey( name )
  {
    return a.ready.then( () =>
    {
      a.fileProvider.filesDelete( originalPath );
      a.fileProvider.fileWrite( a.abs( originalPath, name ), name );
      return null;
    });
  }
}

//

function replaceBasic( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();
  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = '.replace filePath:before/** ins:line sub:abc';
    a.reflect();
    return null;
  })

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp =
`
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
 1 : First lineabc
 2 : Second line
 1 : First line
 2 : Second lineabc
 3 : Third line
 2 : Second line
 3 : Third lineabc
 4 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 1 : First lineabc
 2 : Second line
 1 : First line
 2 : Second lineabc
 3 : Third line
 2 : Second line
 3 : Third lineabc
 4 : Fourth line
 3 : Third line
 4 : Fourth lineabc
 5 : Fifth line
 4 : Fourth line
 5 : Fifth lineabc
 6 : Last one
. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s).

`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceStatusOptionVerbosity( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();
  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.description = 'setup';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.status v:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
  redo : 2
  undo : 0
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* */

  a.appStart( `.status v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.status v:2';
    test.identical( op.exitCode, 0 );

    var exp =
`
  redo :
     + replace 3 in ${ a.abs( 'before/File1.txt' ) }
     + replace 5 in ${ a.abs( 'before/File2.txt' ) }
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* */

  a.appStart( `.status profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.status';
    test.identical( op.exitCode, 0 );

    var exp =
`
redo :
  + replace 3 in ${ a.abs( 'before/File1.txt' ) }
  1 : First lineabc
  2 : Second line
  1 : First line
  2 : Second lineabc
  3 : Third line
  2 : Second line
  3 : Third lineabc
  4 : Last one
  + replace 5 in ${ a.abs( 'before/File2.txt' ) }
  1 : First lineabc
  2 : Second line
  1 : First line
  2 : Second lineabc
  3 : Third line
  2 : Second line
  3 : Third lineabc
  4 : Fourth line
  3 : Third line
  4 : Fourth lineabc
  5 : Fifth line
  4 : Fourth line
  5 : Fifth lineabc
  6 : Last one
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* */

  a.appStart( `.status v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.status v:3';
    test.identical( op.exitCode, 0 );

    var exp =
`
redo :
  + replace 3 in ${ a.abs( 'before/File1.txt' ) }
  1 : First lineabc
  2 : Second line
  1 : First line
  2 : Second lineabc
  3 : Third line
  2 : Second line
  3 : Third lineabc
  4 : Last one
  + replace 5 in ${ a.abs( 'before/File2.txt' ) }
  1 : First lineabc
  2 : Second line
  1 : First line
  2 : Second lineabc
  3 : Third line
  2 : Second line
  3 : Third lineabc
  4 : Fourth line
  3 : Third line
  4 : Fourth lineabc
  5 : Fifth line
  4 : Fourth line
  5 : Fifth lineabc
  6 : Last one
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceRedoOptionVerbosity( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:0';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:1';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.status v:1 profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:2';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:3';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'verbosity : default';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
    1 : First lineabc
    2 : Second line
    1 : First line
    2 : Second lineabc
    3 : Third line
    2 : Second line
    3 : Third lineabc
    4 : Last one
  + replace 3 in ${ a.abs( 'before/File1.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceRedoOptionVerbosity.timeOut = 600000;

//

function replaceRedoOptionDepth( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'd:1';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })
  a.ready.then( ( op ) =>
  {
    test.case = 'd:1';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'd:2';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'd:3';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'd:0';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'd : default';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceRedoOptionDepth.timeOut = 600000;

//

function replaceChangeRedo( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'outdated File1.txt';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1Before + 'xyz' );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to redo action::replace 3 in ${ a.abs( 'before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
 + replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1 -- 1 error(s)
undo : 1
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to redo action::replace 3 in ${ a.abs( 'before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File1.txt' ) }
 + Done 0 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1 -- 1 error(s)
undo : 1
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1Before );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'outdated File2.txt';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2Before + 'xyz' );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
 + replace 3 in ${ a.abs( 'before/File1.txt' ) }
 ! failed to redo action::replace 5 in ${ a.abs( 'before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1 -- 1 error(s)
undo : 1
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to redo action::replace 5 in ${ a.abs( 'before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File2.txt' ) }
 + Done 0 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1 -- 1 error(s)
undo : 1
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2Before );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'outdated File1.txt File2.txt';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1Before + 'xyz' );
    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2Before + 'xyz' );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to redo action::replace 3 in ${ a.abs( 'before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File1.txt' ) }
 ! failed to redo action::replace 5 in ${ a.abs( 'before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File2.txt' ) }
 + Done 0 action(s). Thrown 2 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2 -- 2 error(s)
undo : 0
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to redo action::replace 3 in ${ a.abs( 'before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File1.txt' ) }
 ! failed to redo action::replace 5 in ${ a.abs( 'before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File2.txt' ) }
 + Done 0 action(s). Thrown 2 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2 -- 2 error(s)
undo : 0
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1Before );
    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2Before );

    return null;
  })

  a.appStartNonThrowing( `.redo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceRedoDepth0OptionVerbosity( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();
  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:0';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:1';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:2';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:3';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'verbosity : default';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.do profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.do';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to redo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceRedoHardLinked( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();
    a.fileProvider.hardLink
    ({
      dstPath : a.abs( 'before/dir/Link.txt' ),
      srcPath : a.abs( 'before/File1.txt' ),
      makingDirectory : 1,
    });
    test.true( a.fileProvider.areHardLinked( a.abs( 'before/dir/Link.txt' ), a.abs( 'before/File1.txt' ) ) );
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
  redo :
     + replace 3 in ${ a.abs( 'before/File1.txt' ) }
     + replace 5 in ${ a.abs( 'before/File2.txt' ) }
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
 + replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
 + replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/File1.txt',
      './before/File2.txt',
      './before/dir',
      './before/dir/Link.txt',
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );
    var got = a.fileProvider.fileRead( a.abs( 'before/dir/Link.txt' ) );
    test.identical( got, file1After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'dir only';
    a.reflect();
    a.fileProvider.hardLink
    ({
      dstPath : a.abs( 'before/dir/Link.txt' ),
      srcPath : a.abs( 'before/File1.txt' ),
      makingDirectory : 1,
    });
    test.true( a.fileProvider.areHardLinked( a.abs( 'before/dir/Link.txt' ), a.abs( 'before/File1.txt' ) ) );
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/dir/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
  redo :
     + replace 3 in ${ a.abs( 'before/dir/Link.txt' ) }
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
 + replace 3 in ${ a.abs( 'before/dir/Link.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/File1.txt',
      './before/File2.txt',
      './before/dir',
      './before/dir/Link.txt',
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/dir/Link.txt' ) );
    test.identical( got, file1After );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceRedoSoftLinked( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();
    a.fileProvider.softLink
    ({
      dstPath : a.abs( 'before/dir/Link.txt' ),
      srcPath : a.abs( 'before/File1.txt' ),
      makingDirectory : 1,
    });
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir/Link.txt' ), a.abs( 'before/File1.txt' ) ) );
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
  redo :
     + replace 3 in ${ a.abs( 'before/File1.txt' ) }
     + replace 5 in ${ a.abs( 'before/File2.txt' ) }
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
 + replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
 + replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/File1.txt',
      './before/File2.txt',
      './before/dir',
      './before/dir/Link.txt',
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );
    var got = a.fileProvider.fileRead( a.abs( 'before/dir/Link.txt' ) );
    test.identical( got, file1After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'dir only';
    a.reflect();
    a.fileProvider.softLink
    ({
      dstPath : a.abs( 'before/dir/Link.txt' ),
      srcPath : a.abs( 'before/File1.txt' ),
      makingDirectory : 1,
    });
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir/Link.txt' ), a.abs( 'before/File1.txt' ) ) );
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/dir/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
  redo :
     + replace 3 in ${ a.abs( 'before/dir/Link.txt' ) }
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
 + replace 3 in ${ a.abs( 'before/dir/Link.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/File1.txt',
      './before/File2.txt',
      './before/dir',
      './before/dir/Link.txt',
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/dir/Link.txt' ) );
    test.identical( got, file1After );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'dir only';
    a.reflect();
    a.fileProvider.dirMake( a.abs( 'before/dir1' ) );
    a.fileProvider.softLink
    ({
      dstPath : a.abs( 'before/dir2' ),
      srcPath : a.abs( 'before/dir1' ),
      makingDirectory : 1,
    });
    a.fileProvider.softLink
    ({
      dstPath : a.abs( 'before/dir2/Link.txt' ),
      srcPath : a.abs( 'before/File1.txt' ),
      makingDirectory : 1,
    });

    test.true( !a.fileProvider.isSoftLink( a.abs( 'before/dir1' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/dir1/Link.txt' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/dir2' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/dir2/Link.txt' ) ) );

    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir2' ), a.abs( 'before/dir1' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir2/Link.txt' ), a.abs( 'before/dir1/Link.txt' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir2/Link.txt' ), a.abs( 'before/File1.txt' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir1/Link.txt' ), a.abs( 'before/File1.txt' ) ) );

    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/dir2/** ins:line sub:abc profile:${profile}` )

  a.appStart( `.status v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
  redo :
     + replace 3 in ${ a.abs( 'before/dir2/Link.txt' ) }
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
 + replace 3 in ${ a.abs( 'before/dir2/Link.txt' ) }
 + Done 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/File1.txt',
      './before/File2.txt',
      './before/dir1',
      './before/dir1/Link.txt',
      './before/dir2',
      './before/dir2/Link.txt'
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/dir2/Link.txt' ) );
    test.identical( got, file1After );

    test.true( !a.fileProvider.isSoftLink( a.abs( 'before/dir1' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/dir1/Link.txt' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/dir2' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/dir2/Link.txt' ) ) );

    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir2' ), a.abs( 'before/dir1' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir2/Link.txt' ), a.abs( 'before/dir1/Link.txt' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir2/Link.txt' ), a.abs( 'before/File1.txt' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'before/dir1/Link.txt' ), a.abs( 'before/File1.txt' ) ) );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceRedoBrokenSoftLink( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();
    a.fileProvider.softLink
    ({
      dstPath : a.abs( 'before/missed.txt' ),
      srcPath : a.abs( 'before/x' ),
      makingDirectory : 1,
      allowingCycled : 1,
      allowingMissed : 1,
      sync : 1
    });
    a.fileProvider.softLink
    ({
      dstPath : a.abs( 'before/cycled.txt' ),
      srcPath : a.abs( 'before/cycled.txt' ),
      makingDirectory : 1,
      allowingCycled : 1,
      allowingMissed : 1,
      sync : 1
    });
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/missed.txt' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 'before/cycled.txt' ) ) );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/cycled.txt',
      './before/File1.txt',
      './before/File2.txt',
      './before/missed.txt'
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.equivalent( files, exp );

    return null;
  });

  a.appStart( `.replace filePath:'before/**' ins:line sub:abc profile:${profile}` )
  a.appStart( `.do profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = `.do`;
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '+ Done 2 action(s). Thrown 0 error(s).' ), 1 );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/cycled.txt',
      './before/File1.txt',
      './before/File2.txt',
      './before/missed.txt'
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    var exp = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, exp );

    var exp = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, exp );

    return null;
  });

  /* */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceRedoBrokenSoftLink.experimental = true;

//

function replaceRedoTextLink( test )
{
  let context = this;
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  a.ready.then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();
    a.fileProvider.fieldPush( 'usingTextLink', 1 );

    a.fileProvider.textLink
    ({
      dstPath : a.abs( 'before/textLink.txt' ),
      srcPath : a.abs( 'before/File1.txt' ),
      makingDirectory : 1,
      allowingCycled : 1,
      allowingMissed : 1,
    });

    test.true( a.fileProvider.isTextLink( a.abs( 'before/dir/textLink.txt' ) ) );
    test.true( a.fileProvider.areTextLinked( a.abs( 'before/dir/textlink.txt' ), a.abs( 'before/File1.txt' ) ) );

    return null;
  });

  a.appStart( `.replace filePath:before/textLink.txt ins:line sub:abc usingTextLink:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'textlink to File1.txt';
    test.identical( op.exitCode, 0 );
    var exp =
`
+ replace 3 in ${ a.abs( 'before/textLink.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
. Found 1 file(s). Arranged 3 replacement(s) in 1 file(s).
`;
    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.arrangement.del profile:${profile}` );

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();
    a.fileProvider.fieldPush( 'usingTextLink', 1 );

    a.fileProvider.textLink
    ({
      dstPath : a.abs( 'before/textLink2.txt' ),
      srcPath : a.abs( 'before/File2.txt' ),
      makingDirectory : 1,
      allowingCycled : 1,
      allowingMissed : 1,
    });
    test.true( a.fileProvider.areTextLinked( a.abs( 'before/dir/Link.txt' ), a.abs( 'before/dir/Link.txt' ) ) );
    return null;
  });

  a.appStart( `.replace filePath:before/textLink2.txt ins:line sub:abc usingTextLink:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = 'textlink to File2.txt';
    test.identical( op.exitCode, 0 );
    var exp =
`
+ replace 5 in ${ a.abs( 'before/textLink2.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
. Found 1 file(s). Arranged 5 replacement(s) in 1 file(s).
`;
    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.arrangement.del profile:${profile}` );

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceRedoTextLink.experimental = true;

//

function replaceRedoBrokenTextLink( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'tlink' );

  a.reflect();

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();

    a.fileProvider.fieldPush( 'usingTextLink', 1 );
    a.fileProvider.textLink
    ({
      dstPath : a.abs( 'before/missed.txt' ),
      srcPath : a.abs( 'before/x' ),
      makingDirectory : 1,
      allowingCycled : 1,
      allowingMissed : 1,
      sync : 1,
    });
    a.fileProvider.textLink
    ({
      dstPath : a.abs( 'before/cycled.txt' ),
      srcPath : a.abs( 'before/cycled.txt' ),
      makingDirectory : 1,
      allowingCycled : 1,
      allowingMissed : 1,
      sync : 1,
    });

    test.true( a.fileProvider.isTextLink( a.abs( 'before/missed.txt' ) ) );
    test.true( a.fileProvider.isTextLink( a.abs( 'before/cycled.txt' ) ) );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/cycled.txt',
      './before/File1.txt',
      './before/File2.txt',
      './before/missed.txt'
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.equivalent( files, exp );

    return null;
  });

  a.appStart( `.replace filePath:'before/**' ins:line sub:abc profile:${profile}` )
  a.appStart( `.do profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = `.do`;
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '+ Done 2 action(s). Thrown 0 error(s).' ), 1 );

    var exp =
    [
      '.',
      './after',
      './after/File1.txt',
      './after/File2.txt',
      './before',
      './before/cycled.txt',
      './before/File1.txt',
      './before/File2.txt',
      './before/missed.txt'
    ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    var exp = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, exp );

    var exp = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, exp );

    return null;
  });

  /* */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceRedoBrokenTextLink.experimental = true;

//

function replaceBigFile( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );
  let times = 1e6;
  let originalData = __.dup( '1234567890\n', times ) + 'ins1';
  let expectedData = __.dup( '1234567890\n', times ) + 's';

  /* */

  a.ready.then( ( op ) =>
  {
    a.reflect();
    a.fileProvider.fileWrite( a.abs( 'File.txt' ), originalData );
    return null;
  });

  a.appStartNonThrowing( `.replace filePath:** ins:ins1 sub:s profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = `.replace filePath:** ins:ins1 sub:s`;
    test.nil( op.exitCode, 0 );
    test.identical( __.strCount( op.output, `File ${a.abs( 'File.txt' )} is too big` ), 1 );

    var exp = [ '.', './File.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'File.txt' ) );
    test.identical( got.length, originalData.length );
    test.true( got === originalData );

    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    a.reflect();
    a.fileProvider.fileWrite( a.abs( 'File.txt' ), originalData );
    return null;
  });

  a.appStart( `.replace filePath:** ins:ins1 sub:s fileSizeLimit:100000000 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = `.replace filePath:** ins:ins1 sub:s`;
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 1 file(s). Arranged 1 replacement(s) in 1 file(s).' ), 1 );

    var exp = [ '.', './File.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'File.txt' ) );
    test.identical( got.length, originalData.length );
    test.true( got === originalData );

    return null;
  });

  a.appStart( `.do profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = `.do`;
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '+ Done 1 action(s). Thrown 0 error(s).' ), 1 );

    var exp = [ '.', './File.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'File.txt' ) );
    test.identical( got.length, expectedData.length );
    test.true( got === expectedData );

    return null;
  });

  /* */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceBigFile.rapidity = -1;

// --
// redo - undo
// --

function replaceRedoUndo( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.replace filePath:before/** ins:line sub:abc';
    test.identical( op.exitCode, 0 );
    test.identical( __.strCount( op.output, '. Found 2 file(s). Arranged 8 replacement(s) in 2 file(s)' ), 1 );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.status v:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );
    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo';
    test.identical( op.exitCode, 0 );

    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  a.appStart( `.undo d:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceRedoChangeUndo( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'outdated File1.txt';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1After + 'xyz' );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 + undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
 ! failed to undo action::replace 3 in ${ a.abs( 'before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1 -- 1 error(s)
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to undo action::replace 3 in ${ a.abs( 'before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File1.txt' ) }
- Undone 0 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1 -- 1 error(s)
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1After );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${a.abs( 'before/File1.txt' )}
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'outdated File2.txt';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2After + 'xyz' );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to undo action::replace 5 in ${ a.abs( 'before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File2.txt' ) }
 + undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1 -- 1 error(s)
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to undo action::replace 5 in ${ a.abs( 'before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( 'before/File2.txt' ) }
- Undone 0 action(s). Thrown 1 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 1
undo : 1 -- 1 error(s)
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2After );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 5 in ${a.abs( 'before/File2.txt' )}
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'outdated File2.txt';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.redo d:0 v:3 profile:${profile}` )
  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1After + 'xyz' );
    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2After + 'xyz' );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to undo action::replace 5 in ${ a.abs( './before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( './before/File2.txt' ) }
 ! failed to undo action::replace 3 in ${ a.abs( './before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( './before/File1.txt' ) }
- Undone 0 action(s). Thrown 2 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2 -- 2 error(s)
`
    test.equivalent( op.output, exp );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.notIdentical( op.exitCode, 0 );

    var exp =
`
 ! failed to undo action::replace 5 in ${ a.abs( './before/File2.txt' ) }
    Files are outdated:
      ${ a.abs( './before/File2.txt' ) }
 ! failed to undo action::replace 3 in ${ a.abs( './before/File1.txt' ) }
    Files are outdated:
      ${ a.abs( './before/File1.txt' ) }
- Undone 0 action(s). Thrown 2 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After + 'xyz' );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After + 'xyz' );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 0
undo : 2 -- 2 error(s)
`
    test.equivalent( op.output, exp );

    a.fileProvider.fileWrite( a.abs( 'before/File1.txt' ), file1After );
    a.fileProvider.fileWrite( a.abs( 'before/File2.txt' ), file2After );

    return null;
  })

  a.appStartNonThrowing( `.undo d:0 v:3  profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 5 in ${ a.abs( './before/File2.txt' ) }
+ undo replace 3 in ${ a.abs( './before/File1.txt' ) }
- Undone 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var exp = [ '.', './after', './after/File1.txt', './after/File2.txt', './before', './before/File1.txt', './before/File2.txt' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.status v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.status';
    test.identical( op.exitCode, 0 );
    var exp =
`
redo : 2
undo : 0
`
    test.equivalent( op.output, exp );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceRedoUndoOptionVerbosity( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'verbosity : default';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.redo d:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  a.appStart( `.undo d:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .redo .undo .undo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:3';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  a.appStart( `.redo d:1 v:3 profile:${profile}` )
  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  a.appStart( `.undo d:1 v:3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .redo .undo .undo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:2';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  a.appStart( `.redo d:1 v:2 profile:${profile}` )
  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  a.appStart( `.undo d:1 v:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .redo .undo .undo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:1';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
- Undone 1 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  a.appStart( `.redo d:1 v:1 profile:${profile}` )
  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  a.appStart( `.undo d:1 v:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .redo .undo .undo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
Nothing to undo.
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'v:0';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.undo d:1';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  a.appStart( `.redo d:1 v:0 profile:${profile}` )
  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  a.appStart( `.undo d:1 v:0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.redo d:1 .redo .redo .undo .undo .undo';
    test.identical( op.exitCode, 0 );

    var exp =
`
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceRedoUndoOptionVerbosity.timeOut = 600000;

//


function replaceRedoUndoOptionDepth( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  test.open( 'undo depth' );

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.undo profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo default depth, undo all actions';
    test.identical( op.exitCode, 0 );

    var exp =
`
    + undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
    + undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
    + undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
    + undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
  - Undone 4 action(s). Thrown 0 error(s).
`;

    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo default depth, undo all actions, check files';
    test.identical( op.exitCode, 0 );

    var exp =
`
  + replace 3 in ${ a.abs( 'before/File1.txt' ) }
      1 : First lineabc
      2 : Second line
      1 : First line
      2 : Second lineabc
      3 : Third line
      2 : Second line
      3 : Third lineabc
      4 : Last one
  + replace 5 in ${ a.abs( 'before/File2.txt' ) }
      1 : First lineabc
      2 : Second line
      1 : First line
      2 : Second lineabc
      3 : Third line
      2 : Second line
      3 : Third lineabc
      4 : Fourth line
      3 : Third line
      4 : Fourth lineabc
      5 : Fifth line
      4 : Fourth line
      5 : Fifth lineabc
      6 : Last one
  . Found 2 file(s). Arranged 8 replacement(s) in 2 file(s).
`;

    test.equivalent( op.output, exp );

    return null;
  });

  a.appStart( `.arrangement.del profile:${profile}` )

  /* */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.undo depth:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo depth:1, depth < actions ( changes in 1 file )';
    test.identical( op.exitCode, 0 );

    var exp =
  `
      + undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
    - Undone 1 action(s). Thrown 0 error(s).
  `;

    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo depth:1, depth < actions ( changes in 1 file ), check files';
    test.identical( op.exitCode, 0 );

    var exp =
  `
  + replace 3 in ${ a.abs( 'before/File1.txt' ) }
  1 : First abcabc22
  2 : Second abc2
  1 : First abc2
  2 : Second abcabc22
  3 : Third abc2
  2 : Second abc2
  3 : Third abcabc22
  4 : Last one
  + replace 5 in ${ a.abs( 'before/File2.txt' ) }
  1 : First abcabc2
  2 : Second abc
  1 : First abc
  2 : Second abcabc2
  3 : Third abc
  2 : Second abc
  3 : Third abcabc2
  4 : Fourth abc
  3 : Third abc
  4 : Fourth abcabc2
  5 : Fifth abc
  4 : Fourth abc
  5 : Fifth abcabc2
  6 : Last one
  . Found 2 file(s). Arranged 8 replacement(s) in 2 file(s).
  `;

    test.equivalent( op.output, exp );

    return null;
  });

  reverseChanges();

  /* */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.undo depth:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo depth:2, depth = actions ( changes in 2 files )';
    test.identical( op.exitCode, 0 );

    var exp =
`
    + undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
    + undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
  - Undone 2 action(s). Thrown 0 error(s).
`;

    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo depth:2, depth = actions ( changes in 2 files ), check files';
    test.identical( op.exitCode, 0 );

    var exp =
  `
  + replace 3 in ${ a.abs( 'before/File1.txt' ) }
  1 : First abcabc2
  2 : Second abc
  1 : First abc
  2 : Second abcabc2
  3 : Third abc
  2 : Second abc
  3 : Third abcabc2
  4 : Last one
  + replace 5 in ${ a.abs( 'before/File2.txt' ) }
  1 : First abcabc2
  2 : Second abc
  1 : First abc
  2 : Second abcabc2
  3 : Third abc
  2 : Second abc
  3 : Third abcabc2
  4 : Fourth abc
  3 : Third abc
  4 : Fourth abcabc2
  5 : Fifth abc
  4 : Fourth abc
  5 : Fifth abcabc2
  6 : Last one
  . Found 2 file(s). Arranged 8 replacement(s) in 2 file(s).
  `;

    test.equivalent( op.output, exp );

    return null;
  });

  reverseChanges();

  /* */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` );
  a.appStart( `.redo profile:${profile}` );
  a.appStart( `.undo depth:10 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo depth:10, depth > actions';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
+ undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
+ undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
- Undone 4 action(s). Thrown 0 error(s).
`;

    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.replace filePath:before/** ins:abc sub:abc2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.undo depth:10, depth > actions, check files';
    test.identical( op.exitCode, 0 );

    var exp =
  `
  . Found 2 file(s). Arranged 0 replacement(s) in 0 file(s).
  `;

    test.equivalent( op.output, exp );

    return null;
  });

  test.close( 'undo depth' );

  /* - */

  test.open( 'redo depth' );

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.redo depth:1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.redo depth:1, depth < actions';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
+ Done 1 action(s). Thrown 0 error(s).
`;

    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.redo depth:1, depth < actions, check files';
    test.identical( op.exitCode, 0 );

    var exp =
  `
  + replace 5 in ${ a.abs( 'before/File2.txt' ) }
  1 : First lineabc
  2 : Second line
  1 : First line
  2 : Second lineabc
  3 : Third line
  2 : Second line
  3 : Third lineabc
  4 : Fourth line
  3 : Third line
  4 : Fourth lineabc
  5 : Fifth line
  4 : Fourth line
  5 : Fifth lineabc
  6 : Last one
  . Found 2 file(s). Arranged 5 replacement(s) in 1 file(s).
  `;

    test.equivalent( op.output, exp );

    return null;
  });

  reverseChanges();

  /* */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.redo depth:2 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.redo depth:2, depth = actions';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
+ Done 2 action(s). Thrown 0 error(s).
`;

    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.redo depth:2, depth = actions, check files';
    test.identical( op.exitCode, 0 );

    var exp =
  `
  . Found 2 file(s). Arranged 0 replacement(s) in 0 file(s).
  `;

    test.equivalent( op.output, exp );

    return null;
  });

  reverseChanges();

  /* */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` );
  a.appStart( `.redo depth:10 profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.redo depth:10, depth > actions';
    test.identical( op.exitCode, 0 );

    var exp =
`
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Last one
+ replace 3 in ${ a.abs( 'before/File1.txt' ) }
1 : First lineabc
2 : Second line
1 : First line
2 : Second lineabc
3 : Third line
2 : Second line
3 : Third lineabc
4 : Fourth line
3 : Third line
4 : Fourth lineabc
5 : Fifth line
4 : Fourth line
5 : Fifth lineabc
6 : Last one
+ replace 5 in ${ a.abs( 'before/File2.txt' ) }
+ Done 2 action(s). Thrown 0 error(s).
`;

    test.equivalent( op.output, exp );

    return null;
  } );

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile}` )
  .then( ( op ) =>
  {
    test.case = '.redo depth:10, depth > actions, check files';
    test.identical( op.exitCode, 0 );

    var exp =
  `
  . Found 2 file(s). Arranged 0 replacement(s) in 0 file(s).
  `;

    test.equivalent( op.output, exp );

    return null;
  });

  reverseChanges();

  test.close( 'redo depth' );

  /* - */

  reverseChanges()
  .then( ( op ) =>
  {
    test.case = 'check files to be unchanged';
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  } )

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;

  //

  function reverseChanges()
  {
    a.appStart( `.replace filePath:before/** ins:abc2 sub:line profile:${profile}` );
    a.appStart( `.redo profile:${profile}` );
    a.appStart( `.replace filePath:before/** ins:abc sub:line profile:${profile}` );
    return a.appStart( `.redo profile:${profile}` );
  }

}

replaceRedoUndoOptionDepth.experimental = true;

//

function replaceOptionSession( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let session1 = 'ses1';
  let session2 = 'ses2';
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session1}` );
  a.appStart( `.storage.log` )
  .then( ( op ) =>
  {
    test.case = '1 arrangement, 2 session'

    var got = _global_.wTools.censor.storageRead();
    var got1Str = JSON.stringify( op );
    var got2Str = JSON.stringify( got );

    test.true( got1Str.includes( `arrangement.${session1}.json` ) );
    test.true( got2Str.includes( `arrangement.${session1}.json` ) );

    test.identical( __.strCount( got2Str, '.json' ), 2 );
    return null;
  });

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session1}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session2}` );
  a.appStart( `.storage.log` )
  .then( ( op ) =>
  {
    // console.log( 'STORAGE: ', _global_.wTools.censor.storageRead() );

    test.case = '2 arrangement, 3 session'

    var got = _global_.wTools.censor.storageRead();
    var got1Str = JSON.stringify( op );
    var got2Str = JSON.stringify( got );

    test.true( got1Str.includes( `arrangement.${session1}.json` ) );
    test.true( got2Str.includes( `arrangement.${session1}.json` ) );
    test.identical( __.strCount( got2Str, `arrangement.${session1}.json` ), 1 );

    test.true( got1Str.includes( `arrangement.${session2}.json` ) );
    test.true( got2Str.includes( `arrangement.${session2}.json` ) );
    test.identical( __.strCount( got2Str, `arrangement.${session2}.json` ), 1 );

    test.identical( __.strCount( got2Str, '.json' ), 3 );

    return null;
  });

  /* - */

  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session1}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session2}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session1}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session2}` );
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} session:${session1}` );
  a.appStart( `.storage.log` )
  .then( ( op ) =>
  {

    test.case = '5 arrangement, 3 session'

    var got = _global_.wTools.censor.storageRead();
    var got1Str = JSON.stringify( op );
    var got2Str = JSON.stringify( got );

    test.true( got1Str.includes( `arrangement.${session1}.json` ) );
    test.true( got2Str.includes( `arrangement.${session1}.json` ) );
    test.identical( __.strCount( got2Str, `arrangement.${session1}.json` ), 1 );

    test.true( got1Str.includes( `arrangement.${session2}.json` ) );
    test.true( got2Str.includes( `arrangement.${session2}.json` ) );
    test.identical( __.strCount( got2Str, `arrangement.${session2}.json` ), 1 );

    test.identical( __.strCount( got2Str, '.json' ), 3 );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceOptionSession.experimental = true;

//

function replaceRedoUndoSingleCommand( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'basic' );

  a.reflect();

  let file1Before = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
  let file2Before = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
  let file1After = a.fileProvider.fileRead( a.abs( 'after/File1.txt' ) );
  let file2After = a.fileProvider.fileRead( a.abs( 'after/File2.txt' ) );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = '.replace .do';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} .do profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + replace 3 in ${ a.abs( 'before/File1.txt' ) }
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Last one
 + replace 5 in ${ a.abs( 'before/File2.txt' ) }
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Fourth line
     3 : Third line
     4 : Fourth lineabc
     5 : Fifth line
     4 : Fourth line
     5 : Fifth lineabc
     6 : Last one
 . Found 2 file(s). Arranged 8 replacement(s) in 2 file(s).
    1 : First lineabc
    2 : Second line
    1 : First line
    2 : Second lineabc
    3 : Third line
    2 : Second line
    3 : Third lineabc
    4 : Last one
   + replace 3 in ${ a.abs( 'before/File1.txt' ) }
    1 : First lineabc
    2 : Second line
    1 : First line
    2 : Second lineabc
    3 : Third line
    2 : Second line
    3 : Third lineabc
    4 : Fourth line
    3 : Third line
    4 : Fourth lineabc
    5 : Fifth line
    4 : Fourth line
    5 : Fifth lineabc
    6 : Last one
   + replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1After );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2After );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = '.replace .do .undo';
    a.reflect();
    return null;
  })

  a.appStart( `.arrangement.del profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:line sub:abc profile:${profile} .do profile:${profile} .undo profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + replace 3 in ${ a.abs( 'before/File1.txt' ) }
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Last one
 + replace 5 in ${ a.abs( 'before/File2.txt' ) }
     1 : First lineabc
     2 : Second line
     1 : First line
     2 : Second lineabc
     3 : Third line
     2 : Second line
     3 : Third lineabc
     4 : Fourth line
     3 : Third line
     4 : Fourth lineabc
     5 : Fifth line
     4 : Fourth line
     5 : Fifth lineabc
     6 : Last one
 . Found 2 file(s). Arranged 8 replacement(s) in 2 file(s).
    1 : First lineabc
    2 : Second line
    1 : First line
    2 : Second lineabc
    3 : Third line
    2 : Second line
    3 : Third lineabc
    4 : Last one
   + replace 3 in ${ a.abs( 'before/File1.txt' ) }
    1 : First lineabc
    2 : Second line
    1 : First line
    2 : Second lineabc
    3 : Third line
    2 : Second line
    3 : Third lineabc
    4 : Fourth line
    3 : Third line
    4 : Fourth lineabc
    5 : Fifth line
    4 : Fourth line
    5 : Fifth lineabc
    6 : Last one
   + replace 5 in ${ a.abs( 'before/File2.txt' ) }
 + Done 2 action(s). Thrown 0 error(s).
   + undo replace 5 in ${ a.abs( 'before/File2.txt' ) }
   + undo replace 3 in ${ a.abs( 'before/File1.txt' ) }
 - Undone 2 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.identical( got, file1Before );
    var got = a.fileProvider.fileRead( a.abs( 'before/File2.txt' ) );
    test.identical( got, file2Before );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function replaceSeveral( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'replaceStatus' );

  a.reflect();

  /* */

  a.ready.then( () =>
  {
    test.case = 'single line';
    a.reflect();
    return null;
  })
  a.appStart( `.replace filePath:before/** ins:"line2" sub:"line22" profile:${profile}` )
  a.appStart( `.replace filePath:before/** ins:"line3" sub:"line33" profile:${profile}` )
  a.appStart( `.do profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.';
    test.identical( op.exitCode, 0 );

    var exp =
`
line1
line22
line33
line4
`
    var got = a.fileProvider.fileRead( a.abs( 'before/File1.txt' ) );
    test.equivalent( got, exp );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceSeveral.description =
`
- several replacement in a raw does arrange replacement
- arranged several replacements change file properly
`

//

function replaceStatus( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'replaceStatus' );

  a.reflect();

  // a.appStart( `.replace filePath:before/** ins:line2\nline3 sub:line22\nline33 profile:${profile} .do profile:${profile}` )
  // a.appStart( `.imply profile:${profile} .replace filePath:before/** ins:line1\nline2 sub:line3\nline4 .do` ) /* xxx : qqq : make working */

  /* */

  a.ready.then( () =>
  {
    test.case = 'single line';
    a.reflect();
    return null;
  })
  a.appStart
  ({
    args : `.replace filePath:before/** ins:"line2" sub:"line22" profile:${profile} .status profile:${profile}`,
    outputColoring : 0,
    outputGraying : 0
  });
  // a.appStart( `.imply profile:${profile} .replace filePath:before/** ins:line2\nline3 sub:line22\nline33 profile:${profile} .status profile:${profile}` ) /* xxx : qqq : make working */
  a.ready.then( ( op ) =>
  {
    test.description = '.';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + replace 1 in ${a.abs( './before/File1.txt' )}
     1 : line1
     2 : line2line22
     3 : line3
 . Found 1 file(s). Arranged 1 replacement(s) in 1 file(s).
  redo :
     + replace 1 in ${a.abs( './before/File1.txt' )}
     1 : line1
     2 : line2line22
     3 : line3
`
    test.equivalent( _.ct.stripAnsi( op.output ), exp );

    return null;
  })

  /* */

// xxx
//   a.ready.then( () =>
//   {
//     test.case = 'multiple lines';
//     a.reflect();
//     return null;
//   })
//   a.appStart( `.profile.del profile:${profile}` )
//   a.appStart({ args : `.replace filePath:before/** ins:"line2\nline3" sub:"line22\nline33" profile:${profile} .status profile:${profile}`, outputColoring : 0, outputGraying : 0 })
//   .then( ( op ) =>
//   {
//     test.description = '.';
//     test.identical( op.exitCode, 0 );
//
//     /* qqq : implement */
//
//     var exp =
// `
// `
//     test.equivalent( _.ct.stripAnsi( op.output ), exp );
//
//     return null;
//   })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

replaceStatus.description =
`
- output of command status is proper for both single-line replacement and multy-line replacement
`

//

function listingReorder( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'listingSqueeze' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();

    var expected =
    {
      '11_F3.txt' : '11_F3.txt',
      '3_F1.txt' : '3_F1.txt',
      '3_F2.txt' : '3_F2.txt',
      '5_F0.txt' : '5_F0.txt',
      '_3_F1.txt' : '_3_F1.txt',
    };
    var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
    test.identical( extract.filesTree, expected );

    return null;
  })

  /* xxx : qqq : implement test routine implyListingDo with such test cases:
      a.appStart( `.imply profile:${profile} .listing.squeeze .do` )
      a.appStart( `.listing.squeeze profile:${profile} .do profile:${profile}` )
    should be identical outcomes
  */

  a.appStart( `.listing.reorder profile:${profile} .do profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
`
   + ${a.abs( '.' )}/ : ./10_F1.txt <- ./3_F1.txt
   + ${a.abs( '.' )}/ : ./20_F2.txt <- ./3_F2.txt
   + ${a.abs( '.' )}/ : ./30_F0.txt <- ./5_F0.txt
   + ${a.abs( '.' )}/ : ./40_F3.txt <- ./11_F3.txt
 + Done 4 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var expected =
    {
      '10_F1.txt' : '3_F1.txt',
      '20_F2.txt' : '3_F2.txt',
      '30_F0.txt' : '5_F0.txt',
      '40_F3.txt' : '11_F3.txt',
      '_3_F1.txt' : '_3_F1.txt'
    };
    var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
    test.identical( extract.filesTree, expected );

    return null;
  })

  a.appStart( `.undo profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo fileRename ${a.abs( '.' )}/ : ./40_F3.txt <- ./11_F3.txt
+ undo fileRename ${a.abs( '.' )}/ : ./30_F0.txt <- ./5_F0.txt
+ undo fileRename ${a.abs( '.' )}/ : ./20_F2.txt <- ./3_F2.txt
+ undo fileRename ${a.abs( '.' )}/ : ./10_F1.txt <- ./3_F1.txt
- Undone 4 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var expected =
    {
      '11_F3.txt' : '11_F3.txt',
      '3_F1.txt' : '3_F1.txt',
      '3_F2.txt' : '3_F2.txt',
      '5_F0.txt' : '5_F0.txt',
      '_3_F1.txt' : '_3_F1.txt',
    };
    var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
    test.identical( extract.filesTree, expected );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function listingSqueeze( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'listingSqueeze' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();

    var expected =
    {
      '11_F3.txt' : '11_F3.txt',
      '3_F1.txt' : '3_F1.txt',
      '3_F2.txt' : '3_F2.txt',
      '5_F0.txt' : '5_F0.txt',
      '_3_F1.txt' : '_3_F1.txt',
    };
    var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
    test.identical( extract.filesTree, expected );

    return null;
  })

  /* xxx : qqq : implement test routine implyListingDo with such test cases:
      a.appStart( `.imply profile:${profile} .listing.squeeze .do` )
      a.appStart( `.listing.squeeze profile:${profile} .do profile:${profile}` )
    should be identical outcomes
  */

  a.appStart( `.listing.squeeze profile:${profile} .do profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
`
+ ${a.abs( '.' )}/ : ./1_F1.txt <- ./3_F1.txt
+ ${a.abs( '.' )}/ : ./2_F2.txt <- ./3_F2.txt
+ ${a.abs( '.' )}/ : ./3_F0.txt <- ./5_F0.txt
+ ${a.abs( '.' )}/ : ./4_F3.txt <- ./11_F3.txt
+ Done 4 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var expected =
    {
      '1_F1.txt' : '3_F1.txt',
      '2_F2.txt' : '3_F2.txt',
      '3_F0.txt' : '5_F0.txt',
      '4_F3.txt' : '11_F3.txt',
      '_3_F1.txt' : '_3_F1.txt',
    };
    var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
    test.identical( extract.filesTree, expected );

    return null;
  })

  a.appStart( `.undo profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
`
+ undo fileRename ${a.abs( '.' )}/ : ./4_F3.txt <- ./11_F3.txt
+ undo fileRename ${a.abs( '.' )}/ : ./3_F0.txt <- ./5_F0.txt
+ undo fileRename ${a.abs( '.' )}/ : ./2_F2.txt <- ./3_F2.txt
+ undo fileRename ${a.abs( '.' )}/ : ./1_F1.txt <- ./3_F1.txt
- Undone 4 action(s). Thrown 0 error(s).
`
    test.equivalent( op.output, exp );

    var expected =
    {
      '11_F3.txt' : '11_F3.txt',
      '3_F1.txt' : '3_F1.txt',
      '3_F2.txt' : '3_F2.txt',
      '5_F0.txt' : '5_F0.txt',
      '_3_F1.txt' : '_3_F1.txt',
    };
    var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
    test.identical( extract.filesTree, expected );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

// --
// hlink
// --

function hlinkBasic( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'hlink' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();

    test.true( !a.fileProvider.areHardLinked( a.abs( 'F1.txt' ), a.abs( 'F2.txt' ) ) );
    test.true( !a.fileProvider.areHardLinked( a.abs( 'F1.txt' ), a.abs( 'dir/F3.txt' ) ) );
    test.true( !a.fileProvider.areHardLinked( a.abs( 'F2.txt' ), a.abs( 'dir/F3.txt' ) ) );

    return null;
  })

  a.appStart( `.hlink profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/ : ./dir/F3.txt <- ./F1.txt
Linked 2 file(s) at ${ a.abs( '.' ) }
`
    test.equivalent( op.output, exp );

    test.true( !a.fileProvider.areHardLinked( a.abs( 'F1.txt' ), a.abs( 'F2.txt' ) ) );
    test.true( a.fileProvider.areHardLinked( a.abs( 'F1.txt' ), a.abs( 'dir/F3.txt' ) ) );
    test.true( !a.fileProvider.areHardLinked( a.abs( 'F2.txt' ), a.abs( 'dir/F3.txt' ) ) );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function hlinkWithSoftLinks( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( false );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'basic';

    a.fileProvider.fileWrite( a.abs( 'f1' ), 'txt' );
    a.fileProvider.softLink( a.abs( 's1' ), a.abs( 'f1' ) );
    a.fileProvider.fileWrite( a.abs( 'f2' ), 'txt' );
    a.fileProvider.softLink( a.abs( 's2' ), a.abs( 'f2' ) );
    a.fileProvider.fileWrite( a.abs( 'f3' ), 'txt2' );
    a.fileProvider.softLink( a.abs( 's3' ), a.abs( 'f3' ) );

    test.true( a.fileProvider.isSoftLink( a.abs( 's1' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 's2' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 's3' ) ) );

    test.true( a.fileProvider.areSoftLinked( a.abs( 's1' ), a.abs( 'f1' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 's2' ), a.abs( 'f2' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 's3' ), a.abs( 'f3' ) ) );

    test.true( !a.fileProvider.areHardLinked( a.abs( 'f1' ), a.abs( 'f2' ) ) );
    test.true( !a.fileProvider.areHardLinked( a.abs( 'f1' ), a.abs( 'f3' ) ) );
    test.true( !a.fileProvider.areHardLinked( a.abs( 'f2' ), a.abs( 'f3' ) ) );

    return null;
  })

  a.appStart( `.hlink profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    test.true( a.fileProvider.isSoftLink( a.abs( 's1' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 's2' ) ) );
    test.true( a.fileProvider.isSoftLink( a.abs( 's3' ) ) );

    test.true( a.fileProvider.areSoftLinked( a.abs( 's1' ), a.abs( 'f1' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 's2' ), a.abs( 'f2' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 's3' ), a.abs( 'f3' ) ) );

    test.true( a.fileProvider.areHardLinked( a.abs( 'f1' ), a.abs( 'f2' ) ) );
    test.true( !a.fileProvider.areHardLinked( a.abs( 'f1' ), a.abs( 'f3' ) ) );
    test.true( !a.fileProvider.areHardLinked( a.abs( 'f2' ), a.abs( 'f3' ) ) );

    return null;
  });

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function hlinkOptionBasePath( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'hlinkAdvanced' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basic';
    a.reflect();

    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  a.appStart( `.hlink profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ hardLink : ${ a.abs( '.' ) }/ : ./F.txt2 <- ./F.txt
+ hardLink : ${ a.abs( '.' ) }/ : ./dir1/F.txt <- ./F.txt
+ hardLink : ${ a.abs( '.' ) }/ : ./dir1/F.txt2 <- ./F.txt
+ hardLink : ${ a.abs( '.' ) }/ : ./dir2/F.txt <- ./F.txt
+ hardLink : ${ a.abs( '.' ) }/ : ./dir2/F.txt2 <- ./F.txt
+ hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./F.txt
+ hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt2 <- ./F.txt
Linked 8 file(s) at ${ a.abs( '.' ) }
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'F.txt' ), a.abs( 'F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 8n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 8n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 8n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 8n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 8n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 8n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 8n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 8n );

    var exp =
    [
      '.',
      './.warchive',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'dir1';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink dir1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
`
+ hardLink : ${ a.abs( 'dir1/' ) } : ./F.txt2 <- ./F.txt
Linked 2 file(s) at ${ a.abs( 'dir1' ) }
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir1/F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'dir1/**';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink dir1/** profile:${profile}` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
`
+ hardLink : ${ a.abs( 'dir1/' ) } : ./F.txt2 <- ./F.txt
Linked 2 file(s) at ${ a.abs( 'dir1' ) }/**
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir1/F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basePath:dir1';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink basePath:dir1 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
+ hardLink : ${ a.abs( 'dir1/' ) } : ./F.txt2 <- ./F.txt
Linked 2 file(s) at ${ a.abs( 'dir1' ) }
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir1/F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = `basePath:'dir1/**'`;
    a.reflect();
    return null;
  })

  a.appStart( `.hlink basePath:'dir1/**' profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( 'dir1/' ) } : ./F.txt2 <- ./F.txt
Linked 2 file(s) at ${ a.abs( 'dir1/' ) }**
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir1/F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basePath:dir1 basePath:dir3';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink basePath:dir1 basePath:dir3 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/dir1/ : ./F.txt2 <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./dir1/F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt2 <- ./dir1/F.txt
Linked 4 file(s) at ( ${ a.abs( '.' ) }/ + [ ./dir1 , ./dir3 ] )
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir1/F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 4n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/.warchive',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basePath:"dir1/**" basePath:"dir3/**"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink basePath:"dir1/**" basePath:"dir3/**" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/dir1/ : ./F.txt2 <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./dir1/F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt2 <- ./dir1/F.txt
Linked 4 file(s) at ( ${ a.abs( '.' ) }/ + [ ./dir1/** , ./dir3/** ] )
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir1/F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 4n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/.warchive',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'dir1/** basePath:"dir3/**"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink dir1/** basePath:"dir3/**" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/dir1/ : ./F.txt2 <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./dir1/F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt2 <- ./dir1/F.txt
Linked 4 file(s) at ( ${ a.abs( '.' ) }/ + [ ./dir1/** , ./dir3/** ] )
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir1/F.txt2' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 4n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/.warchive',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function hlinkOptionIncludingPath( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'hlinkAdvanced' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basePath:"dir1/**" basePath:"dir3/**" includingPath:"**.txt"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink basePath:"dir1/**" basePath:"dir3/**" includingPath:"**.txt" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./dir1/F.txt
Linked 2 file(s) at ( ${ a.abs( '.' ) }/ + [ ./dir1/** , ./dir3/** ] )
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir3/F.txt' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/.warchive',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'includingPath:"*.txt"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink includingPath:"*.txt" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
Linked 0 file(s) at ${ a.abs( '.' ) }
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir3/F.txt' ) ), false );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './.warchive',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'includingPath:"**.txt"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink includingPath:"**.txt" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/ : ./dir1/F.txt <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir2/F.txt <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./F.txt
Linked 4 file(s) at ${ a.abs( '.' ) }
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir3/F.txt' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './.warchive',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function hlinkOptionExcludingPath( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'hlinkAdvanced' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'basePath:"dir1/**" basePath:"dir3/**" excludingPath:"**.txt2"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink basePath:"dir1/**" basePath:"dir3/**" excludingPath:"**.txt2" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./dir1/F.txt
Linked 2 file(s) at ( ${ a.abs( '.' ) }/ + [ ./dir1/** , ./dir3/** ] )
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir3/F.txt' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 2n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/.warchive',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/.warchive',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'excludingPath:"*.txt2"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink excludingPath:"*.txt2" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/ : ./dir1/F.txt <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir1/F.txt2 <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir2/F.txt <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir2/F.txt2 <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt2 <- ./F.txt
Linked 7 file(s) at ${ a.abs( '.' ) }
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir3/F.txt' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 7n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 7n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 7n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 7n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 7n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 7n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 7n );

    var exp =
    [
      '.',
      './.warchive',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'excludingPath:"**.txt2"';
    a.reflect();
    return null;
  })

  a.appStart( `.hlink excludingPath:"**.txt2" profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/ : ./dir1/F.txt <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir2/F.txt <- ./F.txt
 + hardLink : ${ a.abs( '.' ) }/ : ./dir3/F.txt <- ./F.txt
Linked 4 file(s) at ${ a.abs( '.' ) }
`
    test.equivalent( op.output, exp );

    test.identical( a.fileProvider.areHardLinked( a.abs( 'dir1/F.txt' ), a.abs( 'dir3/F.txt' ) ), true );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir1/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir2/F.txt2' ) ).nlink, 1n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt' ) ).nlink, 4n );
    test.equivalent( a.fileProvider.statRead( a.abs( 'dir3/F.txt2' ) ).nlink, 1n );

    var exp =
    [
      '.',
      './.warchive',
      './F.txt',
      './F.txt2',
      './dir1',
      './dir1/F.txt',
      './dir1/F.txt2',
      './dir2',
      './dir2/F.txt',
      './dir2/F.txt2',
      './dir3',
      './dir3/F.txt',
      './dir3/F.txt2'
    ]
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

//

function hlinkOptionExcludingHyphened( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'hlinkExclusive' );
  let file1 = a.abs( 'dir/-F1.txt' );
  let file2 = a.abs( 'dir/-F2.txt' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'excludingHyphened : 1';
    a.reflect();

    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );

    return null;
  })

  a.appStart( `.hlink profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
Linked 0 file(s) at ${ a.abs( '.' ) }
`
    test.equivalent( op.output, exp );

    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );

    return null;
  })

  /* */

  a.ready
  .then( ( op ) =>
  {
    test.case = 'excludingHyphened : 0';
    a.reflect();

    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );

    return null;
  })

  a.appStart( `.hlink excludingHyphened : 0 profile:${profile}` )
  .then( ( op ) =>
  {
    test.description = '.hlink';
    test.identical( op.exitCode, 0 );

    var exp =
`
 + hardLink : ${ a.abs( '.' ) }/dir/ : ./-F2.txt <- ./-F1.txt
Linked 2 file(s) at ${ a.abs( '.' ) }
`

    test.equivalent( op.output, exp );

    test.true( a.fileProvider.isHardLink( file1 ) );
    test.true( a.fileProvider.isHardLink( file2 ) );
    test.true( a.fileProvider.areHardLinked( file1, file2 ) );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}


//

function entryAddBasic( test )
{
  let context = this
  let profile = `censor-test-${ __.intRandom( 1000000 ) }`;
  let a = test.assetFor( 'entry' );

  /* - */

  a.ready
  .then( ( op ) =>
  {
    test.case = '';
    a.reflect();
    return null;
  })

  // a.appStart( `.imply profile:${profile} .config.set` )
  // a.appStart( `.entry.add F1.js profile:${profile}` )
  a.appStart( `.entry.add F1.js relative:1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp = `+ Add entry`;
    test.identical( __.strCount( op.output, exp ), 1 );

    var exp = [ '.', './F1.js', './F2.js' ];
    var files = a.findAll( a.abs( '.' ) );
    test.identical( files, exp );

    return null;
  })

  /* - */

  a.shell( `F1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var exp =
`
F1.js
`
    test.equivalent( op.output, exp );

    return null;
  })

  /* - */

  a.appStart( `.profile.del profile:${profile}` );
  return a.ready;
}

// --
// declare
// --

const Proto =
{

  name : 'Tools.Censor.Ext',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {

    help,
    where,
    // runDebugCensor,

    configGetBasic,
    configSetBasic,
    configDelBasic,
    configLogBasic,

    version,

    arrangementLog,
    arrangementDel,

    storageLog,
    storageDel,

    statusBasic,
    statusOptionSession,

    profileLog,
    profileDel,

    identityList,
    identityCopy,
    identitySet,
    identityNew,
    gitIdentityNew,
    npmIdentityNew,
    identityFromGit,
    identityFromSsh,
    identityRemove,
    gitIdentityScript,
    npmIdentityScript,
    sshIdentityScript,
    gitIdentityScriptSet,
    npmIdentityScriptSet,
    sshIdentityScriptSet,
    gitIdentityUse,
    npmIdentityUse,
    sshIdentityUse,

    replaceBasic,
    replaceStatusOptionVerbosity,
    replaceRedoOptionVerbosity,
    replaceRedoOptionDepth,
    replaceChangeRedo,
    replaceRedoDepth0OptionVerbosity,
    replaceRedoHardLinked,
    replaceRedoSoftLinked,
    replaceRedoBrokenSoftLink,
    replaceRedoTextLink,
    replaceRedoBrokenTextLink,
    // replaceRedoTextLinked, /* qqq : implement. look replaceRedoSoftLinked. add option resolvingTextLink */
    replaceBigFile,

    replaceRedoUndo,
    replaceRedoChangeUndo,
    replaceRedoUndoOptionVerbosity,
    replaceRedoUndoOptionDepth,
    replaceOptionSession,
    replaceRedoUndoSingleCommand,

    replaceStatus, /* qqq : make it working */
    // replaceSeveral, /* qqq : make it working */

    listingReorder,
    listingSqueeze,

    // /* qqq : implement test to check locking, discuss first */

    hlinkBasic,
    hlinkWithSoftLinks,
    hlinkOptionBasePath,
    hlinkOptionIncludingPath,
    hlinkOptionExcludingPath,
    hlinkOptionExcludingHyphened,

    // entryAddBasic, /* xxx : extend and enable */

  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
