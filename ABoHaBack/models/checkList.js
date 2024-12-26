const Sequelize = require("sequelize");

class CheckList extends Sequelize.Model {
  static init(sequelize) {
    return super.init(
      {
        nickName: {
          type: Sequelize.STRING(50),
          allowNull: false,
        },
        isOn: {
          type: Sequelize.BOOLEAN,
          allowNull: false,
          defaultValue: false,
        },
        isComplete: {
          type: Sequelize.BOOLEAN,
          allowNull: false,
          defaultValue: false,
        },
        startDay: {
          type: Sequelize.STRING,
          allowNull: false,
          defaultValue: () => new Date().toString(),
        },
        // completeDay : {
        //     type : Sequelize.STRING,
        //     allowNull:false,
        // },
        alramDate: {
          type: Sequelize.STRING,
          allowNull: true,
          defaultValue: () => new Date().toString(),
        },
        alramTime: {
          type: Sequelize.STRING,
          allowNull: false,
        },
        // cycle: {
        //   type: Sequelize.STRING,
        //   allowNull: false,
        // },
        contents: {
          type: Sequelize.STRING,
          allowNull: false,
        },
      },
      {
        sequelize,
        timestamps: true,
        paranoid: true,
        modelName: "CheckList",
        tableName: "checkList",
      }
    );
  }
  //여러개 연결
  static associate(db) {
    db.User.hasMany(db.CheckList, {
      foreignKey: "nickName",
      sourceKey: "nickName",
    });
  }
}
module.exports = CheckList;
