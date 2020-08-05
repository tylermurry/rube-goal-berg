global.fetch = require('node-fetch');
const { KafkaClient, Consumer, Offset } = require('kafka-node');
const { request } = require('graphql-request')

const topic = "goal-event"
const topics = [{ topic: topic, partition: 0 }];
const client = new KafkaClient({ kafkaHost: process.env.KAFKA_HOST });
const options = { autoCommit: true, fetchMaxWaitMs: 1000, fetchMaxBytes: 1024 * 1024 };
const consumer = new Consumer(client, topics, options);
const goalDataServiceHost = process.env.GOAL_DATA_SERVICE_HOST;

const processMessage = async (message) => {
    console.log(message);
    const goalEvent = JSON.parse(message.value);

    const query = `
        mutation {
            newGoal(
                sensorId: "${goalEvent.sensorId}", 
                userId:   "${goalEvent.userId}", 
                dateTime: "${goalEvent.dateTime}",
                madeGoal:  ${goalEvent.madeGoal}, 
                position:  ${goalEvent.position}
            ) {
                _id
            }
        }`

    request(goalDataServiceHost, query)
        .then(data => {
            console.log(`Successfully saved goal --> ${data.newGoal._id}`);
        })
        .catch(error => {
            console.error(error);
        })
}

consumer.on('error', error => {
    console.error(error);
});

client.refreshMetadata([topic], error => {
    if (error) { throw error }

    const offset = new Offset(client);

    consumer.on('message', processMessage);
    consumer.on('offsetOutOfRange', topic => {
        offset.fetch([topic], (error, offsets) => {
            if (error) { throw error }

            const min = Math.min.apply(null, offsets[topic.topic][topic.partition]);
            consumer.setOffset(topic.topic, topic.partition, min);
        });
    });
});
