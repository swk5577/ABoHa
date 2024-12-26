// require("./models/sync")();

const express = require("express");
const morgan = require("morgan");
const dotenv = require("dotenv");
dotenv.config();
const PORT = process.env.PORT || 3000;
const app = express();
const dailyRouter = require("./routers/dailyRouter");
const memberRouter = require("./routers/memberRouter");
const checklist = require("./routers/checklistRouter");

const db = require("./models");

app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/members", memberRouter);
app.use("/dailys", dailyRouter);
app.use("/checkList", checklist);

app.use((_, res) => {
  res.status(404).json({
    message: "존재하지 않은 API입니다. path와 method를 확인하십시오.",
  });
});

app.listen(PORT, () => {
  console.log(`Server is listening at ${PORT}`);
});
