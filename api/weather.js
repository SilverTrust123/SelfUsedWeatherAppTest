// api/weather.js
const axios = require('axios');

module.exports = async (req, res) => {
  // --- 確保包含這些 CORS 標頭，這是解決 CORS 錯誤的關鍵 ---
  res.setHeader('Access-Control-Allow-Origin', '*'); // 允許所有來源
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS'); // 允許 GET, POST, OPTIONS 方法
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type'); // 允許 Content-Type 標頭

  // 處理 OPTIONS 預檢請求 (Preflight request)
  // 瀏覽器在發送實際請求前會先發送 OPTIONS 請求來檢查權限
  if (req.method === 'OPTIONS') {
    return res.status(200).end(); // 直接結束 OPTIONS 請求，返回成功狀態
  }
  // --- CORS 標頭結束 ---

  const city = req.query.city;
  const latitude = req.query.lat;
  const longitude = req.query.lon;
  const endpoint = req.query.endpoint || 'weather'; 
  const apiKey = process.env.OPEN_WEATHER_KEY; 

  if (!apiKey) {
    console.error('Server configuration error: OPEN_WEATHER_KEY is not set.');
    return res.status(500).json({ error: 'Server configuration error: OPEN_WEATHER_KEY is not set.' });
  }

  let apiUrl = '';
  let queryParams = { appid: apiKey, units: 'metric', lang: 'zh_tw' }; 

  if (city) {
    apiUrl = `https://api.openweathermap.org/data/2.5/${endpoint}?q=${city}`;
  } else if (latitude && longitude) {
    apiUrl = `https://api.openweathermap.org/data/2.5/${endpoint}?lat=${latitude}&lon=${longitude}`;
  } else {
    return res.status(400).json({ error: 'City, or both latitude and longitude, are required.' });
  }

  for (const key in queryParams) {
    apiUrl += `&${key}=${queryParams[key]}`;
  }

  console.log(`Attempting to fetch from OpenWeatherMap: ${apiUrl}`); 

  try {
    const response = await axios.get(apiUrl);
    res.status(200).json(response.data); 
  } catch (error) {
    console.error('Weather API request error:', error.message); 
    if (error.response) {
      res.status(error.response.status).json({ 
        error: 'Weather API error', 
        details: error.response.data,
        statusCode: error.response.status 
      });
    } else {
      res.status(500).json({ error: 'Internal server error', details: error.message });
    }
  }
};
