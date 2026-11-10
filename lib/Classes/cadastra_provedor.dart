// import 'cliente.dart';
// import 'contato.dart';
// import 'contrato_assinatura.dart';
// import 'endereco.dart';
// import 'plano.dart';

// class CadastroProvedor {
//   void executar() {
//     Cliente cliente = Cliente(
//       idcliente: 1,
//       tipoPessoa: 'PF',
//       nomeCompleto: 'Ana Exemplo',
//       cpfCnpj: '00000000000',
//       dataNascimento: DateTime(2000, 5, 20),
//       dataCadastro: DateTime.now(),
//       statusCliente: 'Ativo',
//     );

//     Endereco endereco = Endereco(
//       idEndereco: 1,
//       cliente: cliente,
//       estado: 'SP',
//       tipoEndereco: 'Residencial',
//       cep: '01001000',
//       logradouro: 'Rua Exemplo',
//       numero: '100',
//       bairro: 'Centro',
//       cidade: 'São Paulo',
//     );

//     Contato contato = Contato(
//       idContato: 1,
//       cliente: cliente,
//       telefonePrincipal: '11900000000',
//       email: 'ana@example.com',
//       aceitaNotificacao: true,
//     );

//     Plano plano = Plano(
//       idPlano: 1,
//       nome: 'Plano Prata',
//       velocidade: 300,
//       mensalidade: 109.90,
//     );

//     ContratoAssinatura contrato = ContratoAssinatura(
//       idContrato: 1,
//       cliente: cliente,
//       plano: plano,
//       enderecoInstalacao: endereco,
//       dataAdesao: DateTime.now(),
//       diaVencimentoFatura: 10,
//     );

//     print('Cliente: ${cliente.nomeCompleto}');
//     print('E-mail: ${contato.email}');
//     print('Endereço: ${endereco.logradouro}, ${endereco.numero}');
//     print('Contrato: ${contrato.idContrato}');
//     print('Plano: ${contrato.plano.nome}');
//     print('Velocidade: ${plano.velocidade} Mbps');
//     print('Mensalidade: R\$ ${plano.mensalidade.toStringAsFixed(2)}');
//     print('Vencimento: dia ${contrato.diaVencimentoFatura}');
//   }
// }
