# LojaTech 2026: material de estudo

Esta cópia é um gabarito de estudo, não uma entrega do grupo. A base original não deve ser modificada.

## Ordem

Execute a base original `00_base_LojaTech2026.sql` uma vez e depois os arquivos 01, 02, 03 e 04 em ordem. A parte 05 não foi solicitada nesta cópia e precisa estar implementada antes da parte 06. O arquivo 06 pressupõe as tabelas `HistoricoPrecos` e `VendasExcluidas` e as quatro triggers do enunciado. Os testes são transacionais e desfazem as alterações ao final; execute-os em uma base de testes InnoDB.

## Decisões

- Cada linha de `Vendas` é tratada como uma compra, pois a base não possui identificador de pedido. O ticket médio é o total faturado dividido pelo número de linhas de venda.
- Em 3.4, a média é a média simples dos valores unitários por linha de venda. O desconto é calculado em relação ao preço de tabela atual, que pode ser diferente do preço de tabela na data da venda.
- Os CEPs são exemplos fictícios. A classificação segue as faixas solicitadas.
- Os três testes de venda inválida são capturados para permitir que os demais continuem. Confira o SQLSTATE e a mensagem para distinguir a rejeição correta de outros erros. Para o teste de estoque, o produto 2 deve começar com 3 unidades.

## 6.2: pontos para estudo

**a)** A exclusão do cliente 1 é bloqueada pela chave estrangeira em `Vendas`, pois existem vendas que o referenciam. Alternativas incluem preservar o cadastro, anonimizar os dados quando cabível, ou planejar exclusão e tratamento das vendas com políticas adequadas; cascata excluiria vendas e deve ser avaliada com cuidado.

**b)** `TRUNCATE` remove todas as linhas e, no MySQL, não aciona triggers `DELETE`; portanto, não preserva o log nem devolve o estoque. Também implica commit e reinicia o contador de auto incremento.

**c)** `BEFORE INSERT` valida ou preenche valores antes da gravação; `AFTER INSERT` baixa o estoque depois de uma inserção bem-sucedida, na mesma transação com InnoDB. Um `UPDATE` que altere quantidade ou produto de uma venda deixa o estoque incorreto se não houver regra correspondente. A concorrência entre vendas também exige controle de bloqueio adequado.

## Pendências

- Implementar e testar a parte 05 antes de executar 06.
- Testar no MySQL 8/Workbench e capturar evidências reais; nenhuma imagem foi gerada.
- A autoria, a divisão de tarefas e os commits devem refletir a contribuição real de cada integrante.
