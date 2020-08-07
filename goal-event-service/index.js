const { KafkaClient, Consumer, Offset } = require('kafka-node');
const WebSocket = require('ws');

const topic = "goal-event"
const topics = [{ topic: topic, partition: 0 }];
const client = new KafkaClient({ kafkaHost: process.env.KAFKA_HOST });
const options = { autoCommit: true, fetchMaxWaitMs: 1000, fetchMaxBytes: 1024 * 1024 };
const consumer = new Consumer(client, topics, options);

const wss = new WebSocket.Server({ port: 8080 });

consumer.on('error', error => {
    console.error(error);
});

const processMessage = message => {
    wss.clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
            const event = JSON.parse(message.value);
            event._eventName = 'GoalEvent';
            client.send(JSON.stringify(event));
        }
    });
};

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
