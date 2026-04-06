// test-api.js
// Copia esto a tu proyecto backend y ejecuta: node test-api.js

const https = require('https');
const apiUrl = new URL(
  'https://kajamart-api-hmate3egacewdkct.canadacentral-01.azurewebsites.net/kajamart/api/clients'
);

console.log(`🔵 Testeando: ${apiUrl.href}
`);

const req = https.request(
  apiUrl,
  {
    method: 'GET',
    headers: {
      'Accept': 'application/json',
    },
  },
  (res) => {
    let data = '';

    console.log(`Status: ${res.statusCode}`);
    console.log(`Headers: ${JSON.stringify(res.headers)}
`);

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      console.log('📋 Response Body:');
      console.log(data);

      if (res.statusCode === 200) {
        try {
          const parsed = JSON.parse(data);
          console.log(`
✅ JSON válido. Total clientes: ${parsed.length}`);
          if (parsed.length > 0) {
            console.log(`Primera cliente: ${JSON.stringify(parsed[0], null, 2)}`);
          }
        } catch (e) {
          console.log(`
❌ JSON inválido: ${e.message}`);
        }
      }
    });
  }
);

req.on('error', (e) => {
  console.error(`❌ Error: ${e.message}`);
  console.error('¿La API de Azure está disponible?');
});

req.end();
