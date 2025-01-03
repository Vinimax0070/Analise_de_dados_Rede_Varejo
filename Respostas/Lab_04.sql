CREATE SCHEMA cap17 AUTHORIZATION dsa;

-- Cria as tabelas:

CREATE TABLE cap17.clientes (
    Id_Cliente UUID PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE cap17.produtos (
    Id_Produto UUID PRIMARY KEY,
    nome VARCHAR(255),
    preco DECIMAL
);

CREATE TABLE cap17.vendas (
    Id_Vendas UUID PRIMARY KEY,
    Id_Cliente UUID REFERENCES cap17.clientes(Id_Cliente),
    Id_Produto UUID REFERENCES cap17.produtos(Id_Produto),
    Quantidade INTEGER,
    Data_Venda DATE
);


---------------------------VERIFICANDO VALORES AUSENTES-------------------------
--CLIENTES
SELECT 
    (SUM(CASE WHEN nome IS NULL THEN 1 ELSE 0 END) +
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END)) as NUMERO_TOTAL_VENDAS
FROM 
    cap17.clientes;

--PRODUTOS
SELECT 
    (SUM(CASE WHEN nome IS NULL THEN 1 ELSE 0 END) +
    SUM(CASE WHEN preco IS NULL THEN 1 ELSE 0 END)) as NUMERO_TOTAL_VENDAS
FROM 
    cap17.produtos;

--VENDAS
SELECT 
    (SUM(CASE WHEN Id_Vendas IS NULL THEN 1 ELSE 0 END) +
    SUM(CASE WHEN Id_Cliente UUID IS NULL THEN 1 ELSE 0 END)+
    SUM(CASE WHEN Id_Produto UUID IS NULL THEN 1 ELSE 0 END)+
    SUM(CASE WHEN QUANTIDADE UUID IS NULL THEN 1 ELSE 0 END)+
    SUM(CASE WHEN Data_Venda UUID IS NULL THEN 1 ELSE 0 END))
    as NUMERO_TOTAL_VENDAS
FROM 
    cap17.vendas;




--1.Qual o Número Total de Vendas e Média de Quantidade Vendida?
SELECT * FROM cap17.vendas;

SELECT 
    COUNT(*) AS NUMERO_TOTAL_VENDAS,
    AVG(Quantidade) AS MEDIA_QTD_VENDIDA
FROM cap17.vendas;

--2.Qual o Número Total de Produtos ->Únicos<- Vendidos?
SELECT * FROM cap17.produtos;


--SEPARANDO POR CATEGORIA--
SELECT 
    NOME,
    COUNT(Id_Produto) AS NUMERO_TOTAL_VENDAS
FROM cap17.produtos
GROUP BY 
    NOME;

--NUMERO BRUTO DO TOTAL DE PRODUTOS UNICOS VENDIDOS--
SELECT 
    DISTINCT(COUNT(Id_Produto)) AS NUMERO_TOTAL_VENDAS
FROM cap17.produtos;

--3.Quantas Vendas Ocorreram Por Produto? Mostre o Resultado em Ordem Decrescente--
SELECT 
    NOME,
    COUNT(Id_Produto) AS NUMERO_TOTAL_VENDAS
FROM cap17.produtos
GROUP BY 
    NOME
ORDER BY NUMERO_TOTAL_VENDAS DESC;

--4.Quais os 5 Produtos com Maior Número de Vendas?--
SELECT 
    NOME,
    COUNT(*) AS MAIORES_VENDAS
FROM 
    cap17.produtos
GROUP BY 
    NOME
ORDER BY 
    MAIORES_VENDAS DESC
LIMIT 5;

--5.Quais Clientes Fizeram 6 ou Mais Transações de Compra?--
SELECT * FROM cap17.clientes;
SELECT * FROM cap17.vendas;

SELECT 
    V.Quantidade,
    C.NOME
FROM cap17.clientes C 
LEFT JOIN cap17.vendas V ON C.Id_Cliente = V.Id_Cliente
WHERE 
    QUANTIDADE > 6


--6.Qual o Total de Transações Comerciais Por Mês no Ano de 2024?
-- Apresente os Nomes dos Meses no Resultado, Que Deve Ser Ordenado Por Mês
SELECT * FROM cap17.vendas;

SELECT 
    EXTRACT(YEAR FROM Data_Venda) AS ANO,
    CASE 
        EXTRACT(MONTH FROM Data_Venda)
            WHEN 1 THEN 'Janeiro'
            WHEN 2 THEN 'Fevereiro'
            WHEN 3 THEN 'Março'
            WHEN 4 THEN 'Abril'
            WHEN 5 THEN 'Maio'
            WHEN 6 THEN 'Junho'
            WHEN 7 THEN 'Julho'
            WHEN 8 THEN 'Agosto'
            WHEN 9 THEN 'Setembro'
            WHEN 10 THEN 'Outubro'
            WHEN 11 THEN 'Novembro'
            WHEN 12 THEN 'Dezembro'
        END AS MES,
    SUM(Quantidade) AS TRANSACOES_COMERCIAIS
FROM 
    cap17.vendas
WHERE 
    EXTRACT(YEAR FROM Data_Venda) = 2024  -- Filtra apenas o ano de 2024
GROUP BY 
    EXTRACT(YEAR FROM Data_Venda), 
    EXTRACT(MONTH FROM Data_Venda)  -- Agrupa por ano e mês
ORDER BY 
    EXTRACT(MONTH FROM Data_Venda);  -- Ordena por número do mês

--7.Quantas Vendas de Notebooks Ocorreram em Junho e Julho de 2023?
SELECT * FROM cap17.vendas;
SELECT * FROM cap17.produtos;


SELECT 
    P.NOME,
    EXTRACT(YEAR FROM V.Data_Venda) AS ANO,
    EXTRACT(MONTH FROM V.Data_Venda) AS MES,
    SUM(V.Quantidade) AS TOTAL_VENDAS  
FROM 
    cap17.produtos P  
INNER JOIN 
    cap17.vendas V ON P.Id_Produto = V.Id_Produto
WHERE 
    NOME = 'Notebook' AND
    EXTRACT(YEAR FROM V.Data_Venda) = 2023 AND
    (EXTRACT(MONTH FROM V.Data_Venda) = 6 OR EXTRACT(MONTH FROM V.Data_Venda) = 7)  -- Condição corrigida
GROUP BY 
    P.NOME,
    P.Id_Produto,  
    ANO,  
    MES 
ORDER BY 
    MES


--8.Qual o Total de Vendas Por Mês e Por Ano ao Longo do Tempo?
SELECT 
    EXTRACT(YEAR FROM V.Data_Venda) AS ANO,
    EXTRACT(MONTH FROM V.Data_Venda) AS MES,
    SUM(Quantidade) AS TOTAL_VENDAS_ANO_MES
FROM 
    cap17.vendas V
GROUP BY 
    ANO,MES
ORDER BY 
    ANO,MES

--9. Quais Produtos Tiveram Menos de 100 Transações de Venda?
SELECT
    P.Id_Produto,
    COUNT(Id_Produto) AS TOTAL_VENDAS 
FROM 
    cap17.vendas V 
INNER JOIN cap17.produtos P ON V.Id_Produto = P.Id_Produto
GROUP BY 
    P.NOME
HAVING COUNT(V.Id_Produto) < 100
ORDER BY TOTAL_VENDAS

--10. Quais Clientes Compraram Smartphone e Também Compraram Smartwatch?
SELECT 
    C.NOME,COUNT(*),
    P.NOME
FROM cap17.clientes C 
INNER JOIN cap17.vendas V ON C.Id_Cliente = V.Id_Cliente
INNER JOIN Cap17.produtos P ON V.Id_Produto = V.Id_Produto
WHERE P.NOME = 'Smartphone'OR P.NOME = 'Smartwatch'
GROUP BY
    C.NOME,
    P.NOME

WITH COMPRADORES_SMART AS (
    SELECT V.Id_Cliente
    FROM cap17.vendas V  
    JOIN cap17.produtos P ON V.Id_Produto = P.Id_Produto
    WHERE P.NOME = 'Smartphone'
    GROUP BY V.Id_Cliente
)

--11.Quais Clientes Compraram Smartphone e Smartwatch, Mas Não Compraram Notebook?
-- Clientes que compraram Smartphone
WITH clientes_smartphone AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartphone'
),
-- Clientes que compraram Smartwatch
clientes_smartwatch AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartwatch'
),
-- Clientes que compraram Notebook
clientes_notebook AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Notebook'
)
-- Clientes que compraram Smartphone e Smartwatch, mas não compraram Notebook
SELECT clientes.nome
FROM cap17.clientes
WHERE Id_Cliente IN (
    SELECT Id_Cliente FROM clientes_smartphone
    INTERSECT
    SELECT Id_Cliente FROM clientes_smartwatch
)
AND Id_Cliente NOT IN (
    SELECT Id_Cliente FROM clientes_notebook
);

--12.Quais Clientes Compraram Smartphone e Smartwatch, Mas Não Compraram Notebook em Maio/2024?
-- Clientes que compraram Smartphone em Maio/2024
WITH clientes_smartphone AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartphone'
      AND DATE_PART('year', vendas.Data_Venda) = 2024
      AND DATE_PART('month', vendas.Data_Venda) = 5
),
-- Clientes que compraram Smartwatch em Maio/2024
clientes_smartwatch AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Smartwatch'
      AND DATE_PART('year', vendas.Data_Venda) = 2024
      AND DATE_PART('month', vendas.Data_Venda) = 5
),
-- Clientes que compraram Notebook em Maio/2024
clientes_notebook AS (
    SELECT Id_Cliente
    FROM cap17.vendas
    JOIN cap17.produtos ON vendas.Id_Produto = produtos.Id_Produto
    WHERE produtos.nome = 'Notebook'
      AND DATE_PART('year', vendas.Data_Venda) = 2024
      AND DATE_PART('month', vendas.Data_Venda) = 5
)
-- Clientes que compraram Smartphone e Smartwatch, mas não Notebook em Maio/2024
SELECT cap17.clientes.nome
FROM cap17.clientes
WHERE Id_Cliente IN (
    SELECT Id_Cliente FROM clientes_smartphone
    INTERSECT
    SELECT Id_Cliente FROM clientes_smartwatch
)
AND Id_Cliente NOT IN (
    SELECT Id_Cliente FROM clientes_notebook
);
--13.Qual a Média Móvel de Quantidade de Unidades Vendidas ao Longo do Tempo? (Janela de 7 dias)
SELECT
    Data_Venda,
    Quantidade,
    ROUND(AVG(Quantidade) OVER (ORDER BY Data_Venda
                          ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 2) AS media_movel_7dias
FROM cap17.vendas
ORDER BY Data_Venda;

--14.Qual a Média Móvel e Desvio Padrão Móvel de Unidades Vendidas ao Longo do Tempo? (Janela de 7 dias)
SELECT
    Data_Venda,
    Quantidade,
    ROUND(AVG(Quantidade) OVER (ORDER BY Data_Venda
                                ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 2) AS media_movel_7dias,
    ROUND(STDDEV(Quantidade) OVER (ORDER BY Data_Venda
                                   ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), 2) AS desvio_padrao_7dias
FROM cap17.vendas
ORDER BY Data_Venda;

--15.Quais Clientes Estão Cadastrados, Mas Ainda Não Fizeram Transação?
SELECT c.Id_Cliente, c.nome
FROM cap17.clientes c
LEFT JOIN cap17.vendas v ON c.Id_Cliente = v.Id_Cliente
WHERE v.Id_Cliente IS NULL;

