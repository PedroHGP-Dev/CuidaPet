import 'dart:io';

void limparTela() {
  print("\x1B[2J\x1B[0;0H");
}

void pausar() {
  print("Pressione Enter para continuar...");
  stdin.readLineSync();
}

int lerInt(String mensagem) {
  while (true) {
    print(mensagem);
    String? input = stdin.readLineSync();
    if (input != null && int.tryParse(input) != null) {
      return int.parse(input);
    }
    print("Entrada inválida! Digite um número.");
  }
}

double lerDouble(String mensagem) {
  while (true) {
    print(mensagem);
    String? input = stdin.readLineSync();
    if (input != null && double.tryParse(input) != null) {
      return double.parse(input);
    }
    print("Entrada inválida! Digite um valor numérico.");
  }
}

String lerPagamento(String mensagem) {
  while (true) {
    print(mensagem);
    String? input = stdin.readLineSync()?.toLowerCase();
    if (input != null && (input == 'd' || input == 'c')) {
      return input;
    }
    print("Opção inválida! Digite D para dinheiro ou C para cartão.");
  }
}

void main() {
  int totalVendasDia = 0;
  double valorTotalVendasDia = 0.0;
  bool sistemaRodando = true;

  while (sistemaRodando) {
    limparTela();
    print("--- BEM VINDO AO AUTOATENDIMENTO DO CUIDAPET ---");
    print("Por favor, digite o nome do cliente:");
    String? nome = stdin.readLineSync();

    if (nome == null || nome.isEmpty) {
      nome = "Cliente";
    }

    if (nome == "cuidapetrestrito") {
      limparTela();
      print("--- ÁREA RESTRITA: FUNCIONÁRIO ---");
      print("Digite o nome do cliente:");
      String nomeCliente = stdin.readLineSync()!;
      double valorGasto = lerDouble("Digite o valor gasto na loja:");
      String pag = lerPagamento(
        "Forma de pagamento (D - dinheiro / C - cartão):",
      );

      double valorFinal = valorGasto;
      if (pag == 'd') {
        valorFinal = valorGasto - (valorGasto * 0.10);
      }

      print(
        "Valor final a pagar pelo cliente $nomeCliente: R\$ ${valorFinal.toStringAsFixed(2)}",
      );
      totalVendasDia++;
      valorTotalVendasDia = valorTotalVendasDia + valorFinal;
      pausar();
    } else if (nome == "0") {
      limparTela();
      sistemaRodando = false;
      print("--- RELATÓRIO DO DIA ---");
      print("Quantidade de vendas: $totalVendasDia");
      print(
        "Valor total das vendas: R\$ ${valorTotalVendasDia.toStringAsFixed(2)}",
      );
      print("Sistema encerrado.");
      pausar();
      limparTela();
    } else {
      List<String> carrinhoNomes = [];
      List<double> carrinhoPrecos = [];
      bool clienteAtivo = true;

      while (clienteAtivo) {
        limparTela();
        print("Olá $nome, escolha uma opção:");
        print("");
        print("1 - Ver promoções");
        print("2 - Solicitar serviço");
        print("3 - Listar carrinho de compra");
        print("4 - Remover item do carrinho");
        print("5 - Finalizar carrinho de compra");
        print("6 - Voltar ao menu principal");
        print("0 - Sair");
        print("");

        int op = lerInt("Digite sua opção desejada:");

        switch (op) {
          case 1:
            bool menuProdutos = true;
            while (menuProdutos) {
              limparTela();
              print("--- PRODUTOS ---");
              print("");
              print("101 - Ração Royal Canin Indoor 7,5kg - R\$ 290,00");
              print("102 - Ração Royal Canin Sterilised - R\$ 492,00");
              print("103 - Bifinho Keldog - R\$ 23,92");
              print("104 - Fraldas Descartáveis - R\$ 38,61");
              print("8 - Adicionar ao carrinho");
              print("0 - Voltar");
              print("");

              int cod = lerInt(
                "Digite a opção desejada (8 para adicionar ao carrinho ou 0 para voltar):",
              );

              if (cod == 8) {
                if (carrinhoNomes.length < 3) {
                  int prodCod = lerInt("Digite o código do produto (101-104):");
                  if (prodCod == 101) {
                    carrinhoNomes.add("Ração Royal 7,5kg");
                    carrinhoPrecos.add(290.00);
                  } else if (prodCod == 102) {
                    carrinhoNomes.add("Ração Gatos");
                    carrinhoPrecos.add(492.00);
                  } else if (prodCod == 103) {
                    carrinhoNomes.add("Bifinho Keldog");
                    carrinhoPrecos.add(23.92);
                  } else if (prodCod == 104) {
                    carrinhoNomes.add("Fraldas");
                    carrinhoPrecos.add(38.61);
                  } else {
                    print("Código de produto inválido.");
                    pausar();
                    continue;
                  }
                  print("Item adicionado!");
                } else {
                  print("ERRO: Carrinho cheio (máx 3 itens).");
                }
                pausar();
              } else if (cod == 0) {
                menuProdutos = false;
              } else {
                print("Opção inválida.");
                pausar();
              }
            }
            break;

          case 2:
            bool menuServicos = true;
            while (menuServicos) {
              limparTela();
              print("--- SERVIÇOS ---");
              print("");
              print("201 - Banho e tosa - R\$ 55,99");
              print("202 - Tosa higienica - R\$ 12,99");
              print("203 - Hidratação dos pelos - R\$ 20,99");
              print("8 - Adicionar ao carrinho");
              print("0 - Voltar");
              print("");

              int cod = lerInt(
                "Digite a opção desejada (8 para adicionar ao carrinho ou 0 para voltar):",
              );

              if (cod == 8) {
                if (carrinhoNomes.length < 3) {
                  int servCod = lerInt("Digite o código do serviço (201-203):");
                  if (servCod == 201) {
                    carrinhoNomes.add("Banho e Tosa");
                    carrinhoPrecos.add(55.99);
                  } else if (servCod == 202) {
                    carrinhoNomes.add("Tosa Higienica");
                    carrinhoPrecos.add(12.99);
                  } else if (servCod == 203) {
                    carrinhoNomes.add("Hidratação");
                    carrinhoPrecos.add(20.99);
                  } else {
                    print("Código de serviço inválido.");
                    pausar();
                    continue;
                  }
                  print("Serviço adicionado!");
                } else {
                  print("ERRO: Carrinho cheio (máx 3 itens).");
                }
                pausar();
              } else if (cod == 0) {
                menuServicos = false;
              } else {
                print("Opção inválida.");
                pausar();
              }
            }
            break;

          case 3:
            limparTela();
            print("--- CARRINHO ---");
            print("");
            if (carrinhoNomes.isEmpty) {
              print("Carrinho vazio.");
            } else {
              for (int i = 0; i < carrinhoNomes.length; i++) {
                print(
                  "${i + 1}: ${carrinhoNomes[i]} - R\$ ${carrinhoPrecos[i].toStringAsFixed(2)}",
                );
              }
            }
            pausar();
            break;

          case 4:
            limparTela();
            print("--- REMOVER ITEM ---");
            print("");
            if (carrinhoNomes.isEmpty) {
              print("Carrinho vazio.");
            } else {
              for (int i = 0; i < carrinhoNomes.length; i++) {
                print("${i + 1}: ${carrinhoNomes[i]}");
              }
              print("");
              int escolha = lerInt(
                "Digite o número do item que deseja remover (0 para voltar):",
              );

              if (escolha != 0) {
                int indiceRemover = escolha - 1;
                if (indiceRemover >= 0 &&
                    indiceRemover < carrinhoNomes.length) {
                  carrinhoNomes.removeAt(indiceRemover);
                  carrinhoPrecos.removeAt(indiceRemover);
                  print("Item removido com sucesso!");
                } else {
                  print("Número inválido.");
                }
              }
            }
            pausar();
            break;

          case 5:
            limparTela();
            if (carrinhoNomes.isEmpty) {
              print("Carrinho vazio, nada para finalizar.");
              pausar();
            } else {
              double subtotal = 0;
              for (var preco in carrinhoPrecos) {
                subtotal = subtotal + preco;
              }
              print("Total: R\$ ${subtotal.toStringAsFixed(2)}");
              String pagamento = lerPagamento(
                "Forma de pagamento (D - dinheiro / C - cartão):",
              );

              if (pagamento == 'd') {
                subtotal = subtotal - (subtotal * 0.10);
                print("10% de desconto aplicado!");
              }

              print("Valor final: R\$ ${subtotal.toStringAsFixed(2)}");
              totalVendasDia++;
              valorTotalVendasDia = valorTotalVendasDia + subtotal;
              carrinhoNomes.clear();
              carrinhoPrecos.clear();

              print("Compra finalizada! Volte sempre!");
              pausar();

              print("");
              int escolhaPosVenda = lerInt(
                "1 - Realizar outro atendimento\n2 - Sair\nDigite sua opção:",
              );
              if (escolhaPosVenda == 1) {
                clienteAtivo = false;
              } else {
                clienteAtivo = false;
                sistemaRodando = false;
              }
            }
            break;

          case 6:
            clienteAtivo = false;
            break;

          case 0:
            sistemaRodando = false;
            clienteAtivo = false;
            break;

          default:
            print("Opção inválida.");
            pausar();
        }
      }
    }
  }
}
