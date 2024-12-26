const axios = require("axios");
const dotenv = require("dotenv");
dotenv.config({ path: "../.env" });

// Azure Text Analytics 서비스 정보
const subscriptionKey = process.env.LANGUAGE_APIKEY;
// Azure Portal에서 받은 API Key
const endpoint = process.env.LANGUAGE_ENDPOINT;

// 추출할 텍스트 데이터
async function extractSentiment(content) {
  console.log("%%%%%%%%%%%", content);
  try {
    const textToAnalyze = {
      documents: [
        {
          id: "1",
          language: "ko",
          text: content,
        },
      ],
    };
    console.log(textToAnalyze);

    const response = await axios.post(endpoint, textToAnalyze, {
      headers: {
        "Ocp-Apim-Subscription-Key": subscriptionKey,
        "Content-Type": "application/json",
      },
    });

    const documents = response.data.documents;
    const result = documents[0].confidenceScores;
    console.log("-------", result);
    // return result;
    if (result.positive > result.negative && result.positive > result.neutral) {
      return "positive";
    } else if (
      result.negative > result.positive &&
      result.negative > result.neutral
    ) {
      return "negative";
    } else {
      return "neutral";
    }
    // documents.forEach((document) => {
    //   console.log(`${document.id}:${document.sentiment}`);
    // });
  } catch (error) {
    console.error(
      "Error extracting sentiment:",
      error.response ? error.response.data : error.message
    );
    return error.message;
  }
}

// // 함수 실행
// extractSentiment();

module.exports = extractSentiment;
