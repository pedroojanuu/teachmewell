import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

Future<List<int>> dist_servico(int codigo, int ano) async {
  String URL = "https://sigarra.up.pt/feup/pt/ds_func_relatorios.querylist?pv_doc_codigo="+codigo.toString()+"&pv_outras_inst=S&pv_ano_lectivo="+ano.toString();
  http.Response page = await http.get(Uri.parse(URL));

  Document soup = parser.parse(page.body);
  Element table = soup.getElementById("conteudoinner");
  table = table.getElementsByTagName("table")[0];
  List<Element> rows = table.getElementsByTagName("tr");

  rows = rows.sublist(1, rows.length-3);

  List<int> ids = [];

  for (Element row in rows) {
    String a = row.getElementsByTagName("a")[0].outerHtml;
    int id = int.parse(a.substring(52, 58));
    if (!ids.contains(id)) {
      ids.add(id);
    }
  }
  return ids;
}

Future<void> main() async {
  List<int> ids = await dist_servico(211636, 2022);

  for (int id in ids) {
    print(id);
  }
}
