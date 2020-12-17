import 'dart:io'; // some shita que nao interessa

class Num{
  int someNum = 1232;
  static const String aClassVariable = 'Not an object variable'; // so to access
  // we must call the object

  // constructor
  Num(int aNum){
    this.someNum = aNum;
  }
}
int fnGreatedThanZero(var val){
  if (val <=0){
    throw Exception('Chem, el valor tiene que ser mayor a cero.');
  }
  return val;
}
/*
  This can just be main(), void will be assumed.
*/
void main() {

  print("A class variable: " + Num.aClassVariable);

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

  // collections; SET: a unique collection of items
  var somePeopleNames = <String>{'pepe', 'gonzalo', 'pepe'}; // last pepe does not exits
  print(somePeopleNames.runtimeType);
  for (var x in somePeopleNames){
    print("Person name: " + x);
  }

  // another type of collections; MAP: similar to a json object
  var someOtherPeopleNames = {
    'value': 'pair',
    'naughty': 'name'
  };
  someOtherPeopleNames['otherValue'] = 'anotherPair';
  print(someOtherPeopleNames['otherValue']);

  // functions: are an object, and also typed
  dynamic fnToWin(var num){
    return num * num;
  }
  print(fnToWin(3));

  // another way to define simple functions
  dynamic fnToWinBig(int num) => num * num;
  print(fnToWinBig(8));

  // it is also possible to have named parameters, they are optional and can
  // have default values
  dynamic fnNamed({ int var1, int var2 = 0 }){
    return var1 + var2;
  }
  print( fnNamed(var2: 7, var1: 3) );
  print( fnNamed(var1: 3) );

  // optional parameters can also option, with []
  dynamic fnOptionalFixed(int var1, [var var2]) => var1 + (var2 ?? 0);
  print(fnOptionalFixed(2));

  // exception handling
  var someIntVal = 0;
  try{
    var greaterThanZeroVal = fnGreatedThanZero(someIntVal);
    print(greaterThanZeroVal);
  }catch(e){
    print(e);
  }finally{
    if (someIntVal == null || someIntVal<=0){
      print("Value not accepted, must be greated than zero.");
    }else{
      print("Value ok: " + someIntVal.toString());

    }
  }
}
