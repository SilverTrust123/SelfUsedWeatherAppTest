// api/weather.js
const axios = require('axios');

module.exports = async (req, res) => {
  const city = req.query.city;
  const latitude = req.query.lat; // 新增：支援經度
  const longitude = req.query.lon; // 新增：支援緯度
  const endpoint = req.query.endpoint || 'weather'; // 新增：支援不同的 OpenWeatherMap API 端點 (例如: 'weather' 或 'forecast')
  const apiKey = process.env.OPEN_WEATHER_KEY; // 從 Vercel 環境變數獲取 API Key

  if (!apiKey) {
    // 確保 API Key 已設定
    return res.status(500).json({ error: 'Server configuration error: OPEN_WEATHER_KEY is not set.' });
  }

  let apiUrl = '';
  let queryParams = { appid: apiKey, units: 'metric', lang: 'zh_tw' }; // 基本查詢參數

  if (city) {
    // 如果傳入城市名稱
    apiUrl = `https://api.openweathermap.org/data/2.5/${endpoint}?q=${city}`;
  } else if (latitude && longitude) {
    // 如果傳入經緯度
    apiUrl = `https://api.openweathermap.org/data/2.5/${endpoint}?lat=${latitude}&lon=${longitude}`;
  } else {
    // 如果沒有提供城市或經緯度，返回錯誤
    return res.status(400).json({ error: 'City, or both latitude and longitude, are required.' });
  }

  // 將基本查詢參數加入到 URL 中
  for (const key in queryParams) {
    apiUrl += `&${key}=${queryParams[key]}`;
  }

  try {
    const response = await axios.get(apiUrl);
    res.status(200).json(response.data);
  } catch (error) {
    console.error('Weather API request error:', error.message);
    if (error.response) {
      // 如果是 OpenWeatherMap API 返回的錯誤
      res.status(error.response.status).json({ 
        error: 'Weather API error', 
        details: error.response.data,
        statusCode: error.response.status 
      });
    } else {
      // 其他錯誤
      res.status(500).json({ error: 'Internal server error', details: error.message });
    }
  }
};