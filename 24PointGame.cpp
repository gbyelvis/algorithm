#include <iostream>
#include <string>
#include <stdlib.h>
#include <math.h>

using namespace std;

const double LING = 1E-6;
const int CONT = 4;
const int VOLUE = 24;
double number[CONT];
string expression[CONT];
bool judge = false;
int count_ = 0;

void Find(int n)
{
    if(n == 1)
    {
        if( fabs(number[0] - VOLUE) <= LING )
        {
            cout << expression[0] <<"\t\t";
            judge = true;
            count_++;
            if((count_%3) == 0)
                cout << endl;
        }

    }

    for (int i = 0; i<n; i++)
    {
        for(int j=i+1; j <n; j++)
        {
            double a,b;
            string expressiona, expressionb;
            a = number[i];
            b = number[j];
            number[j] = number[n-1];
            expressiona = expression[i];
            expressionb = expression[j];
            expression[j] = expression[n-1];
            expression[i] = '(' + expressiona + '+' + expressionb + ')';
            number[i] = a+b;
            Find(n-1);

            expression[i] = '(' + expressiona + '-' + expressionb + ')';
            number[i] = a-b;
            Find(n-1);

            expression[i] = '(' + expressionb + '-' + expressiona + ')';
            number[i] = b-a;
            Find(n-1);

            expression[i] = '(' + expressiona + '*' + expressionb + ')';
            number[i] = a*b;
            Find(n-1);

            if(b != 0)
            {
                expression[i] = '(' + expressiona + '/' + expressionb + ')';
                number[i] = a/b;
                Find(n-1);
            }

            if(a != 0)
            {
                expression[i] = '(' + expressionb + '/' + expressiona + ')';
                number[i] = b/a;
                Find(n-1);
            }

            number[i] = a;
            number[j] = b;
            expression[i] = expressiona;
            expression[j] = expressionb;
        }
    }
}

int main()
{
    cout << "请输入四个数:\n";
    for (int i = 0; i < CONT; i++)
    {
        char ch[20];
        cout<< "第" <<i+1<< "个数:";
        cin >> number[i];
        itoa(number[i], ch, 10);
        expression[i] = ch;
    }
    cout<<endl;
    Find(CONT);
    if(judge == true) {
        cout<<"\n成功！"<<endl;
        cout<<"总共的计算方法有："<<count_<<endl;
    } else {
        cout<< "失败！" <<endl;
    }
    return 0;
}
