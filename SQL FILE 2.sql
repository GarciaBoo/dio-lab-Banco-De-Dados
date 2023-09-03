-- criar tabela cliente
create table clients(
    idClient int IDENTITY(1,1) primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(30),
    Tipo varchar(2) not null, -- Adicionado campo para indicar PJ ou PF
    constraint unique_cpf unique (CPF)
);

-- criar tabela ClientePJ
create table ClientePJ(
    idClientePJ int primary key,
    RazaoSocial varchar(255) not null,
    CNPJ char(14) not null,
    constraint unique_cnpj_pj unique (CNPJ),
    constraint fk_cliente_pj foreign key (idClientePJ) references clients(idClient)
);

-- criar tabela ClientePF
create table ClientePF(
    idClientePF int primary key,
    NomeCompleto varchar(255) not null,
    RG char(12) not null,
    constraint unique_rg_pf unique (RG),
    constraint fk_cliente_pf foreign key (idClientePF) references clients(idClient)
);

-- criar tabela product
-- size quivale a dimensão do produto
create table product(
    idProduct int IDENTITY(1,1) primary key,
    Pname varchar(10) not null,
    classification_kids BIT default 0,
    category VARCHAR(20) NOT NULL,
    avaliação float default 0,
    size varchar(10),
);

ALTER TABLE product
ADD CONSTRAINT CHK_Category
CHECK (category IN ('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Moveis'));
-- Para inserir dados na coluna 'category', você pode usar um dos valores permitidos, por exemplo:
-- INSERIR NO produto (Pname, classification_kids, category, avaliacao, size)
-- VALORES ('Produto1', 1, 'Eletronico', 4.5, 'Grande');clients

--CONTINUAdo NO DESAFIO - finalizar implementação e criar conexão com as tabelas nescessárias
--criado constrains relacionadas ao pagamento
create table payment(
    idPayment INT IDENTITY(1,1) PRIMARY KEY,
    idClient INT,
    typePayment VARCHAR(20),
    limiteAvaliable FLOAT,
    CONSTRAINT FK_Payment_Client FOREIGN KEY (idClient) REFERENCES clients (idClient)
);

-- criar tabela CustomerPayment para modelagem de Pagamento
create table CustomerPayment (
    idCustomerPayment INT IDENTITY(1,1) PRIMARY KEY,
    idClient INT,
    idPaymentMethod INT,
    CONSTRAINT FK_CustomerPayment_Client FOREIGN KEY (idClient) REFERENCES clients(idClient),
    CONSTRAINT FK_CustomerPayment_PaymentMethod FOREIGN KEY (idPaymentMethod) REFERENCES payment(idPayment)
);

-- criar tabela pedido
CREATE TABLE orders (
    idOrder INT IDENTITY(1,1) PRIMARY KEY,
    idOrderClient INT,
    orderStatus VARCHAR(20) DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BIT DEFAULT 0,
    CONSTRAINT FK_Order_Client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient) ON UPDATE CASCADE ON DELETE SET NULL
);

-- Add a constraint to ensure that the 'orderStatus' column only accepts specific values
ALTER TABLE orders
ADD CONSTRAINT CHK_OrderStatus
CHECK (orderStatus IN ('Cancelado', 'Confirmado', 'Em processamento'));
-- Para inserir dados na coluna 'orderStatus', você pode usar um dos valores permitidos, por exemplo:
-- INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
-- VALUES (1, 'Confirmado', 'Pedido 1 foi confirmado', 20.5, 1);

-- criar tabela estoque
CREATE TABLE productStorage (
    idproductStorage INT IDENTITY(1,1) PRIMARY KEY,
    storegeLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- criar tabela fornecedor
CREATE TABLE supplier (
    idSupplier INT IDENTITY(1,1) PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);


-- criar tabela vendedor
create table seller(
    idSeller int IDENTITY(1,1) primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null ,
    constraint unique_supplier_cnpf_seller unique (CNPJ),
    constraint unique_supplier_cpf_seller unique (CPF)
);

create table productSeller(
    idPseller int,
    idPproduct int,
    prodQuantity int not null default 1,
    primary key (idPseller,idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

-- criar tabela productOrder
CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
   	poQuantity int default 1,
    poStatus VARCHAR(20) DEFAULT 'Disponivel',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT FK_ProductOrder_Product FOREIGN KEY (idPOproduct) REFERENCES product (idProduct),
    CONSTRAINT FK_ProductOrder_Order FOREIGN KEY (idPOorder) REFERENCES orders (idOrder),
    CONSTRAINT CHK_PosStatus CHECK (poStatus IN ('Disponivel', 'Sem estoque'))
);

-- A coluna 'posStatus' é do tipo VARCHAR e permite apenas os valores 'Disponivel' ou 'Sem estoque'.
-- A CONSTRAINT CHK_PosStatus garante que apenas esses valores sejam inseridos.
-- Para inserir dados na coluna 'posStatus', você pode usar um dos valores permitidos, por exemplo:
-- INSERT INTO productOrder (idPOproduct, idPOorder, posStatus)
-- VALUES (1, 2, 'Disponivel');


 CREATE TABLE storageLocation(
    idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idproductStorage)
);

CREATe TABLE productSupplier(
    idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
)

-- Descrição da tabela Delivery: Armazena informações de entrega.
CREATE TABLE Delivery (
    idDelivery INT IDENTITY(1,1) PRIMARY KEY,
    idOrder INT,
    Status VARCHAR(20) DEFAULT 'Em andamento',
    TrackingCode VARCHAR(255),
    CONSTRAINT FK_Delivery_Order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- A coluna 'Status' é do tipo VARCHAR e permite apenas os valores 'Em andamento' ou 'Concluída'.
-- A CONSTRAINT CHK_DeliveryStatus garante que apenas esses valores sejam inseridos.
-- Para inserir dados na coluna 'Status', você pode usar um dos valores permitidos, por exemplo:
-- INSERT INTO Delivery (idOrder, Status, TrackingCode)
-- VALUES (1, 'Concluída', 'ABC123');

-- Inserir clientes
INSERT INTO clients (Fname, Minit, Lname, CPF, Address, Tipo) VALUES ('João', 'A', 'Silva', '12345678901', 'Rua das Flores, 123', 'PF');
DELETE FROM clients WHERE Fname = 'João';

-- Inserir um cliente pessoa jurídica (PJ)
INSERT INTO ClientePJ (RazaoSocial, CNPJ, idClientePJ)
VALUES ('Nome Empresa PJ', '12345678901234', (SELECT idClient FROM clients WHERE CPF = '12345678901'));

-- Inserir um cliente pessoa física (PF)
INSERT INTO ClientePF (NomeCompleto, RG, idClientePF)
VALUES ('Nome Completo PF', '12345678901', (SELECT idClient FROM clients WHERE CPF = '12345678901'));

-- Inserir um produto
INSERT INTO product (Pname, classification_kids, category, avaliação, size)
VALUES ('Produto1', 1, 'Eletronico', 4.5, 'Grande');

-- Inserir um vendedor
INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact)
VALUES ('Vendedor1', 'AbstName1', '12345678901', '123456789', 'Localização Vendedor', '1234567890');

-- Associar um produto a um vendedor
INSERT INTO productSeller (idPseller, idPproduct, prodQuantity)
VALUES ((SELECT idSeller FROM seller WHERE SocialName = 'Vendedor1'), (SELECT idProduct FROM product WHERE Pname = 'Produto1'), 10);

-- Inserir um local de armazenamento
INSERT INTO productStorage (storegeLocation, quantity)
VALUES ('Local de Armazenamento 1', 100);



-- Exemplos de consultas SQL

-- Quantos pedidos foram feitos por cada cliente?
SELECT C.idClient, C.Fname, COUNT(O.idOrder) AS TotalPedidos
FROM clients C
LEFT JOIN orders O ON C.idClient = O.idOrderClient
GROUP BY C.idClient, C.Fname;

-- Algum vendedor também é fornecedor?
SELECT S.idSeller, S.SocialName
FROM seller S
INNER JOIN supplier SUP ON S.CNPJ = SUP.CNPJ;

-- Relação de produtos fornecedores e estoques
SELECT P.Pname, SUP.SocialName, PS.quantity AS Estoque
FROM product P
INNER JOIN productSupplier PS ON P.idProduct = PS.idPsProduct
INNER JOIN supplier SUP ON PS.idPsSupplier = SUP.idSupplier;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT SUP.SocialName AS Fornecedor, P.Pname AS Produto
FROM supplier SUP
INNER JOIN productSupplier PS ON SUP.idSupplier = PS.idPsSupplier
INNER JOIN product P ON PS.idPsProduct = P.idProduct;

-- Pedidos com Status de Entrega:
SELECT O.idOrder, O.orderStatus, D.Status AS StatusEntrega, D.TrackingCode
FROM orders O
LEFT JOIN Delivery D ON O.idOrder = D.idOrder;