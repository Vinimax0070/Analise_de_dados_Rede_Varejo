# 📂 Dados de Amostra - `sample/`

Esta pasta contém os dados utilizados no projeto de análise de dados de uma rede de varejo. O banco de dados utilizado para este projeto foi o **PostgreSQL**, executado dentro de um container **Docker**.

## 🗂️ Conteúdo da Pasta

### 1. **`clientes.csv`**  
Este arquivo contém informações sobre os clientes da rede de varejo.  
**Colunas:**
- **Id_Cliente**: Identificador único do cliente.
- **nome**: Nome do cliente.
- **email**: Endereço de e-mail do cliente.

### 2. **`produtos.csv`**  
Este arquivo contém informações sobre os produtos disponíveis para venda na rede de varejo.  
**Colunas:**
- **Id_Produto**: Identificador único do produto.
- **nome**: Nome do produto.
- **preco**: Preço de venda do produto.

### 3. **`vendas.csv`**  
Este arquivo contém informações sobre as vendas realizadas pela rede de varejo.  
**Colunas:**
- **Id_Vendas**: Identificador único da venda.
- **Id_Cliente**: Identificador do cliente que realizou a compra (relacionado à tabela `clientes`).
- **Id_Produto**: Identificador do produto comprado (relacionado à tabela `produtos`).
- **Quantidade**: Quantidade de unidades do produto compradas.
- **Data_Venda**: Data da venda realizada.

---

## 🐳 Banco de Dados: PostgreSQL no Docker

Para executar o projeto e as consultas SQL, você pode utilizar um container Docker com o banco de dados **PostgreSQL**. Aqui está como você pode configurar o ambiente.

### 🚀 Passos para Configurar o Docker com PostgreSQL

1. **Baixe a imagem do PostgreSQL**:

   Se você não tiver o PostgreSQL já configurado, execute o comando abaixo para baixar a imagem oficial:

   ```bash
   docker pull postgres:latest
   
2. **Inicie o container do PostgreSQL**:
   ```bash
    docker run --name meu_postgres -e POSTGRES_PASSWORD=minhasenha -d -p 5432:5432 postgres:latest

3. **Acesse o PostgreSQL**:
   ```bash
    docker exec -it meu_postgres psql -U postgres

4. **Criar o Banco de Dados e Importar os Dados:**
- Após acessar o PostgreSQL, crie o banco de dados e as tabelas utilizando os arquivos SQL de criação de tabelas e dados. Para isso, siga os passos abaixo:
  ```bash
  CREATE DATABASE varejo;
  \c varejo
  -- Execute os scripts para criar as tabelas e inserir os dados.

## 📌 Como Utilizar

- Para usar os dados no seu ambiente local, basta importar os arquivos CSV para o banco PostgreSQL dentro do seu container Docker. O processo de importação pode ser feito via comandos SQL ou utilizando um script Python.

- Exemplo para Importar os Dados no PostgreSQL:

- Aqui está um exemplo básico para importar os arquivos CSV diretamente no PostgreSQL:

 ```bash
    COPY clientes(Id_Cliente, nome, email)
    FROM '/caminho/para/clientes.csv'
    DELIMITER ','
    CSV HEADER;
    
    COPY produtos(Id_Produto, nome, preco)
    FROM '/caminho/para/produtos.csv'
    DELIMITER ','
    CSV HEADER;
    
    COPY vendas(Id_Vendas, Id_Cliente, Id_Produto, Quantidade, Data_Venda)
    FROM '/caminho/para/vendas.csv'
    DELIMITER ','
    CSV HEADER;
