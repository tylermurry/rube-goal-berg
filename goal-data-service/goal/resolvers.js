const Goal = require('./model');
const { DateTimeResolver } = require('graphql-scalars');

module.exports = {
    DateTime: DateTimeResolver,
    Query: {
        getGoals: async (_, { userId }) => Goal.find({ userId }),
    },
    Mutation: {
        newGoal: async (_, { sensorId, userId, dateTime, madeGoal, position }) => {
            const goal = new Goal({ sensorId, userId, dateTime, madeGoal, position });
            await goal.save();
            return goal;
        },
    }
}
