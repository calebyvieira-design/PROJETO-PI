import 'package:mysql_client/mysql_client.dart';
import './database.dart';
import './cliente.dart';
import './endereco.dart';
import './contato.dart';
import './plano.dart';
import './contrato_assinatura.dart';
import './calcular_vencimento.dart';

class ClienteDao {
  Future<List> listarClientes() async {
    List<Cliente> lista = [];
    MySQLConnection? conn;

    try {
      conn = await Database.abrirConexao();

      var resultado = await conn.execute("SELECT * FROM clientes");

      for (var linha in resultado.rows) {
        int id = int.parse(linha.colByName("idcliente").toString());
        
        var sql = "SELECT planos.nome, contratosassinaturas.vencimentoFatura FROM CLIENTES JOIN contratosassinaturas ON (contratosassinaturas.idcontrato = clientes.contratosAssinaturas_idcontrato) JOIN planos ON (planos.contratosAssinaturas_idcontrato = contratosassinaturas.idcontrato) WHERE clientes.idcliente = :idcliente";

        var plano = await conn.execute(sql, {
          "idcliente": id
        });
        String nomePlano = plano.rows.first.assoc()['nome'].toString();
        String dataVencimento = plano.rows.first.assoc()['vencimentoFatura'].toString();

        lista.add(Cliente(
          idcliente: int.tryParse(linha.colByName("idcliente").toString()), 
          tipoPessoa: linha.colByName("tipoPessoa").toString(), 
          nomeCompleto: linha.colByName("nomeCompleto").toString(), 
          cpfCnpj: linha.colByName("cpfCnpj").toString(),
          rg: linha.colByName("rg").toString(),
          dataNascimento: DateTime.tryParse(linha.colByName("dataNascimento").toString()),
          dataCadastro: DateTime.tryParse(linha.colByName("dataCadastro").toString()), 
          statusCliente: linha.colByName("statusCliente").toString(),
          nomePlano: nomePlano.toString(),
          dataVencimento: DateTime.parse(dataVencimento)
        ));
      }

    } catch (e) {
      print("Erro ao listar os clientes: $e");
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
    return lista;
  }

  Future<bool> verificarCliente(int id) async {
    MySQLConnection? conn;
    bool existe = false;

    try {
      conn = await Database.abrirConexao();

      var sql = "SELECT * FROM clientes WHERE idcliente = :id";
      var cliente = await conn.execute(sql, {
        "id": id
      });

      if (cliente.rows.isNotEmpty) {
        existe = true;
      }

    } catch(e) {
      print("Erro ao verificar o cliente: $e");
    } finally {
      if (conn != null && conn.connected) {
        conn.close();
      }
    }

    return existe;
  }

  Future<void> cadastrarCliente(Cliente cliente, Endereco endereco, Contato contato, Plano plano) async {
    MySQLConnection? conn;

    try {
      conn = await Database.abrirConexao();

      print("Cadastrando endereço...");
      int idendereco = await inserirEndereco(endereco, conn);

      print("Cadastrando contato...");
      int idcontato = await inserirContato(contato, conn);

      print("Cadastrando plano...");
      int idcontrato = await inserirPlano(plano, conn);

      print("Cadastrando cliente...");
      await inserirCliente(cliente, idendereco, idcontato, idcontrato, conn);

      print("--------------------------------------");
      print("   Cliente cadastrado com sucesso!");
      print("--------------------------------------");
    } catch (e) {
      print("Erro ao cadastrar o cliente: $e");
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  Future<int> inserirEndereco(Endereco endereco, MySQLConnection conn) async {
    var sql = "INSERT INTO enderecos (logradouro, numero, complemento, bairro, cidade, cep, estado, tipoEndereco) VALUES (:logradouro, :numero, :complemento, :bairro, :cidade, :cep, :estado, :tipoEndereco)";

    await conn.execute(sql, {
      "logradouro": endereco.logradouro,
      "numero": endereco.numero,
      "complemento": endereco.complemento,
      "bairro": endereco.bairro,
      "cidade": endereco.cidade,
      "cep": endereco.cep,
      "estado": endereco.estado,
      "tipoEndereco": endereco.tipoEndereco
    });

    sql = "SELECT LAST_INSERT_ID()";
    var resultado = await conn.execute(sql);

    int idendereco = int.parse(resultado.rows.first.assoc()['LAST_INSERT_ID()'].toString());
    return idendereco;
  }

  Future<int> inserirContato(Contato contato, MySQLConnection conn) async {
    var sql = "INSERT INTO contatos (telefonePrincipal, telefoneSecundario, email, aceitaNotificacao) VALUES (:telefonePrincipal, :telefoneSecundario, :email, :aceitaNotificacao)";

    await conn.execute(sql, {
      "telefonePrincipal": contato.telefonePrincipal,
      "telefoneSecundario": contato.telefoneSecundario,
      "email": contato.email,
      "aceitaNotificacao": contato.aceitaNotificacao
    });

    sql = "SELECT LAST_INSERT_ID()";
    var resultado = await conn.execute(sql);

    int idcontato = int.parse(resultado.rows.first.assoc()['LAST_INSERT_ID()'].toString());
    return idcontato;
  }

  Future<int> inserirPlano(Plano plano, MySQLConnection conn) async {
    // Para calcular a data de vencimento para o contrato
    DateTime dataVencimento = CalcularVencimento().calculo();
    ContratoAssinatura contrato = ContratoAssinatura(dataAdesao: DateTime.now(), vencimentoFatura: dataVencimento);

    // Insere o contrato no sistema primeiro, visto que um plano necessita estar atrelado a um contrato
    var sql = "INSERT INTO contratosassinaturas (dataAdesao, vencimentoFatura) VALUES (:dataAdesao, :vencimentoFatura)";
    await conn.execute(sql, {
      "dataAdesao": contrato.dataAdesao,
      "vencimentoFatura": contrato.vencimentoFatura
    });

    sql = "SELECT LAST_INSERT_ID()";
    var resultado = await conn.execute(sql);
    
    int idcontrato = int.parse(resultado.rows.first.assoc()['LAST_INSERT_ID()'].toString());

    sql = "INSERT INTO planos (nome, velocidade, mensalidade, contratosAssinaturas_idcontrato) VALUES (:nome, :velocidade, :mensalidade, LAST_INSERT_ID())";
    await conn.execute(sql, {
      "nome": plano.nome,
      "velocidade": plano.velocidade,
      "mensalidade": plano.mensalidade
    });

    return idcontrato;
  }

  Future<void> inserirCliente(Cliente cliente, int idendereco, int idcontato, int idcontrato, MySQLConnection conn) async {
    var sql = "INSERT INTO clientes (nomeCompleto, tipoPessoa, cpfCnpj, rg, dataNascimento, dataCadastro, statusCliente, enderecos_idendereco, contatos_idcontato, contratosassinaturas_idcontrato) VALUES (:nomeCompleto, :tipoPessoa, :cpfCnpj, :rg, :dataNascimento, :dataCadastro, :statusCliente, :enderecos_idendereco, :contatos_idcontato, :contratosassinaturas_idcontrato)";

    await conn.execute(sql, {
      "nomeCompleto": cliente.nomeCompleto, 
      "tipoPessoa": cliente.tipoPessoa, 
      "cpfCnpj": cliente.cpfCnpj, 
      "rg": cliente.rg, 
      "dataNascimento": cliente.dataNascimento, 
      "dataCadastro": DateTime.now(),
      "statusCliente": "Ativo", 
      "enderecos_idendereco": idendereco, 
      "contatos_idcontato": idcontato, 
      "contratosassinaturas_idcontrato": idcontrato
    });
  }

  Future<void> atualizarCliente(
    Cliente cliente,
    Endereco endereco,
    Contato contato,
    ContratoAssinatura contratoAssinatura,
    Plano plano,
  ) async {
    MySQLConnection? conn;

    try {
      conn = await Database.abrirConexao();

      if (cliente.idcliente == null) {
        print("O ID do cliente é inválido!");
        return;
      }

      int idCliente = cliente.idcliente!;
      var resultado = await conn.execute(
        "SELECT clientes.enderecos_idendereco, clientes.contatos_idcontato, "
        "clientes.contratosAssinaturas_idcontrato, planos.idplano "
        "FROM clientes "
        "JOIN planos ON planos.contratosAssinaturas_idcontrato = "
        "clientes.contratosAssinaturas_idcontrato "
        "WHERE clientes.idcliente = $idCliente",
      );

      if (resultado.rows.isEmpty) {
        print("Não existe nenhum cliente com o ID informado!");
        return;
      }

      endereco.idEndereco = int.parse(
        resultado.rows.first.colByName("enderecos_idendereco").toString(),
      );
      contato.idContato = int.parse(
        resultado.rows.first.colByName("contatos_idcontato").toString(),
      );
      contratoAssinatura.idcontrato = int.parse(
        resultado.rows.first
            .colByName("contratosAssinaturas_idcontrato")
            .toString(),
      );
      plano.idPlano = int.parse(
        resultado.rows.first.colByName("idplano").toString(),
      );
      plano.idContrato = contratoAssinatura.idcontrato;

      String escaparTexto(String valor) =>
          valor.replaceAll(r'\', r'\\').replaceAll("'", "''");

      if (cliente.nomeCompleto.isNotEmpty) {
        await conn.execute(
          "UPDATE clientes SET nomeCompleto = '${escaparTexto(cliente.nomeCompleto)}' "
          "WHERE idcliente = $idCliente",
        );
      }
      if (cliente.tipoPessoa.isNotEmpty) {
        await conn.execute(
          "UPDATE clientes SET tipoPessoa = '${escaparTexto(cliente.tipoPessoa)}' "
          "WHERE idcliente = $idCliente",
        );
      }
      if (cliente.cpfCnpj.isNotEmpty) {
        await conn.execute(
          "UPDATE clientes SET cpfCnpj = '${escaparTexto(cliente.cpfCnpj)}' "
          "WHERE idcliente = $idCliente",
        );
      }
      if (cliente.rg != null && cliente.rg!.isNotEmpty) {
        await conn.execute(
          "UPDATE clientes SET rg = '${escaparTexto(cliente.rg!)}' "
          "WHERE idcliente = $idCliente",
        );
      }
      if (cliente.dataNascimento != null) {
        await conn.execute(
          "UPDATE clientes SET dataNascimento = "
          "'${cliente.dataNascimento!.toIso8601String().split("T").first}' "
          "WHERE idcliente = $idCliente",
        );
      }

      if (endereco.logradouro.isNotEmpty) {
        await conn.execute(
          "UPDATE enderecos SET logradouro = '${escaparTexto(endereco.logradouro)}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }
      if (endereco.numero != null) {
        await conn.execute(
          "UPDATE enderecos SET numero = '${endereco.numero}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }
      if (endereco.complemento != null && endereco.complemento!.isNotEmpty) {
        await conn.execute(
          "UPDATE enderecos SET complemento = '${escaparTexto(endereco.complemento!)}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }
      if (endereco.bairro != null && endereco.bairro!.isNotEmpty) {
        await conn.execute(
          "UPDATE enderecos SET bairro = '${escaparTexto(endereco.bairro!)}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }
      if (endereco.cidade.isNotEmpty) {
        await conn.execute(
          "UPDATE enderecos SET cidade = '${escaparTexto(endereco.cidade)}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }
      if (endereco.cep.isNotEmpty) {
        await conn.execute(
          "UPDATE enderecos SET cep = '${escaparTexto(endereco.cep)}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }
      if (endereco.estado.isNotEmpty) {
        await conn.execute(
          "UPDATE enderecos SET estado = '${escaparTexto(endereco.estado)}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }
      if (endereco.tipoEndereco.isNotEmpty) {
        await conn.execute(
          "UPDATE enderecos SET tipoEndereco = '${escaparTexto(endereco.tipoEndereco)}' "
          "WHERE idendereco = ${endereco.idEndereco}",
        );
      }

      if (contato.telefonePrincipal.isNotEmpty) {
        await conn.execute(
          "UPDATE contatos SET telefonePrincipal = "
          "'${escaparTexto(contato.telefonePrincipal)}' "
          "WHERE idcontato = ${contato.idContato}",
        );
      }
      if (contato.telefoneSecundario != null &&
          contato.telefoneSecundario!.isNotEmpty) {
        await conn.execute(
          "UPDATE contatos SET telefoneSecundario = "
          "'${escaparTexto(contato.telefoneSecundario!)}' "
          "WHERE idcontato = ${contato.idContato}",
        );
      }
      if (contato.email.isNotEmpty) {
        await conn.execute(
          "UPDATE contatos SET email = '${escaparTexto(contato.email)}' "
          "WHERE idcontato = ${contato.idContato}",
        );
      }
      if (contato.aceitaNotificacao != null) {
        await conn.execute(
          "UPDATE contatos SET aceitaNotificacao = "
          "${contato.aceitaNotificacao! ? 1 : 0} "
          "WHERE idcontato = ${contato.idContato}",
        );
      }

      if (contratoAssinatura.dataAdesao != null) {
        await conn.execute(
          "UPDATE contratosassinaturas SET dataAdesao = "
          "'${contratoAssinatura.dataAdesao!.toIso8601String().split("T").first}' "
          "WHERE idcontrato = ${contratoAssinatura.idcontrato}",
        );
      }
      if (contratoAssinatura.vencimentoFatura != null) {
        await conn.execute(
          "UPDATE contratosassinaturas SET vencimentoFatura = "
          "'${contratoAssinatura.vencimentoFatura!.toIso8601String().split("T").first}' "
          "WHERE idcontrato = ${contratoAssinatura.idcontrato}",
        );
      }

      if (plano.nome.isNotEmpty) {
        await conn.execute(
          "UPDATE planos SET nome = '${escaparTexto(plano.nome)}' "
          "WHERE idplano = ${plano.idPlano}",
        );
      }
      if (plano.velocidade != null) {
        await conn.execute(
          "UPDATE planos SET velocidade = ${plano.velocidade} "
          "WHERE idplano = ${plano.idPlano}",
        );
      }
      if (plano.mensalidade != null) {
        await conn.execute(
          "UPDATE planos SET mensalidade = ${plano.mensalidade} "
          "WHERE idplano = ${plano.idPlano}",
        );
      }

      print("--------------------------------------");
      print("   Dados atualizados com sucesso!");
      print("--------------------------------------");
    } catch (e) {
      print("Erro ao atualizar os dados do cliente: $e");
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  Future<void> excluirCliente(int id) async {
    MySQLConnection? conn;

    try {
      conn = await Database.abrirConexao();
      var sql = 
      """
        -- 1. Desativa a checagem de chaves estrangeiras
        SET FOREIGN_KEY_CHECKS = 0;

        -- 2. Executa a exclusão em lote
        DELETE clientes, planos, contratosassinaturas, enderecos, contatos
        FROM clientes
        LEFT JOIN contratosAssinaturas ON (contratosassinaturas.idcontrato = clientes.contratosAssinaturas_idcontrato)
        LEFT JOIN planos ON (planos.contratosAssinaturas_idcontrato = contratosassinaturas.idcontrato)
        LEFT JOIN enderecos ON (enderecos.idendereco = clientes.enderecos_idendereco)
        LEFT JOIN contatos ON (contatos.idcontato = clientes.contatos_idcontato)
        WHERE clientes.idcliente = :id;

        -- 3. Reativa a checagem de chaves estrangeiras
        SET FOREIGN_KEY_CHECKS = 1;
      """;

      await conn.execute(sql, {
        "id": id
      });

      print("---------------------------------------");
      print("     Cliente excluído com sucesso!");
      print("---------------------------------------");
    } catch(e) {
      print("Erro ao excluir o cliente: $e");
    } finally {
      if (conn != null && conn.connected) {
        conn.close();
      }
    }
  }
}