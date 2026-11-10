class CalcularVencimento {

  DateTime calculo() {
    // Dia atual
    DateTime diaAtual = DateTime.now();

    // Calcula o ano e o mês de destino para tratar a virada de dezembro para janeiro
    late int anoAlvo = diaAtual.month == 12 ? diaAtual.year + 1 : diaAtual.year;
    late int mesAlvo = diaAtual.month == 12 ? 1 : diaAtual.month + 1;

    // Descobre o último dia válido do próximo mês
    // Passar o dia 0 do próximo mês retorna o último dia dele
    late int ultimoDiaDoProximoMes = DateTime(anoAlvo, mesAlvo + 1, 0).day;

    // Se o dia atual foi maior que o limite do próximo mês (como 31 de janeiro para fevereiro)
    // Ajusta para o último dia válido daquele mês
    late int diaAlvo = diaAtual.day > ultimoDiaDoProximoMes ? ultimoDiaDoProximoMes : diaAtual.day;

    // Monta o DateTime do próximo mês mantendo o mesmo horário
    late DateTime proximoMes = DateTime(
      anoAlvo,
      mesAlvo,
      diaAlvo,
      diaAtual.hour,
      diaAtual.minute,
      diaAtual.second,
      diaAtual.millisecond,
      diaAtual.microsecond
    );

    return proximoMes;
  }
}