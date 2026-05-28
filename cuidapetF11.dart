import 'dart:io';

class Produto {
  final int codigo;
  final String nome;
  final double preco;
  
  Produto(this.codigo, this.nome, this.preco);
}

class Servico {
  final int codigo;
  final String nome;
  final double preco;

  Servico(this.codigo, this.nome, this.preco);
}

class Carrinho {
  final List<String> nomes = [];
  final List<double> precos = [];
  static const int limiteItens = 3;

  bool get estaVazio => nomes.isEmpty;
  bool get estaCheio => nomes.length >= limiteItens;
  int get quantidadeItens => nomes.length;
    
  bool adicionarItem(String nome, double preco) {
    if (estaCheio) return false;
    nomes.add(nome);
    precos.add(preco);
    return true;
  }

  bool removerItem(int indice) {
    if (indice >= 0 && indice < nomes.length) {
      nomes.removeAt(indice);
      precos.removeAt(indice);
      return true;
    }
    return false;
  }

  double calcularSubtotal() {
    return precos.fold(0.0, (soma, preco) => soma + preco);
  }

  void listarItens() {
    if (estaVazio) {
      print("Carrinho vazio.");
      return;
    }
    for (int i = 0; i < nomes.length; i++) {
      print("${i + 1}: ${nomes[i]} - R\$ ${precos[i].toStringAsFixed(2)}");
    }
  }

  void limpar() {
    nomes.clear();
    precos.clear();
  }
}

class SistemaCuidaPet {
  int _totalVendasDia = 0;
  double _valorTotalVendasDia = 0.0;
  bool _sistemaRodando = true;

  final List<Produto> _produtos = [
    Produto(101, "Ração Royal Canin Indoor 7,5kg", 290.00),
    Produto(102, "Ração Royal Canin Sterilised", 492.00),
    Produto(103, "Bifinho Keldog", 23.92),
    Produto(104, "Fraldas Descartáveis", 38.61),
  ];

  final List<Servico> _servicos = [
    Servico(201, "Banho e tosa", 55.99),
    Servico(202, "Tosa higienica", 12.99),
    Servico(203, "Hidratação dos pelos", 20.99),
  ];

  void _limparTela() => print("\x1B[2J\x1B[0;0H");

  void _pausar() {
    print("Pressione Enter para continuar...");
    stdin.readLineSync();
  }

  int _lerInt(String mensagem) {
    while (true) {
      print(mensagem);
      String? input = stdin.readLineSync();
      if (input != null && int.tryParse(input) != null) {
        return int.parse(input);
      }
      print("Entrada inválida! Digite um número.");
    }
  }

  double _lerDouble(String mensagem) {
    while (true) {
      print(mensagem);
      String? input = stdin.readLineSync();
      if (input != null && double.tryParse(input) != null) {
        return double.parse(input);
      }
      print("Entrada inválida! Digite um valor numérico.");
    }
  }

  String _lerPagamento(String mensagem) {
    while (true) {
      print(mensagem);
      String? input = stdin.readLineSync()?.toLowerCase();
      if (input != null && (input == 'd' || input == 'c')) {
        return input;
      }
      print("Opção inválida! Digite D para dinheiro ou C para cartão.");
    }
  }

  void iniciar() {
    while (_sistemaRodando) {
      _limparTela();
      print("--- BEM VINDO AO AUTOATENDIMENTO DO CUIDAPET ---");
      print("Por favor, digite o nome do cliente:");
      String? nome = stdin.readLineSync();

      if (nome == null || nome.isEmpty) {
        nome = "Cliente";
      }

      if (nome == "cuidapetrestrito") {
        _executarAreaRestrita();
      } else if (nome == "0") {
        _exibirRelatorioFinal();
      } else {
        _executarAtendimentoCliente(nome);
      }
    }
  }

  void _executarAreaRestrita() {
    _limparTela();
    print("--- ÁREA RESTRITA: FUNCIONÁRIO ---");
    print("Digite o nome do cliente:");
    String nomeCliente = stdin.readLineSync()!;
    double valorGasto = _lerDouble("Digite o valor gasto na loja:");
    String pag = _lerPagamento("Forma de pagamento (D - dinheiro / C - cartão):");

    double valorFinal = valorGasto;
    if (pag == 'd') {
      valorFinal = valorGasto - (valorGasto * 0.10);
    }

    print("Valor final a pagar pelo cliente $nomeCliente: R\$ ${valorFinal.toStringAsFixed(2)}");
    _totalVendasDia++;
    _valorTotalVendasDia += valorFinal;
    _pausar();
  }

  void _executarAtendimentoCliente(String nomeCliente) {
    Carrinho carrinho = Carrinho();
    bool clienteAtivo = true;

    while (clienteAtivo) {
      _limparTela();
      print("Olá $nomeCliente, escolha uma opção:");
      print("\n1 - Ver promoções");
      print("2 - Solicitar serviço");
      print("3 - Listar carrinho de compra");
      print("4 - Remover item do carrinho");
      print("5 - Finalizar carrinho de compra");
      print("6 - Voltar ao menu principal");
      print("0 - Sair\n");

      int op = _lerInt("Digite sua opção desejada:");

      switch (op) {
        case 1:
          _menuProdutos(carrinho);
          break;
        case 2:
          _menuServicos(carrinho);
          break;
        case 3:
          _limparTela();
          print("--- CARRINHO ---\n");
          carrinho.listarItens();
          _pausar();
          break;
        case 4:
          _removerItemCarrinho(carrinho);
          break;
        case 5:
          clienteAtivo = _finalizarCarrinho(carrinho);
          break;
        case 6:
          clienteAtivo = false;
          break;
        case 0:
          _sistemaRodando = false;
          clienteAtivo = false;
          break;
        default:
          print("Opção inválida.");
          _pausar();
      }
    }
  }

  void _menuProdutos(Carrinho carrinho) {
    bool menuProdutos = true;
    while (menuProdutos) {
      _limparTela();
      print("--- PRODUTOS ---\n");
      for (var p in _produtos) {
        print("${p.codigo} - ${p.nome} - R\$ ${p.preco.toStringAsFixed(2)}");
      }
      print("8 - Adicionar ao carrinho");
      print("0 - Voltar\n");

      int cod = _lerInt("Digite a opção desejada (8 para adicionar ao carrinho ou 0 para voltar):");

      if (cod == 8) {
        if (!carrinho.estaCheio) {
          int prodCod = _lerInt("Digite o código do produto (101-104):");
          Produto? produtoSelecionado;
          for (var p in _produtos) {
            if (p.codigo == prodCod) produtoSelecionado = p;
          }

          if (produtoSelecionado != null) {
            carrinho.adicionarItem(produtoSelecionado.nome, produtoSelecionado.preco);
            print("Item adicionado!");
          } else {
            print("Código de produto inválido.");
          }
        } else {
          print("ERRO: Carrinho cheio (máx ${Carrinho.limiteItens} itens).");
        }
        _pausar();
      } else if (cod == 0) {
        menuProdutos = false;
      } else {
        print("Opção inválida.");
        _pausar();
      }
    }
  }

  void _menuServicos(Carrinho carrinho) {
    bool menuServicos = true;
    while (menuServicos) {
      _limparTela();
      print("--- SERVIÇOS ---\n");
      for (var s in _servicos) {
        print("${s.codigo} - ${s.nome} - R\$ ${s.preco.toStringAsFixed(2)}");
      }
      print("8 - Adicionar ao carrinho");
      print("0 - Voltar\n");

      int cod = _lerInt("Digite a opção desejada (8 para adicionar ao carrinho ou 0 para voltar):");

      if (cod == 8) {
        if (!carrinho.estaCheio) {
          int servCod = _lerInt("Digite o código do serviço (201-203):");
          Servico? servicoSelecionado;
          for (var s in _servicos) {
            if (s.codigo == servCod) servicoSelecionado = s;
          }

          if (servicoSelecionado != null) {
            carrinho.adicionarItem(servicoSelecionado.nome, servicoSelecionado.preco);
            print("Serviço adicionado!");
          } else {
            print("Código de serviço inválido.");
          }
        } else {
          print("ERRO: Carrinho cheio (máx ${Carrinho.limiteItens} itens).");
        }
        _pausar();
      } else if (cod == 0) {
        menuServicos = false;
      } else {
        print("Opção inválida.");
        _pausar();
      }
    }
  }

  void _removerItemCarrinho(Carrinho carrinho) {
    _limparTela();
    print("--- REMOVER ITEM ---\n");
    if (carrinho.estaVazio) {
      print("Carrinho vazio.");
    } else {
      carrinho.listarItens();
      print("");
      int escolha = _lerInt("Digite o número do item que deseja remover (0 para voltar):");

      if (escolha != 0) {
        if (carrinho.removerItem(escolha - 1)) {
          print("Item removido com sucesso!");
        } else {
          print("Número inválido.");
        }
      }
    }
    _pausar();
  }

  bool _finalizarCarrinho(Carrinho carrinho) {
    _limparTela();
    if (carrinho.estaVazio) {
      print("Carrinho vazio, nada para finalizar.");
      _pausar();
      return true;
    }

    double subtotal = carrinho.calcularSubtotal();
    print("Total: R\$ ${subtotal.toStringAsFixed(2)}");
    String pagamento = _lerPagamento("Forma de pagamento (D - dinheiro / C - cartão):");

    if (pagamento == 'd') {
      subtotal -= (subtotal * 0.10);
      print("10% de desconto aplicado!");
    }

    print("Valor final: R\$ ${subtotal.toStringAsFixed(2)}");
    _totalVendasDia++;
    _valorTotalVendasDia += subtotal;
    carrinho.limpar();

    print("Compra finalizada! Volte sempre!");
    _pausar();

    print("");
    int escolhaPosVenda = _lerInt("1 - Realizar outro atendimento\n2 - Sair\nDigite sua opção:");
    if (escolhaPosVenda == 1) {
      return false;
    } else {
      _sistemaRodando = false;
      return false;
    }
  }

  void _exibirRelatorioFinal() {
    _limparTela();
    _sistemaRodando = false;
    print("--- RELATÓRIO DO DIA ---");
    print("Quantidade de vendas: $_totalVendasDia");
    print("Valor total das vendas: R\$ ${_valorTotalVendasDia.toStringAsFixed(2)}");
    print("Sistema encerrado.");
    _pausar();
    _limparTela();
  }
}

void main() {
  SistemaCuidaPet sistema = SistemaCuidaPet();
  sistema.iniciar();
}
