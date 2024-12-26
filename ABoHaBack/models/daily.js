const Sequelize = require("sequelize");

class Daily extends Sequelize.Model {
  static init(sequelize) {
    return super.init(
      {
        nickName: {
          type: Sequelize.STRING(50),
          allowNull: false,
        },
        contents: {
          type: Sequelize.TEXT,
          allowNull: true,
        },
        date: {
          type: Sequelize.STRING(50),
          allowNull: false,
        },
        sentiment: {
          type: Sequelize.STRING(50),
          allowNull: false,
        },
        photo: {
          type: Sequelize.STRING(200),
          allowNull: true,
        },
        weekday: {
          type: Sequelize.STRING,
          defaultValue: () => {
            const options = { weekday: "long" };
            return new Date().toLocaleDateString("en-US", options);
          },
        },
      },
      {
        sequelize,
        timestamps: true,
        paranoid: true,
        modelName: "Daily",
        tableName: "daily",
      }
    );
  }

  static associate(db) {
    db.Daily.belongsTo(db.User, {
      foreignKey: "nickName",
      sourceKey: "nickName",
    });
  }
}

module.exports = Daily;
