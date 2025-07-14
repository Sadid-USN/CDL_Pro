const fs = require('fs');
const path = require('path');

// Путь к исходному JSON
const inputPath = path.join(__dirname, 'assets', 'DB', 'tests_uk', 'tests_uk.json');

// Путь к файлу-выходу
const outputPath = path.join(__dirname, 'assets', 'DB', 'tests_uk', 'tests_uk_with_ids.json');

// Чтение JSON
fs.readFile(inputPath, 'utf8', (err, data) => {
  if (err) {
    console.error('❌ Ошибка чтения файла:', err);
    return;
  }

  let json;
  try {
    json = JSON.parse(data);
  } catch (e) {
    console.error('❌ Ошибка парсинга JSON:', e.message);
    return;
  }

  const chapters = json.chapters;

  if (!chapters || typeof chapters !== 'object') {
    console.error('⚠️ Не найдены главы в JSON.');
    return;
  }

  for (const [chapterKey, chapter] of Object.entries(chapters)) {
    const questionsObj = chapter.questions;

    if (!questionsObj || typeof questionsObj !== 'object') {
      console.log(`⚠️ В главе ${chapterKey} нет вопросов.`);
      continue;
    }

    for (const [questionKey, questionData] of Object.entries(questionsObj)) {
      // Перебираем все локализации
      for (const locale of ['en', 'uk', 'ru', 'es']) {
        if (questionData[locale] && typeof questionData[locale] === 'object') {
          questionData[locale]['id'] = questionKey;
        }
      }
    }
  }

  // Записываем обратно в новый файл
  fs.writeFile(outputPath, JSON.stringify(json, null, 2), 'utf8', err => {
    if (err) {
      console.error('❌ Ошибка записи файла:', err);
    } else {
      console.log('✅ ID успешно добавлены во все вопросы!');
      console.log('👉 Файл сохранен сюда:', outputPath);
    }
  });
});
