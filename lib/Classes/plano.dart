class Plano {
  int? idPlano;
  String nome;
  int? velocidade;
  double? mensalidade;
  int? idContrato;

  Plano({
    this.idPlano,
    required this.nome,
    required this.velocidade,
    required this.mensalidade,
    this.idContrato
  });
}
