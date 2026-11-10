class Endereco {
  int? idEndereco;
  String estado;
  String tipoEndereco;
  String cep;
  String logradouro;
  int? numero;
  String? complemento;
  String? bairro;
  String cidade;

  Endereco({
    this.idEndereco,
    required this.estado,
    required this.tipoEndereco,
    required this.cep,
    required this.logradouro,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
  });
}
