import 'dart:io'; // some shita que nao interessa

class Num{
  int someNum = 1232;
}

/*
  This can just be main(), void will be assumed.
*/
void main() {
  /// Documentation comment
  var lastName = 'Erramuspe';
  String firstName = 'Nicolas';
  print(firstName + ' ' + lastName);

  /*
  Entonce, a pesar de que es un lenguaje "strongly typed", permite un tipo
  de variable dinamico.
  También la inferencia del tipo de arriba usando 'var'
   */
  dynamic someCrap = "Oh boy!";
  print(someCrap);
  someCrap = 123.21;
  print(someCrap);

  // Everything is an objectin Dart

  String sss = """
    asdasdasda
  """;
  print(sss);

  var oneValue =  int.parse('1');
  print(oneValue);

  // also check this out :: Everything is an OBJECT!
  String nowAStringa = oneValue.toString();
  nowAStringa += " => YEEEEAH!";
  print(nowAStringa);

  // Aha, constants also, type inferred
  const yetAnotherOne = "Ukelele";
  print(yetAnotherOne.runtimeType);

  var num;
  //num = new Num();

  int anotherNum;

  if (num != null){
    anotherNum = num.someNum;
  }

  print(anotherNum);

  // and the null aware operator ?

  anotherNum = num?.someNum; // if num is a valid object (not null) then assign the property
  print(anotherNum);

  anotherNum = num?.someNum ?? 0; // with a default one
  print(anotherNum);

  // another case to just assign values
  int numb; // null
  print(numb ??= 666);
  print(numb);

  // regular loop
  for (int a = 1; a < 10; a++){
    print(a);
  }
  // in loop
  var aNumbers = [1, 5, 1341, 515351];
  for (var n in aNumbers){
    print(n);
  }
  // forEach loop with fn
  aNumbers.forEach( (n) => print(n));

  List names = ['This', 'is', 'just', 'an', 'array'];
  print(names[2]);

  // we can also use inference
  var otherNames = ['Also', 'works', 20, true];
  print(otherNames);

  // a typed list
  List <String> people = const['Maryanne', 'Pepe', 'Felizberto'];
  // people[2] = 'Peter';
  print(people);


  // copy an array to another obj
  var morePeople = [...people];
  morePeople[2] = 'Marcus';
  print(morePeople);
}
