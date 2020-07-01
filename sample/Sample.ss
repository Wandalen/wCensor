
let _ = require( 'wfiler' );
let filePath = _.path.resolve( __dirname, 'File.txt' );

/**/

console.log( `File.txt:\n${_.fileProvider.fileRead( filePath )}\n` );

_.censor.filesReplace( filePath, 'line', 'abc' );
_.censor.do();

console.log( `File.txt:\n${_.fileProvider.fileRead( filePath )}\n` );

/**/
