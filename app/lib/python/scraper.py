import requests
from bs4 import BeautifulSoup

def dist_servico(codigo, ano):
    URL = "https://sigarra.up.pt/feup/pt/ds_func_relatorios.querylist?pv_doc_codigo="+str(codigo)+"&pv_outras_inst=S&pv_ano_lectivo="+str(ano)
    page = requests.get(URL)

    soup = BeautifulSoup(page.content, "html.parser")
    table = soup.find(id="conteudoinner")
    table = table.find("table")
    rows = table.find_all("tr")

    rows = rows[1:-3]

    ids = []

    for row in rows:
        a = str(row.find("a"))
        id = int(a[52:58])
        if id not in ids:
            ids.append(id)
    
    return ids

ids = dist_servico(211636, 2022)

for id in ids:
    print(id)
