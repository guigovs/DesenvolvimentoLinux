from tkinter import Tk, Label, Entry, Button, Listbox, END, messagebox
from tkinter.ttk import Notebook, Frame
from src.BD_Mercado import criar_conexao, criar_tabelas
from src.Produto_Operacoes_CRUD import adicionar_produto, listar_produtos, atualizar_produto, deletar_produto
from src.Venda_Operacoes_CRUD import adicionar_venda, listar_vendas, deletar_venda


# Função responsável por carregar os produtos no Listbox
def carregar_produtos():
    listbox_produtos.delete(0, END)
    produtos = listar_produtos(con)
    for produto in produtos:
        listbox_produtos.insert(END, f"ID: {produto[0]} - {produto[1]} | Tipo: {produto[2]} | Preço: {produto[3]} | Estoque: {produto[4]}")

# Função para adicionar um produto na interface e no banco de dados
def adicionar_produto_interface():
    nome = entry_nome_produto.get()
    tipo = entry_tipo_produto.get()
    try:
        preco = float(entry_preco_produto.get())
        estoque = int(entry_estoque_produto.get())
    except ValueError:
        messagebox.showerror("Erro", "Preço e Estoque devem ser numéricos!")
        return

    if nome and tipo and preco >= 0 and estoque >= 0:
        adicionar_produto(con, nome, tipo, preco, estoque)
        carregar_produtos()
        entry_nome_produto.delete(0, END)
        entry_tipo_produto.delete(0, END)
        entry_preco_produto.delete(0, END)
        entry_estoque_produto.delete(0, END)
        messagebox.showinfo("Sucesso", "Produto adicionado com sucesso!")
    else:
        messagebox.showerror("Erro", "Preencha todos os campos corretamente!")

# Função para atualizar um produto selecionado
def atualizar_produto_interface():
    try:
        produto_selecionado = listbox_produtos.get(listbox_produtos.curselection())
        id_produto = int(produto_selecionado.split(" ")[1])
    except IndexError:
        messagebox.showerror("Erro", "Selecione um produto para atualizar!")
        return

    nome = entry_nome_produto.get() or None
    tipo = entry_tipo_produto.get() or None
    preco = entry_preco_produto.get()
    estoque = entry_estoque_produto.get()

    preco = float(preco) if preco else None
    estoque = int(estoque) if estoque else None

    atualizar_produto(con, id_produto, nome, tipo, preco, estoque)
    carregar_produtos()
    entry_nome_produto.delete(0, END)
    entry_tipo_produto.delete(0, END)
    entry_preco_produto.delete(0, END)
    entry_estoque_produto.delete(0, END)
    messagebox.showinfo("Sucesso", "Produto atualizado com sucesso!")

# Função para deletar um produto selecionado
def deletar_produto_interface():
    try:
        produto_selecionado = listbox_produtos.get(listbox_produtos.curselection())
        id_produto = int(produto_selecionado.split(" ")[1])
    except IndexError:
        messagebox.showerror("Erro", "Selecione um produto!")
        return

    deletar_produto(con, id_produto)
    carregar_produtos()
    messagebox.showinfo("Sucesso", "Produto deletado com sucesso!")


# Função responsável por carregar as vendas no Listbox
def carregar_vendas():
    listbox_vendas.delete(0, END)
    vendas = listar_vendas(con)
    for venda in vendas:
        listbox_vendas.insert(
            END,
            f"ID: {venda[0]} | Produto: {venda[1]} | Tipo: {venda[2]} | Data: {venda[3]} | Nota Fiscal: {venda[4]} | Quantidade: {venda[5]}"
        )

# Função para adicionar uma venda na interface e no banco de dados
def adicionar_venda_interface():
    try:
        id_produto = int(entry_id_produto_venda.get())
        nota_fiscal = int(entry_nota_fiscal_venda.get())
        quantidade = int(entry_quantidade_venda.get())
    except ValueError:
        messagebox.showerror("Erro", "ID do Produto, Nota Fiscal e Quantidade devem ser numéricos!")
        return

    if id_produto and nota_fiscal and quantidade > 0:
        try:
            adicionar_venda(con, id_produto, nota_fiscal, quantidade)
            carregar_vendas()
            entry_id_produto_venda.delete(0, END)
            entry_nota_fiscal_venda.delete(0, END)
            entry_quantidade_venda.delete(0, END)
            messagebox.showinfo("Sucesso", "Venda registrada com sucesso!")
        except ValueError as e:
            messagebox.showerror("Erro", str(e))
    else:
        messagebox.showerror("Erro", "Preencha todos os campos corretamente!")

# Função para deletar uma venda selecionada
def deletar_venda_interface():
    try:
        venda_selecionada = listbox_vendas.get(listbox_vendas.curselection())
        id_venda = int(venda_selecionada.split(" ")[1])
    except IndexError:
        messagebox.showerror("Erro", "Selecione uma venda!")
        return

    deletar_venda(con, id_venda)
    carregar_vendas()
    messagebox.showinfo("Sucesso", "Venda deletada com sucesso!")


if __name__ == "__main__":
    # Inicializa a conexão com o banco de dados e cria as tabelas necessárias
    con = criar_conexao()
    criar_tabelas(con)

    # Cria a janela principal da aplicação
    janela = Tk()
    janela.title("Gerenciamento de Produtos e Vendas")
    janela.geometry("600x450")

    # Cria um Notebook (abas) para organizar a interface
    notebook = Notebook(janela)
    notebook.pack(expand=True, fill="both")

    # Aba de Produtos
    aba_produtos = Frame(notebook)
    notebook.add(aba_produtos, text="Produtos")

    Label(aba_produtos, text="Nome:").grid(row=0, column=0, padx=5, pady=5)
    entry_nome_produto = Entry(aba_produtos)
    entry_nome_produto.grid(row=0, column=1, padx=5, pady=5)

    Label(aba_produtos, text="Tipo:").grid(row=1, column=0, padx=5, pady=5)
    entry_tipo_produto = Entry(aba_produtos)
    entry_tipo_produto.grid(row=1, column=1, padx=5, pady=5)

    Label(aba_produtos, text="Preço:").grid(row=2, column=0, padx=5, pady=5)
    entry_preco_produto = Entry(aba_produtos)
    entry_preco_produto.grid(row=2, column=1, padx=5, pady=5)

    Label(aba_produtos, text="Estoque:").grid(row=3, column=0, padx=5, pady=5)
    entry_estoque_produto = Entry(aba_produtos)
    entry_estoque_produto.grid(row=3, column=1, padx=5, pady=5)

    Button(aba_produtos, text="Adicionar Produto", command=adicionar_produto_interface).grid(row=4, column=0, padx=5, pady=5)
    Button(aba_produtos, text="Atualizar Produto", command=atualizar_produto_interface).grid(row=4, column=1, padx=5, pady=5)
    Button(aba_produtos, text="Deletar Produto", command=deletar_produto_interface).grid(row=4, column=2, padx=5, pady=5)

    listbox_produtos = Listbox(aba_produtos, width=90, height=15)
    listbox_produtos.grid(row=5, column=0, columnspan=3, padx=5, pady=5)

    carregar_produtos()

    # Aba de Vendas
    aba_vendas = Frame(notebook)
    notebook.add(aba_vendas, text="Vendas")

    Label(aba_vendas, text="ID do Produto:").grid(row=0, column=0, padx=5, pady=5)
    entry_id_produto_venda = Entry(aba_vendas)
    entry_id_produto_venda.grid(row=0, column=1, padx=5, pady=5)

    Label(aba_vendas, text="Nota Fiscal:").grid(row=1, column=0, padx=5, pady=5)
    entry_nota_fiscal_venda = Entry(aba_vendas)
    entry_nota_fiscal_venda.grid(row=1, column=1, padx=5, pady=5)

    Label(aba_vendas, text="Quantidade:").grid(row=2, column=0, padx=5, pady=5)
    entry_quantidade_venda = Entry(aba_vendas)
    entry_quantidade_venda.grid(row=2, column=1, padx=5, pady=5)

    Button(aba_vendas, text="Adicionar Venda", command=adicionar_venda_interface).grid(row=3, column=0, padx=5, pady=5)
    Button(aba_vendas, text="Deletar Venda", command=deletar_venda_interface).grid(row=3, column=1, padx=5, pady=5)

    listbox_vendas = Listbox(aba_vendas, width=90, height=15)
    listbox_vendas.grid(row=4, column=0, columnspan=3, padx=5, pady=5)

    carregar_vendas()

    janela.mainloop()
