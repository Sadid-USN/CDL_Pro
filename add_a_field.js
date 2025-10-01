const fs = require('fs');
const path = require('path');

// Путь к файлу road_signs.json
const filePath = path.join(__dirname, 'assets', 'DB', 'road_signs', 'road_signs.json');

// Читаем JSON
let raw;
try {
  raw = fs.readFileSync(filePath, 'utf8');
} catch (err) {
  console.error('❌ Ошибка чтения файла:', err);
  process.exit(1);
}

let json;
try {
  json = JSON.parse(raw);
} catch (e) {
  console.error('❌ Ошибка парсинга JSON:', e.message);
  process.exit(1);
}

if (!json.signs || typeof json.signs !== 'object') {
  console.error('⚠️ В файле нет поля "signs".');
  process.exit(1);
}

// Добавляем поле signName в каждую локализацию
for (const [signId, signData] of Object.entries(json.signs)) {
  for (const locale of ['en', 'ru', 'uk', 'es']) {
    if (signData[locale] && typeof signData[locale] === 'object') {
      if (!signData[locale].hasOwnProperty('signName')) {
        // Можно тут вставить свои реальные названия знаков,
        // пока ставим заглушку по id
        signData[locale]['signName'] = `Sign ${signId}`;
      }
    }
  }
}

// Записываем обратно в road_signs.json
try {
  fs.writeFileSync(filePath, JSON.stringify(json, null, 2), 'utf8');
  console.log('✅ Поле "signName" успешно добавлено во все локализации!');
} catch (err) {
  console.error('❌ Ошибка записи файла:', err);
}



// node add_a_field.js
