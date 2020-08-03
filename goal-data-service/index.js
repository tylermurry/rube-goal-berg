const { GraphQLServer } = require('graphql-yoga')
const mongoose = require('mongoose');
const GoalTypeDefinitions = require('./goal/typeDefinitions');
const GoalResolvers = require('./goal/resolvers');
const { MongoMemoryServer } = require('mongodb-memory-server');

const run = async () => {
    const mongod = new MongoMemoryServer();
    mongoose.connect(await mongod.getUri());

    const server = new GraphQLServer({ typeDefs: GoalTypeDefinitions, resolvers: GoalResolvers })
    mongoose.connection.once("open", () => {
        // Health check
        server.express.get('/health', (req, res) => res.send('OK'));

        // GraphQL Server Start
        server.start(() => console.log('Server started!'))
    });
};

run();


