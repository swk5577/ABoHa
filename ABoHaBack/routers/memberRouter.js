const express = require("express");
const { User } = require("../models/index");
const router = express.Router();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const authorization = require("./authorization");
const upload = require("./uploadImage");
router.post("/sign-up", upload.single("profileImg"));
router.post("/change-profileImg", upload.single("profileImg"));

const secret = process.env.JWT_SECRET;

const createHash = async (password, saltRound) => {
  let hashed = await bcrypt.hash(password, saltRound);
  console.log(hashed);
  return hashed;
};

router.post("/sign-up", async (req, res, next) => {
  const newMember = req.body;
  newMember.profileImg = req.filename;
  console.log(newMember);

  //입력한 아이디와 db에 저장된 아이디가 같은 회원 'id' 확인
  const options = {
    attributes: ["password", "nickName"],
    where: { nickName: newMember.nickName }, //모델속성:키값
  };
  const result = await User.findOne(options);
  console.log("sign-up", result);

  if (result) {
    console.log("같은 nickName 있음");
    // 같은 아이디가 있을때 오류 처리
    res.send({ success: false, message: "사용할 수 없는 nickName 입니다." });
  } else {
    console.log("같은 nickName 없음");
    // 같은 아이디가 없을때 기존 회원가입 프로세스 처리
    newMember.password = await createHash(newMember.password, 10);
    console.log(newMember);

    try {
      const result = await User.create(newMember);
      res.send({
        success: true,
        member: result,
        message: "회원가입이 완료되었습니다.",
      });
    } catch (error) {
      res.send({ success: false, message: "회원가입 실패", error: error });
    }
  }
});

router.post("/sign-in", async (req, res, next) => {
  console.log(req.body);
  const { nickName, password } = req.body;
  const options = {
    attributes: ["id", "password", "nickName", "profileImg"],
    where: { nickName: nickName },
  };
  try {
    const result = await User.findOne(options);
    // console.log(result);

    if (result) {
      //회원이 입력한 비밀번호와 db에 저장된 token 비교
      const compared = await bcrypt.compare(password, result.password);

      if (compared) {
        //토큰 발행
        const token = jwt.sign({ uid: result.id, rol: "admin" }, secret, {
          expiresIn: 60 * 60 * 24 * 1,
        });
        console.log("==================", token);

        res.status(200).json({
          success: true,
          id: result.id,
          token: token,
          member: {
            nickName: result.nickName,
            profileImg: result.profileImg,
          },
          message: "로그인에 성공했습니다.",
        });
      } else {
        res.status(401).json({
          message: "비밀번호가 잘못되었습니다.",
        });
      }
    } else {
      res.status(404).json({
        message: "존재하지않는 nickName 입니다.",
      });
    }
  } catch (err) {
    next(err);
  }
});

//user info 가져오기
router.post("/userInfo", async (req, res, next) => {
  console.log(req.body);
  const { nickName } = req.body;

  const options = {
    attributes: ["id", "nickName", "email", "profileImg"],
    where: { nickName },
  };

  try {
    const result = await User.findOne(options);

    if (result) {
      res.status(200).json({
        success: true,
        member: {
          id: result.id,
          nickName: result.nickName,
          email: result.email,
          profileImg: result.profileImg,
        },
        message: "사용자 정보를 성공적으로 조회하였습니다.",
      });
    } else {
      res.status(404).json({
        message: "존재하지 않는 nickName입니다.",
      });
    }
  } catch (err) {
    next(err);
  }
});

// Logout
router.get("/logout", authorization, async (req, res) => {
  const userId = req.userId; // 인증된 사용자 정보로부터 userId를 가져옴
  if (!userId) {
    return res.status(400).json({
      success: false,
      message: "사용자 인증이 실패했습니다. 다시 로그인 해주세요.",
    });
  }

  try {
    const result = await User.findOne({
      attributes: ["id", "userName"], // id와 userName만 조회
      where: { id: userId }, // 인증된 사용자의 ID로 조회
    });

    if (!result) {
      return res.status(404).json({
        success: false,
        message: "존재하지 않는 사용자입니다.",
      });
    }

    // 1. 클라이언트에서 JWT 토큰을 삭제하도록 유도 (서버에서 할 수 없음)
    // 클라이언트가 토큰을 삭제하면, 사실상 로그아웃이 이루어짐.
    // (세션 기반으로 로그인 하는 경우라면 세션 삭제 처리)
    return res.status(200).json({
      success: true,
      data: result,
      message: "정상적으로 로그아웃되었습니다.",
    });
  } catch (error) {
    console.error("Logout Error:", error);
    return res.status(500).json({
      success: false,
      message: "로그아웃 중 오류가 발생했습니다.",
    });
  }
});

router.post("/regist-apns", async (req, res, next) => {
  console.log(req.body);
  const { userName, deviceToken } = req.body;
  try {
    const result = await User.update(
      { deviceToken: deviceToken },
      { where: { userName: userName } }
    );
    if (result) {
      res.status(200).json({
        success: true,
        member: {
          userName: userName,
        },
        message: "device token 등록에 성공했습니다.",
      });
    } else {
      res.status(404).json({
        message: "존재하지않는 아이디입니다.",
      });
    }
  } catch (err) {
    next(err);
  }
});

router.post("/nick-dup-check", async (req, res, next) => {
  const { nickName } = req.body;
  try {
    const user = await User.findOne({ where: { nickName: nickName } });
    if (user) {
      res.status(200).json({ check: true });
    } else {
      res.status(200).json({ check: false });
    }
  } catch (e) {
    next(e);
  }
});

//userInfo 변경
router.post(
  "/change-userInfo",
  authorization,
  upload.single("profileImg"),
  async (req, res, next) => {
    const { email, nickName } = req.body;
    console.log(req.body);

    try {
      const updatedUser = User.update(
        { profileImg: req.filename, email: email },
        { where: { nickName: nickName } }
      );
      if (updatedUser) {
        return res
          .status(200)
          .json({ success: true, message: "수정에 성공했습니다." });
      } else {
        return res
          .status(404)
          .json({ success: false, message: "수정에 실패했습니다." });
      }
    } catch (e) {
      next(e);
    }
  }
);

//회원 탈퇴
router.delete("/withdraw:", authorization, async (req, res, next) => {
  const { password, userID } = req.body;

  try {
    const user = await User.findOne({ where: { id: userID } });
    if (user) {
      console.log("withdraw", password, user.password);
      const compared = await bcrypt.compare(password, user.password);
      if (compared) {
        // 삭제를 비동기적으로 처리하고 완료 후 결과를 확인
        const result = await User.destroy({ where: { id: userID } });

        if (result === 0) {
          return res
            .status(404)
            .json({ success: false, message: "대상을 찾을 수 없습니다." });
        }
        res.status(200).json({ success: true });
      } else {
        return res.status(200).json({ success: false });
      }
    } else {
      return res
        .status(404)
        .json({ success: false, message: "사용자가 존재하지 않습니다." });
    }
  } catch (e) {
    next(e);
  }
});

module.exports = router;
