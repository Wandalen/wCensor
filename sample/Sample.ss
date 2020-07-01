
let _ = require( 'wfiler' );

/**/

console.log( `File.txt:\n${_.fileProvider.fileRead( _.path.resolve( 'File.txt' ) )}\n` );

_.censor.filesReplace( _.path.resolve( 'File.txt' ), 'line', 'abc' );
_.censor.do();

console.log( `File.txt:\n${_.fileProvider.fileRead( _.path.resolve( 'File.txt' ) )}\n` );

/**/
