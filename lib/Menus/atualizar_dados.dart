import 'dart:io';

import '../Classes/cliente_dao.dart';
import '../Classes/cliente.dart';
import '../Classes/endereco.dart';
import '../Classes/plano.dart';
import '../Classes/contato.dart';
import '../Classes/contrato_assinatura.dart';
import '../Classes/limpar_tela.dart';

class AtualizarDados {
  var clienteDao = ClienteDao();

  late Cliente cliente;
  late Endereco endereco;
  late Plano plano;
  late Contato contato;
  late ContratoAssinatura contratoAssinatura;

  Future<void> atualizar() async {
    print(' ------------------------------------');
    print('      Atualizar dados do Cliente  ');
    print(' ------------------------------------');

    stdout.write("Digite o ID do cliente que deseja atualizar: ");
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
      cliente = Cliente(
        idcliente: id,
        tipoPessoa: "",
        nomeCompleto: "",
        cpfCnpj: "",
        dataNascimento: null,
        statusCliente: "",
      );
      endereco = Endereco(
        estado: "",
        tipoEndereco: "",
        cep: "",
        logradouro: "",
        numero: null,
        bairro: "",
        cidade: "",
      );
      contato = Contato(
        telefonePrincipal: "",
        email: "",
        aceitaNotificacao: null,
      );
      plano = Plano(nome: "", velocidade: null, mensalidade: null);
      contratoAssinatura = ContratoAssinatura(
        dataAdesao: null,
        vencimentoFatura: null,
      );

      while (true) {
        bool pronto = dadosPessoais();
        if (pronto) {
          break;
        }
      }
      LimparTela();

      while (true) {
        bool pronto = dadosEndereco();
        if (pronto) {
          break;
        }
      }
      LimparTela();

      while (true) {
        bool pronto = dadosContato();
        if (pronto) {
          break;
        }
      }
      LimparTela();

      while (true) {
        bool pronto = dadosPlano();
        if (pronto) {
          break;
        }
      }
      LimparTela();

      await clienteDao.atualizarCliente(
        cliente,
        endereco,
        contato,
        contratoAssinatura,
        plano,
      );
    } else {
      print("Não existe nenhum cliente com o ID informado!");
    }
    stdout.write("Pressione ENTER para continuar...");
    stdin.readLineSync();
    LimparTela();
  }

  bool dadosPessoais() {
    print(
      "--------------------------------------------------------------------",
    );
    stdout.write(
      "Nome Completo (máx. 60 caracteres) (Deixe em branco para manter.): ",
    );
    cliente.nomeCompleto = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write(
      "Data de Nascimento (Digite no formato aaaa-mm-dd) (Deixe em branco para manter.): ",
    );
    cliente.dataNascimento = DateTime.tryParse(stdin.readLineSync()!);

    stdout.write(
      "Tipo de Pessoa (Fisica ou Juridica - NÃO COLOQUE ACENTO! (máx. 10 caracteres)) (Deixe em branco para manter.): ",
    );
    cliente.tipoPessoa = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write(
      "CPF/CNPJ (sem pontuação (máx. 14 caracteres)) (Deixe em branco para manter.): ",
    );
    cliente.cpfCnpj = stdin.readLineSync()!.trim();

    stdout.write("RG (máx. 9 caracteres) (Deixe em branco para manter.): ");
    cliente.rg = stdin.readLineSync()!.trim().toUpperCase();

    if ((!cliente.tipoPessoa.isEmpty &&
            cliente.tipoPessoa != "FISICA" &&
            cliente.tipoPessoa != "JURIDICA") ||
        cliente.nomeCompleto.length > 60 ||
        cliente.tipoPessoa.length > 10 ||
        cliente.cpfCnpj.length > 14 ||
        (cliente.rg?.length ?? 0) > 9) {
      print("Um ou mais campos são inválidos ou excedem o limite permitido!");
      return false;
    }

    return true;
  }

  bool dadosEndereco() {
    print(
      "--------------------------------------------------------------------",
    );
    stdout.write(
      "Logradouro (máx. 45 caracteres) (Deixe em branco para manter.): ",
    );
    endereco.logradouro = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write("Número (máx. 5 caracteres) (Deixe em branco para manter.): ");
    endereco.numero = int.tryParse(stdin.readLineSync()!);

    stdout.write(
      "Complemento (máx. 45 caracteres) (Deixe em branco para manter.): ",
    );
    endereco.complemento = stdin.readLineSync()!.trim();

    stdout.write(
      "Bairro (máx. 45 caracteres) (Deixe em branco para manter.): ",
    );
    endereco.bairro = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write(
      "Cidade (máx. 45 caracteres) (Deixe em branco para manter.): ",
    );
    endereco.cidade = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write(
      "CEP (sem traço, máx. 8 caracteres) (Deixe em branco para manter.): ",
    );
    endereco.cep = stdin.readLineSync()!.trim();

    stdout.write(
      "Estado (use apenas a sigla de duas letras) (Deixe em branco para manter.): ",
    );
    endereco.estado = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write(
      "Tipo de Endereço (máx. 20 caracteres) (Deixe em branco para manter.): ",
    );
    endereco.tipoEndereco = stdin.readLineSync()!.trim().toUpperCase();

    if (endereco.numero != null && endereco.numero! < 0 ||
        endereco.logradouro.length > 45 ||
        (endereco.complemento?.length ?? 0) > 45 ||
        (endereco.bairro?.length ?? 0) > 45 ||
        endereco.cidade.length > 45 ||
        endereco.cep.length > 8 ||
        endereco.estado.length > 2 ||
        endereco.tipoEndereco.length > 20 ||
        (endereco.numero?.toString().length ?? 0) > 5) {
      print("Um ou mais campos excedem o limite ou possuem valores inválidos!");
      return false;
    }

    return true;
  }

  bool dadosContato() {
    print(
      "--------------------------------------------------------------------",
    );
    stdout.write(
      "Telefone Principal (máx. 11 caracteres) (Deixe em branco para manter.): ",
    );
    contato.telefonePrincipal = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write(
      "Telefone Secundário (máx. 11 caracteres) (Deixe em branco para manter.): ",
    );
    contato.telefoneSecundario = stdin.readLineSync()!.trim().toUpperCase();

    stdout.write(
      "E-Mail (máx. 45 caracteres) (Deixe em branco para manter.): ",
    );
    contato.email = stdin.readLineSync()!.trim();

    stdout.write(
      "Aceita ser notificado sobre atualizações e mudanças? (S para sim, qualquer outra coisa para não) (Deixe em branco para manter.): ",
    );
    String respostaNotificacao = stdin.readLineSync()!.toUpperCase();
    if (respostaNotificacao.trim().isEmpty) {
      contato.aceitaNotificacao = null;
    } else {
      contato.aceitaNotificacao = respostaNotificacao == "S";
    }

    if (contato.telefonePrincipal.length > 11 ||
        (contato.telefoneSecundario?.length ?? 0) > 11 ||
        contato.email.length > 45) {
      print("Um ou mais campos excedem o limite de caracteres permitidos!");
      return false;
    }

    return true;
  }

  bool dadosPlano() {
    print(
      "--------------------------------------------------------------------",
    );
    print("=== Escolha do Plano ===");
    print(
      "--------------------------------------------------------------------",
    );
    print("[1] Plano Bronze | 100 Mbps | R\$ 89,90 por mês");
    print("[2] Plano Prata | 300 Mbps | R\$ 109,90 por mês");
    print("[3] Plano Ouro | 500 Mbps | R\$ 129,90 por mês");
    print("[4] Plano Diamante | 700 Mbps | R\$ 159,90 por mês");
    print("[5] Plano Fibra Turbo | 1 Gbps | R\$ 199,90 por mês");
    print("[6] Plano Família | 2 Gbps | R\$ 289,90 por mês");
    print("[7] Plano Empresarial | 6 Gbps | R\$ 799,90 por mês");
    print(
      "--------------------------------------------------------------------",
    );

    stdout.write(
      "Digite o número do plano (Deixe em branco para manter.): ",
    );
    String respostaPlano = stdin.readLineSync()!;
    if (respostaPlano.trim().isEmpty) {
      return true;
    }

    switch (int.tryParse(respostaPlano)) {
      case 1:
        plano.nome = "Plano Bronze";
        plano.velocidade = 100;
        plano.mensalidade = 89.9;
        break;

      case 2:
        plano.nome = "Plano Prata";
        plano.velocidade = 300;
        plano.mensalidade = 109.9;
        break;

      case 3:
        plano.nome = "Plano Ouro";
        plano.velocidade = 500;
        plano.mensalidade = 129.9;
        break;

      case 4:
        plano.nome = "Plano Diamante";
        plano.velocidade = 700;
        plano.mensalidade = 159.9;
        break;

      case 5:
        plano.nome = "Plano Fibra Turbo";
        plano.velocidade = 1000;
        plano.mensalidade = 199.9;
        break;

      case 6:
        plano.nome = "Plano Família";
        plano.velocidade = 2000;
        plano.mensalidade = 289.9;
        break;

      case 7:
        plano.nome = "Plano Empresarial";
        plano.velocidade = 6000;
        plano.mensalidade = 799.9;
        break;

      default:
        print("O valor digitado é inválido ou o plano não existe!");
        return false;
    }

    return true;
  }

}
