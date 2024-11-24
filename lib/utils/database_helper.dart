import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS produtos (
        id INTEGER PRIMARY KEY,
        produto TEXT,
        quantidade INTEGER,
        preco REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS clientes (
        id INTEGER PRIMARY KEY,
        name TEXT,
        endereco TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pedidos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente TEXT,
        total REAL,
        isSynced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS itens_pedido (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pedido_id INTEGER,
        produto TEXT,
        quantidade INTEGER,
        preco REAL,
        desconto REAL,
        FOREIGN KEY (pedido_id) REFERENCES pedidos (id)
      )
    ''');
  }

  Future<void> insertProduto(Map<String, dynamic> produto) async {
    final db = await database;
    await db.insert('produtos', produto, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCliente(Map<String, dynamic> cliente) async {
    final db = await database;
    await db.insert('clientes', cliente, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    final orderId = await db.insert('pedidos', {
      'cliente': order['cliente'],
      'total': order['total'],
      'isSynced': 0,
    });
    for (var item in order['itens']) {
      await db.insert('itens_pedido', {
        'pedido_id': orderId,
        'produto': item['produto'],
        'quantidade': item['quantidade'],
        'preco': item['preco'],
        'desconto': item['desconto'],
      });
    }
  }

  Future<List<Map<String, dynamic>>> getProdutos() async {
    final db = await database;
    return await db.query('produtos');
  }

  Future<List<Map<String, dynamic>>> getClientes() async {
    final db = await database;
    return await db.query('clientes');
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('pedidos');
  }
   Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    final db = await database;
    return await db.query('itens_pedido', where: 'pedido_id = ?', whereArgs: [orderId]);
  }
   Future<void> updateOrderSyncStatus(int orderId, int isSynced) async {
    final db = await database;
    await db.update(
      'pedidos',
      {'isSynced': isSynced},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}