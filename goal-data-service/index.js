const { GraphQLServer } = require('graphql-yoga')
const mongoose = require('mongoose');
const GoalTypeDefinitions = require('./goal/typeDefinitions');
const GoalResolvers = require('./goal/resolvers');

const run = async () => {
    const { MONGODB_USERNAME, MONGODB_PASSWORD, MONGODB_HOST, MONGODB_DATABASE } = process.env;
    const uri = `mongodb://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@${MONGODB_HOST}/${MONGODB_DATABASE}`

    mongoose.connect(uri, { useNewUrlParser: true });

    const server = new GraphQLServer({ typeDefs: GoalTypeDefinitions, resolvers: GoalResolvers })
    mongoose.connection.once("open", () => {
        // Health check
        server.express.get('/health', (req, res) => res.send('OK'));

        // GraphQL Server Start
        server.start(() => console.log('Server started!'))
    });
};

run();


