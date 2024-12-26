const express = require("express");
const Daily = require("../models/daily"); // 모델 가져오기
const extractSentiment = require("./extract-sentiment");
const router = express.Router();
const authorization = require("./authorization");

const upload = require("./uploadImage");

// 1. 일기 작성 (Create)
router.post(
  "/create",
  authorization,
  upload.single("photo"),
  async (req, res) => {
    console.log("============", req.body);

    try {
      let newDaily = req.body;
      let sentiment;
      if (newDaily.contents) {
        sentiment = await extractSentiment(req.body.contents);
      } else {
        sentiment = "neutral";
      }

      console.log("----------------", sentiment);
      newDaily.sentiment = sentiment;
      newDaily.photo = req.filename;
      // 일기 데이터 생성
      console.log("new data:", newDaily);
      const result = await Daily.create(newDaily);
      console.log("created db data:", result);

      res.status(201).json({
        message: "일기가 성공적으로 작성되었습니다.",
        data: [result],
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "일기 작성에 실패했습니다." });
    }
  }
);

// 2. 일기 조회 (Read)
router.get("/", authorization, async (req, res) => {
  try {
    // 모든 일기 조회
    const daily = await Daily.findAll();

    res.status(200).json({
      message: "일기 목록 조회 성공",
      data: daily,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "일기 조회에 실패했습니다." });
  }
});

// 3. 특정 일기 조회 (Read)
router.get("/diary/:id", authorization, async (req, res) => {
  try {
    const { id } = req.params;

    // 특정 일기 조회
    const diary = await Daily.findByPk(id);

    if (!diary) {
      return res.status(404).json({ message: "일기를 찾을 수 없습니다." });
    }

    res.status(200).json({
      message: "일기 조회 성공",
      data: diary,
    });
  } catch (error) {
    console.log("==================********************");
    console.error(error);
    res.status(500).json({ message: "일기 조회에 실패했습니다." });
  }
});

// 4. 특정 사용자별 조회 (Read)
router.get("/user", authorization, async (req, res) => {
  console.log("/user");
  try {
    const { nickName, date } = req.query; // 쿼리 파라미터에서 nickName과 date 가져오기
    console.log("user req.query", req.query);

    if (!nickName) {
      return res.status(400).json({ message: "nickName은 필수입니다." });
    }

    // date가 존재하면 그 날짜를 기준으로 필터링
    const whereCondition = { nickName: nickName };
    if (date) {
      // date가 주어지면 'date' 필드를 기준으로 필터링 (시간 제외)
      whereCondition.date = {
        [Sequelize.Op.eq]: Sequelize.literal("DATE(date)"), // 날짜만 비교 (시간 제외)
      };
    }

    // 특정 사용자의 일기 조회
    const daily = await Daily.findAll({
      where: whereCondition,
      order: [
        ["date", "DESC"],
        ["createdAt", "DESC"],
      ], // createdAt 기준으로 내림차순 정렬
    });

    if (daily.length === 0) {
      return res.status(404).json({
        message: "해당 닉네임 또는 날짜에 대한 일기를 찾을 수 없습니다.",
      });
    }

    res.status(200).json({
      message: "일기 조회 성공",
      data: daily,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "일기 조회에 실패했습니다." });
  }
});

// 5. 일기 수정 (Update)
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { nickName, contents, sentiment, date, photo, weekday } = req.body;

    // 특정 일기 수정
    const daily = await Daily.findByPk(id);

    if (!daily) {
      return res.status(404).json({ message: "일기를 찾을 수 없습니다." });
    }

    // 일기 업데이트
    await daily.update({ nickName, contents, sentiment, date, photo, weekday });

    res.status(200).json({
      message: "일기가 성공적으로 수정되었습니다.",
      data: daily,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "일기 수정에 실패했습니다." });
  }
});

// 6. 일기 삭제 (Delete)
router.delete("/user", authorization, async (req, res) => {
  try {
    const nickName = req.query.nickName;
    console.log(req.query);

    // 사용자 nickName 기준으로 삭제 권한 확인
    const daily = await Daily.findOne({ where: { nickName } });
    if (!daily) {
      return res.status(404).json({
        message: "삭제할 일기를 찾을 수 없거나 권한이 없습니다.",
      });
    }

    await daily.destroy(); // 일기 삭제
    res.status(200).json({ message: "일기가 성공적으로 삭제되었습니다." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "일기 삭제에 실패했습니다." });
  }
});

module.exports = router;
