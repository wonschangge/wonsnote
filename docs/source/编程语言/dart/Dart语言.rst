## String.runes

Example: Print Unicode Value of Each Character of String
This will split the name into Unicode values and then find characters from the Unicode value.

```dart
void main(){
  
  String name = "John";
     
for(var codePoint in name.runes){
						print("Unicode of ${String.fromCharCode(codePoint)} is $codePoint.");
}
}
```

## try-catch-finally

```dart
void main() {   
   int a = 18;   
   int b = 0;   
   int res;    
     
   try {    
      res = a ~/ b;
      print("Result is $res");   
   }    
    // It returns the built-in exception related to the occurring exception  
   catch(ex) {   
      print(ex);   
    }   
}  
```

```dart
void main() {
  int a = 12;
  int b = 0;
  int res;
  try {
    res = a ~/ b;
  } on UnsupportedError {
    print('Cannot divide by zero');
  } catch (ex) {
    print(ex);
  } finally {
    print('Finally block always executed');
  }
}
```

## throw

throw new Exception_name() 

```dart
throw new FormatException();
```

Custom Exception:

```dart
class MarkException implements Exception {
  String errorMessage() {
    return 'Marks cannot be negative value.';
  }
}

void main() {
  try {
    checkMarks(-20);
  } catch (ex) {
    print(ex.toString());
  }
}

void checkMarks(int marks) {
  if (marks < 0) throw MarkException().errorMessage();
}
```

```dart
import 'dart:math';

// custom exception class
class NegativeSquareRootException implements Exception {
  @override
  String toString() {
    return 'Sqauare root of negative number is not allowed here.';
  }
}

// get square root of a positive number
num squareRoot(int i) {
  if (i < 0) {
    // throw `NegativeSquareRootException` exception
    throw NegativeSquareRootException();
  } else {
    return sqrt(i);
  }
}

void main() {
  try {
    var result = squareRoot(-4);

    print("result: $result");
  } on NegativeSquareRootException catch (e) {
    print("Oops, Negative Number: $e");
  } catch (e) {
    print(e);
  } finally {
    print('Job Completed!');
  }
}
```

## Practice

Question For Practice 2
2. Write a dart program to check whether a character is a vowel or consonant.

3. Write a dart program to create a simple calculator that performs addition, subtraction, multiplication, and division.

是否需要转换

## 可选参数

Example 2: Providing Default Value On Positional Parameter
In the example below, function printInfo takes two positional parameters and one optional parameter. The title parameter is optional here. If the user doesn’t pass the title, it will automatically set the title value to sir/ma’am.

```dart
void printInfo(String name, String gender, [String title = "sir/ma'am"]) {
  print("Hello $title $name your gender is $gender.");
}

void main() {
  printInfo("John", "Male");
  printInfo("John", "Male", "Mr.");
  printInfo("Kavya", "Female", "Ms.");
}
```

## Named Parameter

Example 1: Use Of Named Parameter
In the example below, function printInfo takes two named parameters. You can pass value in any order. You will learn about ? in null safety section.

```dart
void printInfo({String? name, String? gender}) {
  print("Hello $name your gender is $gender.");
}

void main() {
  // you can pass values in any order in named parameters.
  printInfo(gender: "Male", name: "John");
  printInfo(name: "Sita", gender: "Female");
  printInfo(name: "Reecha", gender: "Female");
  printInfo(name: "Reecha", gender: "Female");
  printInfo(name: "Harry", gender: "Male");
  printInfo(gender: "Male", name: "Santa");
}
```

Example 2: Use Of Required In Named Parameter
In the example below, function printInfo takes two named parameters. You can see a required keyword, which means you must pass the person’s name and gender. If you don’t pass it, it won’t work.

```dart
void printInfo({required String name, required String gender}) {
  print("Hello $name your gender is $gender.");
}

void main() {
  // you can pass values in any order in named parameters.
  printInfo(gender: "Male", name: "John");
  printInfo(gender: "Female", name: "Suju");
}
```

Example: Use Of Optional Parameter
In the example below, function printInfo takes two positional parameters and one optional parameter. First, you must pass the person’s name and gender. The title parameter is optional here. Writing [String? title] makes title optional.

```dart
void printInfo(String name, String gender, [String? title]) {
  print("Hello $title $name your gender is $gender.");
}

void main() {
  printInfo("John", "Male");
  printInfo("John", "Male", "Mr.");
  printInfo("Kavya", "Female", "Ms.");
}
```

## 匿名函数 anonymous

```dart
(parameterList){
// statements
}
```

Example 1: Anonymous Function In Dart
In this example, you will learn to use an anonymous function to print all list items. This function invokes each fruit without having a function name.
```dart
void main() {
  const fruits = ["Apple", "Mango", "Banana", "Orange"];

  fruits.forEach((fruit) {
    print(fruit);
  });
}
```

Example 2: Anonymous Function In Dart
In this example, you will learn to find the cube of a number using an anonymous function.
```dart
void main() {
// Anonymous function
  var cube = (int number) {
    return number * number * number;
  };

  print("The cube of 2 is ${cube(2)}");
  print("The cube of 3 is ${cube(3)}");
}
```

## 箭头函数 - 直接指向值表达式

```dart
int add(int n1, int n2) => n1 + n2;
int sub(int n1, int n2) => n1 - n2;
int mul(int n1, int n2) => n1 * n2;
double div(int n1, int n2) => n1 / n2;

void main() {
  int num1 = 100;
  int num2 = 30;

  print("The sum is ${add(num1, num2)}");
  print("The diff is ${sub(num1, num2)}");
  print("The mul is ${mul(num1, num2)}");
  print("The div is ${div(num1, num2)}");
}
```

## scope

1. 函数体内(如main内)
2. 全局(main外)
3. 词法域{}内

## 列表 list

```dart
// Integer List
List<int> ages = [10, 30, 23];

// String List
List<String> names = ["Raj", "John", "Rocky"];

// Mixed List
var mixed = [10, "John", 18.8];
```

## List Where

```dart
void main(){
List<int> numbers = [2,4,6,8,10,11,12,13,14];

List<int> even = numbers.where((number)=> number.isEven).toList(); 
print(even);
}
```

## 实例化类

`ClassName objectName = ClassName();`

没有new.

```dart
    class Bicycle {
      String? color;
      int? size;
      int? currentSpeed;

      void changeGear(int newValue) {
        currentSpeed = newValue;
      }

      void display() {
        print("Color: $color");
        print("Size: $size");
        print("Current Speed: $currentSpeed");
      }
    }

    void main(){
        // Here bicycle is object of class Bicycle.
        Bicycle bicycle = Bicycle();
        bicycle.color = "Red";
        bicycle.size = 26;
        bicycle.currentSpeed = 0;
        bicycle.changeGear(5);
        bicycle.display();
    }
```

```dart
class SimpleInterest{
  //properties of simple interest
  double? principal;
  double? rate;
  double? time;
  
  //functions of simple interest
  double interest(){
    return (principal! * rate! * time!)/100;
  }
}
void main(){
  //object of simple interest created
  SimpleInterest simpleInterest = SimpleInterest();
  
  //setting properties for simple interest
  simpleInterest.principal=1000;
  simpleInterest.rate=10;
  simpleInterest.time=2;
  
  //functions of simple interest called
  print("Simple Interest is ${simpleInterest.interest()}.");
}
```

## constructor

```dart
class ClassName {
  // Constructor declaration: Same as class name
  ClassName() {
    // body of the constructor
  }
}
```

特别点, single line：

```dart
class Person{
  String? name;
  int? age;
  String? subject;
  double? salary;

  // Constructor in short form
  Person(this.name, this.age, this.subject, this.salary);
}

void main(){
  Person person = Person("John", 30, "Maths", 50000.0);
  person.display();
}
```

可选参：

```dart
class Employee {
	Employee(this.name, this.age, [this.subject = "N/A", this.salary=0]);
}
```

具名参:

```dart
... Chair({this.name, this.color});
Chair(name: "Chair1", color: "Red");
```

## 实例创建类重载

```
class Mobile {
	Mobile(this.name, this.color, this.prize);
	Mobile.namedConstructor(this.name, this.color, [this.prize = 0]);
	Mobile.namedConstructor2(this.name, this.color, [this.prize = 0]);

	Student student = Student.namedConstructor("John", 20, 1);
	Student student = Student.namedConstructor2("John", 20, 1);
}
```

## Named Constructor生命周期

```dart
import 'dart:convert';

class Person {
  String? name;
  int? age;

  Person(this.name, this.age);

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
  }

  Person.fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    name = json['name'];
    age = json['age'];
  }
}

void main() {
// Here person is object of class Person.
  String jsonString1 = '{"name": "Bishworaj", "age": 25}';
  String jsonString2 = '{"name": "John", "age": 30}';

  Person p1 = Person.fromJsonString(jsonString1);
  print("Person 1 name: ${p1.name}");
  print("Person 1 age: ${p1.age}");

  Person p2 = Person.fromJsonString(jsonString2);
  print("Person 2 name: ${p2.name}");
  print("Person 2 age: ${p2.age}");
}
```
