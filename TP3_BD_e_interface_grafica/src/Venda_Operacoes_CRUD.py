from datetime import datetime, timezone, timedelta

def obter_horario_local():
    # Define o fuso horário como UTC-3
    fuso_horario = timezone(timedelta(hours=-3))
    horario_atual = datetime.now(fuso_horario)
    # Formata para armazenar apenas até os segundos
    return horario_atual.strftime("%d-%m-%Y %H:%M:%S")

def adicionar_venda(con, id_produto, nota_fiscal, quantidade):
    cur = con.cursor()
    # Verifica se há estoque suficiente
    cur.execute('SELECT Qtde_Estoque FROM Produto WHERE ID_Produto = ?', (id_produto,))
    estoque_atual = cur.fetchone()
    
    if estoque_atual is None:
        raise ValueError("Produto não encontrado.")
    
    if estoque_atual[0] < quantidade:
        raise ValueError("Estoque insuficiente para a venda.")
    
    # Insere a venda
    data_compra = obter_horario_local()
    cur.execute('''
    INSERT INTO Venda (Nota_Fiscal, Data_Compra, ID_Produto, Quantidade)
    VALUES (?, ?, ?, ?)
    ''', (nota_fiscal, data_compra, id_produto, quantidade))

    
    # Atualiza o estoque
    novo_estoque = estoque_atual[0] - quantidade
    cur.execute('UPDATE Produto SET Qtde_Estoque = ? WHERE ID_Produto = ?', (novo_estoque, id_produto))
    con.commit()

def listar_vendas(con):
    cur = con.cursor()
    cur.execute('''
        SELECT Venda.ID_Venda, Produto.Nome_Produto, Produto.Tipo_Produto, Venda.Data_Compra, Venda.Nota_Fiscal, Venda.Quantidade
        FROM Venda
        JOIN Produto ON Venda.ID_Produto = Produto.ID_Produto
    ''')
    return cur.fetchall()

def deletar_venda(con, id_venda):
    cur = con.cursor()
    # Recupera a quantidade e o produto associado
    cur.execute('SELECT ID_Produto, Quantidade FROM Venda WHERE ID_Venda = ?', (id_venda,))
    venda = cur.fetchone()
    
    if venda is None:
        raise ValueError("Venda não encontrada.")
    
    id_produto, quantidade = venda
    
    # Atualiza o estoque ao excluir a venda
    cur.execute('UPDATE Produto SET Qtde_Estoque = Qtde_Estoque + ? WHERE ID_Produto = ?', (quantidade, id_produto))
    
    # Remove a venda
    cur.execute('DELETE FROM Venda WHERE ID_Venda = ?', (id_venda,))
    con.commit()
