import 'package:mysql_client/mysql_client.dart';

class Database {
  static const String _host = "localhost";
  static const int _port = 3306;
  static const String _user = "root";
  static const String _password = ""; // Coloque a senha aqui
  static const String _dbname = "dadosinternet";

  static Future<MySQLConnection> abrirConexao() async {
    var conn = await MySQLConnection.createConnection(
      host: _host, 
      port: _port, 
      userName: _user, 
      password: _password,
      databaseName: _dbname,
      secure: true
    );

    await conn.connect();
    return conn;
  }
}