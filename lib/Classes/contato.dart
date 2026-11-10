class Contato {
  int? idContato;
  String telefonePrincipal;
  String? telefoneSecundario;
  String email;
  bool? aceitaNotificacao;

  Contato({
    this.idContato,
    required this.telefonePrincipal,
    this.telefoneSecundario,
    required this.email,
    required this.aceitaNotificacao,
  });
}
