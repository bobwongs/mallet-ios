# 言語仕様
(2019/6/3現在)

## 変数宣言

```swift
var a : Int //整数型の変数を宣言
a = 1 //代入
a = a + 2 * 3 // 演算子には +,-,*,/,%,==,!=,>,<,<=,>=,! を使用可能

var b : String //文字列型の変数を宣言
b = "Hello!" //ダブルクォーテーションで囲む
```

## 繰り返し

```swift
repeat(10) //{}内の処理を10回繰り返す
{
    a = a + 1
}

a = 0
check = a < 10
while(check) //checkがtrue(1以上)の間繰り返す
{
    a = a + 1
    check = a < 10
}

```

## 条件分岐

```swift
var a : Int
a = 1 //右辺がtrueの時は1 falseの時は0
if(a == 1) // aが1以上の時{}内の処理を実行する
{
    a = 10
}
```

## UI 関係

```swift
SetUIText(0,"This is UI") //idが0のUIのテキストを"This is UI"にする
SetUIText(0,128 + 256) //UIのテキストは数字もOK

//現在はボタンのid:0,文字のid:1で固定
```

## 注意が必要な文法 (今後改善)

```swift
var a : Int = 1 //宣言と代入を同時に行うことはできない

var b : String
b = "Hello " + "World" //文字列の演算は未サポート

while(a < 10){} //while文の()内に数式を入れられない

if(a == 1){}
else{} //else文は未サポート

```
