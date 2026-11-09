import '../Classes/cliente_dao.dart';
import '../Classes/limpar_tela.dart';
import 'dart:io';

class ExcluirClientes {
  var clienteDao = ClienteDao();

  Future<void> excluir() async {
    print(' -----------------------');
    print('     Excluir Cliente  ');
    print(' -----------------------');
    stdout.write("Digite o ID do cliente que deseja excluir: ");
    int? id = int.tryParse(stdin.readLineSync()!);

    if (id == null || id < 1) {
      print("O ID informado é inválido!");
      stdout.write("Pressione ENTER para continuar...");
      stdin.readLineSync();
      LimparTela();
      return;
    }

    bool clienteExiste = await clienteDao.verificarCliente(id);

    if (clienteExiste) {
      await clienteDao.excluirCliente(id);
    } else {
      print("Não existe nenhum cliente com o ID informado!");
    }
    stdout.write("Pressione ENTER para continuar...");
    stdin.readLineSync();
    LimparTela();
  }
}