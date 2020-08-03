const typeDefinitions = `
scalar DateTime

type Query {
  getGoals(userId: ID!): [Goal]
}

type Goal {
  _id: ID!,
  sensorId: ID!,
  userId: ID!,
  dateTime: DateTime!,
  madeGoal: Boolean!,
  position: Int!,
}

type Mutation {
  newGoal(sensorId: ID!, userId: ID!, dateTime: DateTime!, madeGoal: Boolean!, position: Int!): Goal!,
}`

module.exports = typeDefinitions
