import 'dart:io';

import '../Menus/lista_clientes.dart';
import '../Menus/cadastro_clientes.dart';
import '../Menus/excluir_clientes.dart';
import '../Menus/atualizar_dados.dart';
import '../Processar/processador_vendas.dart';

import './cliente_dao.dart';
import './limpar_tela.dart';

class MenuPrincipal {
  var clienteDao = ClienteDao();
  var listaClientes = ListaClientes();
  var cadastroClientes = CadastroClientes();
  var excluirClientes = ExcluirClientes();
  var atualizarDados = AtualizarDados();
  final processadorVendas = const ProcessadorVendas();

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
    print("[5] Processar vendas");
    print("[6] Sair");
    print("------------------------------");
    print("===============================");
  }

  Future<bool> escolherOpcao() async {
    stdout.write("Escolha uma opção: ");
    final escolha = stdin.readLineSync();
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
        processarVendas();
        return true;

      case "6":
        print("Encerrando!");
        return false;

      default:
        print("Opção inválida!");
        return true;
    }
  }

  void processarVendas() {
    print("Digite os valores das vendas separados por vírgula.");
    print("Use ponto para casas decimais. Exemplo: 100, 250.50, 80");
    stdout.write("Vendas: ");

    final entrada = stdin.readLineSync();
    if (entrada == null || entrada.trim().isEmpty) {
      print("Nenhuma venda foi informada.");
      return;
    }

    final partes = entrada.split(',');
    final vendas = <double>[];
    for (final parte in partes) {
      final valor = double.tryParse(parte.trim());
      if (valor == null) {
        print("Valor inválido: ${parte.trim()}");
        return;
      }
      vendas.add(valor);
    }

    final indicadores = processadorVendas.calcularIndicadores(vendas);
    print("\n===== INDICADORES DE VENDAS =====");
    print("Soma: ${indicadores.soma.toStringAsFixed(2)}");
    print("Média: ${indicadores.media.toStringAsFixed(2)}");
    print("Maior valor: ${indicadores.maior.toStringAsFixed(2)}");
    print("Menor valor: ${indicadores.menor.toStringAsFixed(2)}");
    print("=================================");
  }
}
