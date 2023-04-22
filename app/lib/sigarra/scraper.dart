import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

fakeMain() async {
  // print('\n');
  // print(await getTeacherUCs("feup", 211636, 2022));
  // print('\n');
  // print(await getUCInfo('feup', 501680));
  // populateFCUPTeachers();
  // populateFCNAUPTeachers();
  // populateFADEUPTeachers();
  // populateFDUPTeachers();
  // populateFEPTeachers();
  // populateFEUPTeachers();
  // populateFLUPTeachers();
  // populateFMUPTeachers();
  // populateFPCEUPTeachers();
  // populateICBASTeachers();
}

Future<void> fakeMain2() async{
  print("Started fakeMain2");
  List<int> t = await getCourseUCsIDs("fcup", 13221, 2022);
  for(int i in t){
    print(i);
  }
  print("Ended fakeMain2");
}

String removeDiacritics(String str) {
  var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }
  return str;
}

bool isInList(List<int> l, int n) {
  for (int i in l) {
    if (i == n) {return true;}
  }
  return false;
}

Future<List<int>> getTeacherUCsIDs(String faculty, int teacher, int year) async {
  final response = await http.Client().get(Uri.parse('https://sigarra.up.pt/$faculty/pt/ds_func_relatorios.querylist?pv_doc_codigo=$teacher&pv_outras_inst=S&pv_ano_lectivo=$year'));
  String body = response.body;

  BeautifulSoup soup = BeautifulSoup(body);

  var table = soup.find('*', id: 'conteudoinner');
  table = table!.find('table');
  var rows = table!.findAll('tr');
  rows = rows.sublist(1, rows.length-3);

  List<int> ids = [];

  for (Bs4Element row in rows) {
    var a = row.find('a');
    String s = a.toString();
    s = s.substring(52, 58);
    int i = int.parse(s);
    if (!isInList(ids, i)) {
      ids.add(i);
    }
  }

  return ids;
}

Future<Set<int>> getUCsTeachersIDs(String faculty, int uc_id) async {
  Set<int> teachers = {};

    final response = await http.Client().get(Uri.parse(
        'https://sigarra.up.pt/$faculty/pt/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=$uc_id'));
    String body = response.body;

    BeautifulSoup soup = BeautifulSoup(body);

    var tables = soup.findAll('table', class_: 'dados');
    var table = null;
    for(var t in tables){
      if(t.toString().contains("Turmas")){
        table = t;
        break;
      }
    }
    if(table == null)
      return {};
    var rows = table!.findAll('td', class_:"t");

    for (var row in rows) {
      var a = row.find('a');
      var a_string = a.toString();
      if (a != null && a_string.substring(29, 37) == "p_codigo")
        teachers.add(int.parse(a_string.substring(38, 44)));
    }

  return teachers;
}

Future<List<int>> getCourseUCsIDs(String faculty, int curso, int ano_letivo) async {
  final response = await http.Client().get(Uri.parse('https://sigarra.up.pt/$faculty/pt/cur_geral.cur_planos_estudos_view?pv_plano_id=$curso&pv_ano_lectivo=$ano_letivo'));
  String body = response.body;

  BeautifulSoup soup = BeautifulSoup(body);

  var table = soup.find('*', id: 'conteudoinner');
  var as = table!.findAll('a');
  // table = table!.find('table');
  // var rows = table!.findAll('tr');
  // rows = rows.sublist(1, rows.length-3);

  List<int> ids = [];

  for (var a in as) {
    // var a = row.find('a');
    String s = a.toString();
    if(s.substring(9, 14) == "ucurr"){
      // print(s.substring(52, 58));
      try {
        int i = int.parse(s.substring(52, 58));
        // print(i);
        ids.add(i);
      } catch (e) {
        continue;
      }
      // if (!isInList(ids, i)) {
      //   print(i);
      //   // ids.add(i);
      // }
    }
    // s = s.substring(52, 58);
    // int i = int.parse(s);
    // if (!isInList(ids, i)) {
    //   ids.add(i);
    // }
  }

  return ids;
}

class UC {
  String nome;
  int codigo;
  String acronimo;

  UC(this.nome, this.codigo, this.acronimo);
}

Future<UC> getUCInfo(String faculty, int id) async {
  final response = await http.Client().get(Uri.parse('https://sigarra.up.pt/$faculty/pt/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=$id'));
  String body = response.body;

  BeautifulSoup soup = BeautifulSoup(body);

  var content = soup.find('*', id: 'conteudoinner');
  var h1 = content!.findAll('h1');
  var table = soup.find('*', class_: 'formulario');
  var td = table!.findAll('td');

  String nome = h1[1].toString();
  nome = nome.substring(4, (nome.length) - 5);

  String codigo = td[1].toString();
  codigo = codigo.substring(4, (codigo.length) - 5);

  String acronimo = td[4].toString();
  acronimo = acronimo.substring(4, (acronimo.length) - 5);

  return UC(nome, int.parse(codigo), acronimo);
}

Future<List<int>> getFacultyBachelorsIDs(String faculty) async {
  final response = await http.Client().get(Uri.parse('https://www.up.pt/portal/pt/estudar/licenciaturas-e-mestrados-integrados/oferta-formativa/'));
  String body = response.body;

  BeautifulSoup soup = BeautifulSoup(body);

  var dl = soup.find('*', id: 'facultyList');
  var as = dl!.findAll('a');

  List<int> ids = [];

  for (var a in as) {
    String href = a['href'].toString();
    //print(a.toString());
    String f = href.substring(73, 73 + (faculty.length));
    //print("f: " + f);
    //print(f == faculty);
    String id = href.substring(74 + (faculty.length), (href.length) - 1);
    //print("id: " + id);
    if (f == faculty) {
      ids.add(int.parse(id));
    }
  }

  return ids;
}

Future<List<int>> getFacultyMastersIDs(String faculty) async {
  final response = await http.Client().get(Uri.parse('https://www.up.pt/portal/pt/estudar/mestrados/oferta-formativa/'));
  String body = response.body;

  BeautifulSoup soup = BeautifulSoup(body);

  var dl = soup.find('*', id: 'facultyList');
  var as = dl!.findAll('a');

  List<int> ids = [];

  for (var a in as) {
    String href = a['href'].toString();
    //print(a.toString());
    String f = href.substring(46, 46 + (faculty.length));
    //print("f: " + f);
    //print(f == faculty);
    String id = href.substring(47 + (faculty.length), (href.length) - 1);
    //print("id: " + id);
    if (f == faculty) {
      ids.add(int.parse(id));
    }
  }

  return ids;
}

Future<List<int>> getFacultyPhDsIDs(String faculty) async {
  final response = await http.Client().get(Uri.parse('https://www.up.pt/portal/pt/estudar/doutoramentos/oferta-formativa/'));
  String body = response.body;

  BeautifulSoup soup = BeautifulSoup(body);

  var dl = soup.find('*', id: 'facultyList');
  var as = dl!.findAll('a');

  List<int> ids = [];

  for (var a in as) {
    String href = a['href'].toString();
    //print(a.toString());
    String f = href.substring(50, 50 + (faculty.length));
    //print("f: " + f);
    //print(f == faculty);
    String id = href.substring(51 + (faculty.length), (href.length) - 1);
    //print("id: " + id);
    if (f == faculty) {
      ids.add(int.parse(id));
    }
  }

  return ids;
}

class Course {
  String grau;
  String nome;
  String sigla;

  Course(this.grau, this.nome, this.sigla);

  write() {
    print(this.sigla + ',' + this.nome + ',' + this.grau);
  }
}

Future<Course> getCourse(String faculty, int id) async {
  final response = await http.Client().get(Uri.parse('https://sigarra.up.pt/$faculty/pt/cur_geral.cur_view?pv_curso_id=$id'));
  String body = response.body;

  BeautifulSoup soup = BeautifulSoup(body);

  var content = soup.find('*', id: 'conteudoinner');
  String nome = content!.findAll('h1')[1]!.text.toString();

  var span = soup.find('span', class_: 'pagina-atual');
  String sigla = span!.text.toString().substring(3);

  String grau;

  if (sigla[0] == 'L') grau = 'Licenciatura';
  else if (sigla[0] == 'M') {
    if (sigla.substring(0, 2) == 'MI') grau = 'Mestrado Integrado';
    else grau = 'Mestrado';
  }
  else grau = 'Doutoramento';

  return Course(grau, nome, sigla);
}

Future<void> main() async {
  for (int id in await getFacultyBachelorsIDs('fcnaup')) {
    (await getCourse('fcnaup', id)).write();
  }
  /*print(await getFacultyBachelorsIDs('fbaup'));
  print(await getFacultyBachelorsIDs('fcup'));
  print(await getFacultyBachelorsIDs('fcnaup'));
  print(await getFacultyBachelorsIDs('fadeup'));
  print(await getFacultyBachelorsIDs('fdup'));
  print(await getFacultyBachelorsIDs('fep'));
  print(await getFacultyBachelorsIDs('feup'));
  print(await getFacultyBachelorsIDs('ffup'));
  print(await getFacultyBachelorsIDs('flup'));
  print(await getFacultyBachelorsIDs('fmup'));
  print(await getFacultyBachelorsIDs('fmdup'));
  print(await getFacultyBachelorsIDs('fpceup'));
  print(await getFacultyBachelorsIDs('icbas'));

  print(await getFacultyMastersIDs('faup'));
  print(await getFacultyMastersIDs('fbaup'));
  print(await getFacultyMastersIDs('fcup'));
  print(await getFacultyMastersIDs('fcnaup'));
  print(await getFacultyMastersIDs('fadeup'));
  print(await getFacultyMastersIDs('fdup'));
  print(await getFacultyMastersIDs('fep'));
  print(await getFacultyMastersIDs('feup'));
  print(await getFacultyMastersIDs('ffup'));
  print(await getFacultyMastersIDs('flup'));
  print(await getFacultyMastersIDs('fmup'));
  print(await getFacultyMastersIDs('fmdup'));
  print(await getFacultyMastersIDs('fpceup'));
  print(await getFacultyMastersIDs('icbas'));

  print(await getFacultyPhDsIDs('faup'));
  print(await getFacultyPhDsIDs('fbaup'));
  print(await getFacultyPhDsIDs('fcup'));
  print(await getFacultyPhDsIDs('fcnaup'));
  print(await getFacultyPhDsIDs('fadeup'));
  print(await getFacultyPhDsIDs('fdup'));
  print(await getFacultyPhDsIDs('fep'));
  print(await getFacultyPhDsIDs('feup'));
  print(await getFacultyPhDsIDs('ffup'));
  print(await getFacultyPhDsIDs('flup'));
  print(await getFacultyPhDsIDs('fmup'));
  print(await getFacultyPhDsIDs('fmdup'));
  print(await getFacultyPhDsIDs('fpceup'));
  print(await getFacultyPhDsIDs('icbas'));*/
}
