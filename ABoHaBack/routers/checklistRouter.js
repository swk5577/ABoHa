const express = require("express");
const router = express.Router();
const { CheckList, sequelize } = require("../models/index");
const { destroy } = require("../models/user");
const upload = require("./uploadImage");

//닉네임별로 데이터 가져오기
router.get("/:nickName", async (req, res, next) => {
  const nickName = req.params.nickName;
  console.log(nickName);

  const options = {
    order: [[sequelize.literal(`"alramTime"::TIME`), "ASC"]],
    where: {
      nickName: nickName,
    },
  };
  try {
    const result = await CheckList.findAll(options);
    res
      .status(200)
      .json({ success: true, CheckList: result, message: "post 조회 성공" });
  } catch (error) {
    console.log(error);
    next("checklist read err", error);
  }
});

//리스트 추가하기
router.post("/add", upload.none(), async (req, res, next) => {
  const newpost = req.body;
  console.log("newpost", newpost);
  try {
    const result = await CheckList.create(newpost);
    console.log("result", result);
    res.json({ success: true, CheckList: result, message: "post 등록 성공" });
  } catch (error) {
    res.json({
      success: false,
      CheckList: [],
      message: `post 등록 실패${err}`,
    });
    next("addlist err", error);
  }
});

//리스트 삭제
router.delete("/:id", async (req, res, next) => {
  const checklistID = req.params.id;
  console.log(checklistID);
  try {
    const result = await CheckList.destroy({
      where: { id: checklistID },
    });
    //삭제대상이 없을경우
    if (result === 0) {
      return res
        .status(404)
        .json({ success: false, message: "대상을 찾을수 없습니다" });
    }
    res.status(200).json({ success: true, message: "삭제 성공" });
  } catch (error) {
    next(error);
  }
});

//체크한애 isOn수정
router.patch("/:id", async (req, res, next) => {
  const checkListID = req.params.id;
  const { isOn, isComplete } = req.body;
  console.log(checkListID, " / ", isOn, " / ", isComplete);
  try {
    const updateData = {};
    if (isOn !== undefined) updateData.isOn = isOn;
    if (isComplete !== undefined) updateData.isComplete = isComplete;

    const result = await CheckList.update(updateData, {
      where: { id: checkListID },
    });
    if (result[0] == 0) {
      return res
        .status(404)
        .json({ success: false, message: "ID를 찾을 수 없습니다." });
    }
    res.status(200).json({ success: true, message: "수정 성공" });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
