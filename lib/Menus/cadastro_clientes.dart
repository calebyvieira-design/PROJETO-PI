import 'dart:io';

import '../Classes/cliente_dao.dart';
import '../Classes/cliente.dart';
import '../Classes/endereco.dart';
import '../Classes/plano.dart';
import '../Classes/contato.dart';
import '../Classes/limpar_tela.dart';

abstract class CadastroBase {
  bool textoValido(String valor, int limite, {bool obrigatorio = true}) {
    return (!obrigatorio || valor.isNotEmpty) && valor.length <= limite;
  }

  bool numeroValido(int? valor) {
    return valor != null && valor >= 0;
  }
}

class CadastroClientes extends CadastroBase {
  final ClienteDao _clienteDao = ClienteDao();
  late final Cliente _cliente;
  late final Endereco _endereco;
  late final Plano _plano;
  late final Contato _contato;

  // Dados Pessoais
  String _nome = "";
  DateTime? _dataNascimento;
  String _tipoPessoa = "";
  String _cpfCnpj = "";
  String _rg = "";

  // Dados do Endereço
  String _logradouro = "";
  int? _numero;
  String _complemento = "";
  String _bairro = "";
  String _cidade = "";
  String _cep = "";
  String _estado = "";
  String _tipoEndereco = "";

  // Dados do Contrato
  DateTime? _dataAdesao;
  DateTime? _vencimentoFatura;

  // Dados do Plano
  String _nomePlano = "";
  int? _velocidade;
  double? _mensalidade;

  // Dados do Contato
  String _telefonePrincipal = "";
  String _telefoneSecundario = "";
  String _email = "";
  bool? _aceitaNotificacao;

  String get nome => _nome;
  set nome(String valor) => _nome = valor.trim();
  DateTime? get dataNascimento => _dataNascimento;
  set dataNascimento(DateTime? valor) => _dataNascimento = valor;
  String get tipoPessoa => _tipoPessoa;
  set tipoPessoa(String valor) => _tipoPessoa = valor.trim();
  String get cpfCnpj => _cpfCnpj;
  set cpfCnpj(String valor) => _cpfCnpj = valor.trim();
  String get rg => _rg;
  set rg(String valor) => _rg = valor.trim();
  String get logradouro => _logradouro;
  set logradouro(String valor) => _logradouro = valor.trim();
  int? get numero => _numero;
  set numero(int? valor) => _numero = valor;
  String get complemento => _complemento;
  set complemento(String valor) => _complemento = valor.trim();
  String get bairro => _bairro;
  set bairro(String valor) => _bairro = valor.trim();
  String get cidade => _cidade;
  set cidade(String valor) => _cidade = valor.trim();
  String get cep => _cep;
  set cep(String valor) => _cep = valor.trim();
  String get estado => _estado;
  set estado(String valor) => _estado = valor.trim();
  String get tipoEndereco => _tipoEndereco;
  set tipoEndereco(String valor) => _tipoEndereco = valor.trim();
  DateTime? get dataAdesao => _dataAdesao;
  set dataAdesao(DateTime? valor) => _dataAdesao = valor;
  DateTime? get vencimentoFatura => _vencimentoFatura;
  set vencimentoFatura(DateTime? valor) => _vencimentoFatura = valor;
  String get nomePlano => _nomePlano;
  set nomePlano(String valor) => _nomePlano = valor.trim();
  int? get velocidade => _velocidade;
  set velocidade(int? valor) => _velocidade = valor;
  double? get mensalidade => _mensalidade;
  set mensalidade(double? valor) => _mensalidade = valor;
  String get telefonePrincipal => _telefonePrincipal;
  set telefonePrincipal(String valor) => _telefonePrincipal = valor.trim();
  String get telefoneSecundario => _telefoneSecundario;
  set telefoneSecundario(String valor) => _telefoneSecundario = valor.trim();
  String get email => _email;
  set email(String valor) => _email = valor.trim();
  bool? get aceitaNotificacao => _aceitaNotificacao;
  set aceitaNotificacao(bool? valor) => _aceitaNotificacao = valor;

  double _calcularValorAnual() {
    return (_mensalidade ?? 0) * 12;
  }

  Future<void> cadastrar() async {
    print(' -----------------------');
    print('   Cadastro de Cliente  ');
    print(' -----------------------');
    print(
      '===================================================================================',
    );
    print(
      '  ATENÇÃO! NÃO DEIXE NENHUM CAMPO EM BRANCO (EXCETO SE O CAMPO DIZER O CONTRÁRIO)',
    );
    print(
      '===================================================================================',
    );

    while (true) {
      bool pronto = dadosPessoais();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    }
    LimparTela();

    while (true) {
      bool pronto = dadosEndereco();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    }
    LimparTela();

    while (true) {
      bool pronto = dadosContato();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    }
    LimparTela();

    while (true) {
      bool pronto = dadosPlano();
      if (pronto) {
        break;
      } else {
        bool conf = confirmacao();
        if (!conf) {
          return;
        }
      }
    }
    LimparTela();

    // Depois de tudo já ter sido inserido
    _cliente = Cliente(
      tipoPessoa: tipoPessoa,
      nomeCompleto: nome,
      cpfCnpj: cpfCnpj,
      rg: rg,
      dataNascimento: dataNascimento,
      statusCliente: "Ativo",
    );
    _endereco = Endereco(
      estado: estado,
      tipoEndereco: tipoEndereco,
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
    );
    _contato = Contato(
      telefonePrincipal: telefonePrincipal,
      email: email,
      aceitaNotificacao: aceitaNotificacao,
    );
    _plano = Plano(
      nome: nomePlano,
      velocidade: velocidade,
      mensalidade: mensalidade,
    );

    await _clienteDao.cadastrarCliente(_cliente, _endereco, _contato, _plano);
    stdout.write("Pressione ENTER para continuar...");
    stdin.readLineSync();
    LimparTela();
  }

  bool dadosPessoais() {
    print(
      "--------------------------------------------------------------------",
    );
    stdout.write("Nome Completo (máx. 60 caracteres): ");
    nome = stdin.readLineSync()!.toUpperCase();

    stdout.write("Data de Nascimento (Digite no formato aaaa-mm-dd): ");
    dataNascimento = DateTime.tryParse(stdin.readLineSync()!);

    stdout.write(
      "Tipo de Pessoa (Fisica ou Juridica - NÃO COLOQUE ACENTO! (máx. 10 caracteres)): ",
    );
    tipoPessoa = stdin.readLineSync()!.toUpperCase();
    print(tipoPessoa);

    switch (tipoPessoa) {
      case "FISICA":
        stdout.write("CPF (sem pontuação e traço  (máx. 14 caracteres)): ");
        cpfCnpj = stdin.readLineSync()!;
        break;

      case "JURIDICA":
        stdout.write(
          "CNPJ (sem pontuação, traço ou barra (máx. 14 caracteres)): ",
        );
        cpfCnpj = stdin.readLineSync()!;
        break;

      default:
        print("Tipo de pessoa inválido!");
        return false;
    }

    stdout.write("RG (opcional, pode deixar em branco (máx. 9 caracteres)): ");
    rg = stdin.readLineSync()!.toUpperCase();

    if (nome.isEmpty ||
        dataNascimento == null ||
        tipoPessoa.isEmpty ||
        cpfCnpj.isEmpty) {
      print("Um ou mais campos obrigatórios estão em branco ou inválidos!");
      return false;
    }

    if (!textoValido(nome, 60) ||
        !textoValido(tipoPessoa, 10) ||
        !textoValido(cpfCnpj, 14) ||
        !textoValido(rg, 9, obrigatorio: false)) {
      print("Um ou mais campos excedem o limite de caracteres permitidos!");
      return false;
    }

    return true;
  }

  bool dadosEndereco() {
    print(
      "--------------------------------------------------------------------",
    );
    stdout.write("Logradouro (máx. 45 caracteres): ");
    logradouro = stdin.readLineSync()!.toUpperCase();

    stdout.write("Número (máx. 5 caracteres): ");
    numero = int.tryParse(stdin.readLineSync()!);

    stdout.write(
      "Complemento (deixe em branco se não se aplica (máx. 45 caracteres)): ",
    );
    complemento = stdin.readLineSync()!;

    stdout.write("Bairro (máx. 45 caracteres): ");
    bairro = stdin.readLineSync()!.toUpperCase();

    stdout.write("Cidade (máx. 45 caracteres): ");
    cidade = stdin.readLineSync()!.toUpperCase();

    stdout.write("CEP (sem traço (máx. 8 caracteres)): ");
    cep = stdin.readLineSync()!;

    stdout.write(
      "Estado (use apenas a sigla de duas letras (máx. 2 caracteres)): ",
    );
    estado = stdin.readLineSync()!.toUpperCase();

    stdout.write("Tipo de Endereço (máx. 20 caracteres): ");
    tipoEndereco = stdin.readLineSync()!.toUpperCase();

    if (logradouro.isEmpty ||
        !numeroValido(numero) ||
        bairro.isEmpty ||
        cidade.isEmpty ||
        cep.isEmpty ||
        estado.isEmpty ||
        tipoEndereco.isEmpty) {
      print("Um ou mais campos obrigatórios estão em branco ou inválidos!");
      return false;
    }

    String chequeNumero = numero.toString();

    if (!textoValido(logradouro, 45) ||
        chequeNumero.length > 5 ||
        !textoValido(bairro, 45) ||
        !textoValido(cidade, 45) ||
        !textoValido(cep, 8) ||
        !textoValido(estado, 2) ||
        !textoValido(tipoEndereco, 20) ||
        !textoValido(complemento, 45, obrigatorio: false)) {
      print("Um ou mais campos excedem o limite de caracteres permitidos!");
      return false;
    }

    return true;
  }

  bool dadosContato() {
    print(
      "--------------------------------------------------------------------",
    );
    stdout.write("Telefone Principal (máx. 11 caracteres): ");
    telefonePrincipal = stdin.readLineSync()!.toUpperCase();

    stdout.write(
      "Telefone Secundário (opcional, pode deixar em branco (máx. 11 caracteres)): ",
    );
    telefoneSecundario = stdin.readLineSync()!.toUpperCase();

    stdout.write("E-Mail (máx. 45 caracteres): ");
    email = stdin.readLineSync()!;

    stdout.write(
      "Aceita ser notificado sobre atualizações e mudanças? (S para sim, qualquer outra coisa para não): ",
    );
    String aceita = stdin.readLineSync()!.toUpperCase();
    if (aceita == "S") {
      aceitaNotificacao = true;
    } else {
      aceitaNotificacao = false;
    }

    if (telefonePrincipal.isEmpty || email.isEmpty) {
      print("Um ou mais campos obrigatórios estão em branco ou inválidos!");
      return false;
    }

    if (!textoValido(telefonePrincipal, 11) ||
        !textoValido(telefoneSecundario, 11, obrigatorio: false) ||
        !textoValido(email, 45)) {
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
    stdout.write("Digite o número do plano: ");
    int? planoEscolhido = int.tryParse(stdin.readLineSync()!);

    switch (planoEscolhido) {
      case 1:
        nomePlano = "Plano Bronze";
        velocidade = 100;
        mensalidade = 89.9;
        break;

      case 2:
        nomePlano = "Plano Prata";
        velocidade = 300;
        mensalidade = 109.9;
        break;

      case 3:
        nomePlano = "Plano Ouro";
        velocidade = 500;
        mensalidade = 129.9;
        break;

      case 4:
        nomePlano = "Plano Diamante";
        velocidade = 700;
        mensalidade = 159.9;
        break;

      case 5:
        nomePlano = "Plano Fibra Turbo";
        velocidade = 1000;
        mensalidade = 199.9;
        break;

      case 6:
        nomePlano = "Plano Família";
        velocidade = 2000;
        mensalidade = 289.9;
        break;

      case 7:
        nomePlano = "Plano Empresarial";
        velocidade = 6000;
        mensalidade = 799.9;
        break;

      default:
        print("O valor digitado é inválido ou o plano não existe!");
        return false;
    }

    if (_calcularValorAnual() <= 0) {
      print("O plano selecionado deve possuir uma mensalidade válida!");
      return false;
    }

    return true;
  }

  bool confirmacao() {
    stdout.write(
      "Deseja continuar o cadastro? (S para continuar, qualquer outra coisa para parar): ",
    );
    String entrada = stdin.readLineSync()!.toUpperCase();
    LimparTela();
    if (entrada == "S") {
      return true;
    } else {
      return false;
    }
  }
}
