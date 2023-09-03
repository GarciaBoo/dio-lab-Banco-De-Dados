# dio-lab-Banco-De-Dados
# Modelo Lógico de Banco de Dados para E-commerce

Este projeto consiste na modelagem do banco de dados para um cenário de e-commerce, considerando as relações entre as entidades e as chaves primárias e estrangeiras necessárias. Além disso, inclui a criação de queries SQL que abordam diversos aspectos do sistema de e-commerce.

## Descrição do Desafio

O objetivo deste projeto é replicar a modelagem do banco de dados para um cenário de e-commerce, considerando as seguintes diretrizes:

1. Modelagem de Cliente PJ e PF: Uma conta pode ser Pessoa Jurídica (PJ) ou Pessoa Física (PF), mas não pode ter ambas as informações.
2. Modelagem de Pagamento: Um cliente pode ter cadastrado mais de uma forma de pagamento.
3. Modelagem de Entrega: A entidade "Entrega" possui status e código de rastreio.

## Estrutura do Banco de Dados

O banco de dados é composto por várias tabelas que representam diferentes aspectos do sistema de e-commerce. Aqui estão algumas das principais entidades e suas relações:

- **Cliente**: Armazena informações sobre os clientes, que podem ser PJ ou PF.
- **Conta**: Uma conta está associada a um cliente e representa a conta do cliente no sistema.
- **Pedido**: Representa um pedido feito por um cliente, contendo informações sobre os produtos, pagamento e entrega.
- **Produto**: Contém informações sobre os produtos disponíveis para compra.
- **Fornecedor**: Representa os fornecedores dos produtos.
- **Estoque**: Registra as quantidades de produtos disponíveis em estoque.
- **Pagamento**: Armazena informações sobre as formas de pagamento cadastradas pelos clientes.
- **Entrega**: Contém informações sobre as entregas, incluindo status e código de rastreio.

## Queries SQL

Aqui estão algumas queries SQL que podem ser aplicadas a este banco de dados:

1. **Quantidade de Pedidos por Cliente**:
   
   ```sql
   SELECT Cliente.Nome, COUNT(Pedido.ID) AS TotalPedidos
   FROM Cliente
   LEFT JOIN Pedido ON Cliente.ID = Pedido.ClienteID
   GROUP BY Cliente.Nome;

2. **Algum vendedor também é fornecedor**?
    ```sql
    SELECT S.idSeller, S.SocialName
    FROM seller S
    INNER JOIN supplier SUP ON S.CNPJ = SUP.CNPJ;

3. **Relação de produtos fornecedores e estoques**
    ```sql
    SELECT P.Pname, SUP.SocialName, PS.quantity AS Estoque
    FROM product P
    INNER JOIN productSupplier PS ON P.idProduct = PS.idPsProduct
    INNER JOIN supplier SUP ON PS.idPsSupplier = SUP.idSupplier;

4. **Relação de nomes dos fornecedores e nomes dos produtos**
    ```sql
    SELECT SUP.SocialName AS Fornecedor, P.Pname AS Produto
    FROM supplier SUP
    INNER JOIN productSupplier PS ON SUP.idSupplier = PS.idPsSupplier
    INNER JOIN product P ON PS.idPsProduct = P.idProduct;

5. **Pedidos com Status de Entrega:**
    ```sql
    SELECT O.idOrder, O.orderStatus, D.Status AS StatusEntrega, D.TrackingCode
    FROM orders O
    LEFT JOIN Delivery D ON O.idOrder = D.idOrder;
