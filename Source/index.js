// TODO: Load the ./languageapi module

const languageAPI = require('./languageapi');

// END TODO

// TODO: Load the ./spanner module

const feedbackStorage = require('./spanner');

// END TODO

exports.subscribe = function subscribe(event) {
  // The Cloud Pub/Sub Message object.
  // TODO: Decode the Cloud Pub/Sub message
  // extracting the feedbackObject data
  // The message received from Pub/Sub is base64 encoded, and
  // the data submitted by students is in a data property     

  const pubsubMessage = Buffer.from(event.data, 'base64').toString();

  let feedbackObject = JSON.parse(pubsubMessage);
  console.log('Feedback object data before Language API:' + JSON.stringify(feedbackObject));

  // END TODO

  // TODO: Run Natural Language API sentiment analysis
  // The analyze(...) method expects to be passed the
  // feedback text from the feedbackObject as an argument,
  // and returns a Promise.

  return languageAPI.analyze(feedbackObject.feedback).then(score => {

    // TODO: Log the sentiment score

  	console.log(`Score: ${score}`);

    // END TODO

    // TODO: Add new score property to feedbackObject

  	feedbackObject.score = score;

    // END TODO

    // TODO: Pass feedback object to the next handler

  	return feedbackObject;

    // END TODO
  })

  // TODO: insert record
  .then(feedbackStorage.saveFeedback).then(() => {
  	// TODO: Log and return success

    console.log('feedback saved...');
  	return 'success';

    // END TODO

  })
  // END TODO

  // TODO: Catch and Log error
  .catch(console.error);
  // End TODO

};
