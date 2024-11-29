def adicionar_produto(con, nome, tipo, preco, qtde_estoque):
    cur = con.cursor()
    cur.execute('''
        INSERT INTO Produto (Nome_Produto, Tipo_Produto, Preco, Qtde_Estoque)
        VALUES (?, ?, ?, ?)
    ''', (nome, tipo, preco, qtde_estoque))
    con.commit()

def listar_produtos(con):
    cur = con.cursor()
    cur.execute('SELECT * FROM Produto')
    return cur.fetchall()

def atualizar_produto(con, id_produto, nome=None, tipo=None, preco=None, qtde_estoque=None):
    cur = con.cursor()
    query = '''
        UPDATE Produto
        SET Nome_Produto = COALESCE(?, Nome_Produto),
            Tipo_Produto = COALESCE(?, Tipo_Produto),
            Preco = COALESCE(?, Preco),
            Qtde_Estoque = COALESCE(?, Qtde_Estoque)
        WHERE ID_Produto = ?
    '''
    cur.execute(query, (nome, tipo, preco, qtde_estoque, id_produto))
    con.commit()

def deletar_produto(con, id_produto):
    cur = con.cursor()
    cur.execute('DELETE FROM Produto WHERE ID_Produto = ?', (id_produto,))
    con.commit()
