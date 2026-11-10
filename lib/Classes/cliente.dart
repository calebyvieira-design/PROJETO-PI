class Cliente {
  int? idcliente;
  String tipoPessoa;
  String nomeCompleto;
  String cpfCnpj;
  String? rg;
  DateTime? dataNascimento;
  DateTime? dataCadastro;
  String statusCliente;
  String? nomePlano;
  DateTime? dataVencimento;

  Cliente({
    this.idcliente,
    required this.tipoPessoa,
    required this.nomeCompleto,
    required this.cpfCnpj,
    this.rg,
    required this.dataNascimento,
    this.dataCadastro,
    required this.statusCliente,
    this.nomePlano,
    this.dataVencimento,
  });

  @override
  String toString() {
    return """
    =============================================================================================
    --------------------------------------------------------------------------------------------
    | [$idcliente] Nome: $nomeCompleto | Data de Nascimento: $dataNascimento | 
    | Status do Cliente: $statusCliente | Próximo Vencimento: $dataVencimento |
    | CPF/CNPJ: $cpfCnpj | RG: $rg |
    | Plano: $nomePlano | Tipo de Pessoa: $tipoPessoa | Data do Cadastro: $dataCadastro |
    ---------------------------------------------------------------------------------------------
    ==============================================================================================
    """;
  }
}
