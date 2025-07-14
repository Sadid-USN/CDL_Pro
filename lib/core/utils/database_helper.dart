import 'package:cdl_pro/domain/models/models.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2, // Увеличиваем версию базы данных
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE questions (
            id TEXT PRIMARY KEY,
            question TEXT,
            options TEXT,
            correct_option TEXT,
            description TEXT,
            images TEXT,
            category TEXT
          )
        ''');
        await db.execute('CREATE INDEX idx_category ON questions(category)');
        await db.execute('''
          CREATE TABLE categories (
            category TEXT PRIMARY KEY,
            free_limit INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE categories (
              category TEXT PRIMARY KEY,
              free_limit INTEGER
            )
          ''');
        }
      },
    );
  }

  Future<void> insertQuestions(
    List<Question> questions,
    String category,
  ) async {
    final db = await database;
    final seenIds = <String>{};

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var question in questions) {
        final uniqueId = '${category}_${question.id}';
        if (seenIds.contains(uniqueId)) {
          debugPrint('Duplicate ID detected: $uniqueId for category $category');
          continue;
        }
        seenIds.add(uniqueId);

        final questionData = {
          'id': uniqueId,
          'question': question.question,
          'options': jsonEncode(question.options),
          'correct_option': question.correctOption,
          'description': question.description,
          'images': jsonEncode(question.images ?? []),
          'category': category,
        };

        final exists = await txn.query(
          'questions',
          where: 'id = ?',
          whereArgs: [uniqueId],
        );

        if (exists.isEmpty) {
          batch.insert('questions', questionData);
        } else {
          batch.update(
            'questions',
            questionData,
            where: 'id = ?',
            whereArgs: [uniqueId],
          );
        }
      }
      await batch.commit();
    });

    debugPrint(
      'Inserted/Updated ${seenIds.length} questions for category $category in SQLite',
    );
  }

  Future<void> insertCategoryMetadata(String category, int freeLimit) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('categories', {
        'category': category,
        'free_limit': freeLimit,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
    debugPrint(
      'Inserted/Updated metadata for category $category with free_limit $freeLimit',
    );
  }

  Future<void> clearQuestions() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('questions');
      // Проверяем, существует ли таблица categories
      final tables = await txn.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='categories'",
      );
      if (tables.isNotEmpty) {
        await txn.delete('categories');
      }
    });
    debugPrint('Cleared questions and categories tables in SQLite');
  }

  Future<List<Question>> getQuestionsByCategory(
    String category, {
    int? startIndex,
    int? endIndex,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    if (startIndex != null && endIndex != null) {
      maps = await db.query(
        'questions',
        where: 'category = ?',
        whereArgs: [category],
        limit: endIndex - startIndex + 1,
        offset: startIndex - 1,
      );
    } else {
      maps = await db.query(
        'questions',
        where: 'category = ?',
        whereArgs: [category],
      );
    }

    return maps
        .map(
          (map) => Question(
            id: map['id'].toString().split('_').last, // Извлекаем исходный id
            question: map['question'],
            options: Map<String, String>.from(jsonDecode(map['options'])),
            correctOption: map['correct_option'],
            description: map['description'],
            images: List<String>.from(jsonDecode(map['images'])),
            customId: map['id'].toString().split('_').last,
          ),
        )
        .toList();
  }

  Future<Chapters> getAllCategoriesMetadata() async {
    final db = await database;
    final categories = [
      'general_knowledge',
      'combination',
      'airBrakes',
      'tanker',
      'doubleAndTriple',
      'hazMat',
    ];

    final chapters = Chapters(
      generalKnowledge: await _getCategoryMetadata(db, 'general_knowledge'),
      combination: await _getCategoryMetadata(db, 'combination'),
      airBrakes: await _getCategoryMetadata(db, 'airBrakes'),
      tanker: await _getCategoryMetadata(db, 'tanker'),
      doubleAndTriple: await _getCategoryMetadata(db, 'doubleAndTriple'),
      hazMat: await _getCategoryMetadata(db, 'hazMat'),
    );

    return chapters;
  }

  Future<TestChapter> _getCategoryMetadata(Database db, String category) async {
    final result = await db.query(
      'questions',
      columns: ['COUNT(*) as total'],
      where: 'category = ?',
      whereArgs: [category],
    );
    final total = result.isNotEmpty ? result.first['total'] as int : 0;
    final freeLimitResult = await db.query(
      'categories',
      columns: ['free_limit'],
      where: 'category = ?',
      whereArgs: [category],
    );
    final freeLimit =
        freeLimitResult.isNotEmpty
            ? freeLimitResult.first['free_limit'] as int
            : total;

    return TestChapter(
      freeLimit: freeLimit,
      total: total,
      questions: {},
      parsedQuestions: [],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
