import 'dart:io';

import '../Menus/lista_clientes.dart';
import '../Menus/cadastro_clientes.dart';
import '../Menus/excluir_clientes.dart';
import '../Menus/atualizar_dados.dart';

import './cliente_dao.dart';
import './limpar_tela.dart';

class MenuPrincipal {
  var clienteDao = ClienteDao();
  var listaClientes = ListaClientes();
  var cadastroClientes = CadastroClientes();
  var excluirClientes = ExcluirClientes();
  var atualizarDados = AtualizarDados();

  MenuPrincipal() {
    executar();
  }

  Future<void> executar() async {
    bool continuar = true;
    while (continuar) {
      mostrarMenu();
      continuar = await escolherOpcao();
    }
  }

  void mostrarMenu() {
    print("==============================");
    print("------------------------------");
    print("     PROVEDOR DE INTERNET");
    print("------------------------------");
    print("[1] Listar Clientes");
    print("[2] Cadastrar Cliente");
    print("[3] Excluir Cliente");
    print("[4] Atualizar Dados Cadastrados");
    print("[5] Sair");
    print("------------------------------");
    print("===============================");
  }

  Future<bool> escolherOpcao() async {
    stdout.write("Escolha uma opção: ");
    String? escolha = stdin.readLineSync()!;
    LimparTela();

    switch (escolha) {
      case "1":
        await listaClientes.listar();
        return true;

      case "2":
        await cadastroClientes.cadastrar();
        return true;

      case "3":
        await excluirClientes.excluir();
        return true;

      case "4":
        await atualizarDados.atualizar();
        return true;

      case "5":
        print("Encerrando!");
        return false;

      default:
        print("Opção inválida!");
        return true;
    }
  }
}
