// test-api.js
// Copia esto a tu proyecto backend y ejecuta: node test-api.js

const http = require('http');

console.log('🔵 Testeando: http://localhost:3000/kajamart/api/clients\n');

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/kajamart/api/clients',
  method: 'GET',
  headers: {
    'Accept': 'application/json',
  },
};

const req = http.request(options, (res) => {
  let data = '';

  console.log(`Status: ${res.statusCode}`);
  console.log(`Headers: ${JSON.stringify(res.headers)}\n`);

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    console.log('📋 Response Body:');
    console.log(data);

    if (res.statusCode === 200) {
      try {
        const parsed = JSON.parse(data);
        console.log(`\n✅ JSON válido. Total clientes: ${parsed.length}`);
        if (parsed.length > 0) {
          console.log(`Primera cliente: ${JSON.stringify(parsed[0], null, 2)}`);
        }
      } catch (e) {
        console.log(`\n❌ JSON inválido: ${e.message}`);
      }
    }
  });
});

req.on('error', (e) => {
  console.error(`❌ Error: ${e.message}`);
  console.error('¿Backend corriendo? npm start');
});

req.end();
