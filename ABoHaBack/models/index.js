const Sequelize = require("sequelize");
const process = require("process");
const env = process.env.NODE_ENV || "development";
const config = require("../config/config.js")[env];
const db = {};
let sequelize = new Sequelize(
  config.database,
  config.username,
  config.password,
  config
);

const User = require("./user");
const Daily = require("./daily");
const CheckList = require("./checkList.js");

db.User = User;
db.Daily = Daily;
db.CheckList = CheckList;

User.init(sequelize);
Daily.init(sequelize);
CheckList.init(sequelize);

User.associate(db);
Daily.associate(db);
CheckList.associate(db);

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;
