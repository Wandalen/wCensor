
const _ = require( 'wcensor' );

/* */

const utility = _.censor.Cui.Self();
const commandsAggregator = utility._commandsMake();
commandsAggregator.programPerform({ program : '.help' });

