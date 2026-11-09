import 'dart:io';

import '../Classes/cliente_dao.dart';
import '../Classes/limpar_tela.dart';

class ListaClientes {
  var clienteDao = ClienteDao();

  Future<void> listar() async {
      print(' -----------------------');
      print('   Lista de Clientes  ');
      print(' -----------------------');
      var clientes = await clienteDao.listarClientes();

      if (clientes.isEmpty) {
        print("Nenhum clientes está cadastrado!");
      } else {
        for (var cliente in clientes) {
          print(cliente);
        }
        stdout.write("Pressione ENTER para continuar...");
        stdin.readLineSync();
        LimparTela();
      }
  }
}