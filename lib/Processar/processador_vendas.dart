class IndicadoresVendas {
  final double soma;
  final double media;
  final double maior;
  final double menor;

  const IndicadoresVendas({
    required this.soma,
    required this.media,
    required this.maior,
    required this.menor,
  });
}

class ProcessadorVendas {
  const ProcessadorVendas();

  double calcularSoma(List<double> vendas) {
    _validarVendas(vendas);

    var soma = 0.0;
    for (final venda in vendas) {
      soma += venda;
    }
    return soma;
  }

  double calcularMedia(List<double> vendas) {
    _validarVendas(vendas);
    return calcularSoma(vendas) / vendas.length;
  }

  double encontrarMaior(List<double> vendas) {
    _validarVendas(vendas);

    var maior = vendas.first;
    for (final venda in vendas.skip(1)) {
      if (venda > maior) {
        maior = venda;
      }
    }
    return maior;
  }

  double encontrarMenor(List<double> vendas) {
    _validarVendas(vendas);

    var menor = vendas.first;
    for (final venda in vendas.skip(1)) {
      if (venda < menor) {
        menor = venda;
      }
    }
    return menor;
  }

  IndicadoresVendas calcularIndicadores(List<double> vendas) {
    _validarVendas(vendas);

    var soma = 0.0;
    var maior = vendas.first;
    var menor = vendas.first;

    for (final venda in vendas) {
      soma += venda;
      if (venda > maior) {
        maior = venda;
      }
      if (venda < menor) {
        menor = venda;
      }
    }

    return IndicadoresVendas(
      soma: soma,
      media: soma / vendas.length,
      maior: maior,
      menor: menor,
    );
  }

  void _validarVendas(List<double> vendas) {
    if (vendas.isEmpty) {
      throw StateError('A lista de vendas não pode estar vazia.');
    }

    if (vendas.any((venda) => !venda.isFinite)) {
      throw ArgumentError('Os valores de venda devem ser finitos.');
    }
  }
}
