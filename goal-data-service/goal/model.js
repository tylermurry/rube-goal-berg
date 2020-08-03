const mongoose = require('mongoose');

module.exports = mongoose.model("Goal",{
    sensorId: String,
    userId: { type: String, index: true },
    date: Date,
    madeGoal: Boolean,
    position: Number,
});
