# 言語仕様

2019/7/12

## 変数宣言

```c
number a = 0 //数値型の変数を宣言
a = 3.14 //代入
a = (a + 2) * 3 // 演算子には +,-,*,/,%,==,!=,>,<,<=,>=,! を使用可能
a = -3 * -5 //負の数は未対応
```

## 繰り返し

```c
repeat(10) //{}内の処理を10回繰り返す
{
    a = a + 1
}

number a = 0
while(a < 10)
{
    a = a + 1
}

repeat(5) print(128) //処理が1行の場合は{}を省略可

```

## 条件分岐

```c
number a = 0
if(a == 1)
{
    print(128)
}
else
{
    print(256)
}
```

## 関数

```c
//void型,number型に対応

void main()
{
    print(fib(35))

    //void型はreturn省略可
}

number fib(number n)
{
    if(n==1 || n==2)
        return 1

    return fib(n-1) + fib(n-2)
}
```
