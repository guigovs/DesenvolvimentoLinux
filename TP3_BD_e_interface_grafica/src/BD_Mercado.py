import sqlite3

def criar_conexao(nome_banco="mercado.db"):
    return sqlite3.connect(nome_banco)

def criar_tabelas(con):
    cur = con.cursor()

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Produto (
        ID_Produto INTEGER PRIMARY KEY AUTOINCREMENT,
        Nome_Produto VARCHAR(30) NOT NULL,
        Tipo_Produto VARCHAR(25) NOT NULL,
        Preco DECIMAL(10,2) NOT NULL,
        Qtde_Estoque SMALLINT NOT NULL
        );
    ''')

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Venda (
        ID_Venda INTEGER PRIMARY KEY AUTOINCREMENT,
        Nota_Fiscal SMALLINT NOT NULL,
        Data_Compra DATETIME DEFAULT CURRENT_TIMESTAMP,
        ID_Produto INTEGER NOT NULL,
        Quantidade SMALLINT NOT NULL,
        FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
        );
    ''')

    con.commit()
