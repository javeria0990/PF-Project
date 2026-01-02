#include <iostream>
#include <vector>
#include <string>
#include <iomanip>

using namespace std;

struct billStruct
{
    string id;
    string type;
    double billAmount;
    string service_provider;
};

double account_balance = 15000.00;

int CategoriesOf_Bill();
void ServiceProviders(int Bills_category);
double billDetails();
bool validateFunds(double amount);
void updateBalance(double amount);
void payBill();
void TransactionResult(bool success);

int main()
{
    int Bills_category, providers;
    billStruct current_transaction;

    cout << "    WELCOME TO THE BILL PAYMENT SYSTEM    " << endl;
    cout << "Current Balance: " << fixed << setprecision(2) << account_balance << " PKR" << endl;

    int choice = CategoriesOf_Bill();
    ServiceProviders(choice);

    return 0;
}

int CategoriesOf_Bill()
{
    int choice;
    cout << "[ Select Bill Category ]" << endl;
    cout << "1. Electricity" << endl;
    cout << "2. Water" << endl;
    cout << "3. Gas" << endl;
    cout << "4. Internet" << endl;
    cout << "5. 1Bill Payments" << endl;
    cin >> choice;
    return choice;
}

void ServiceProviders(int Bills_category)
{
    cout << "\n[ Select Company ]" << endl;
    switch (Bills_category)
    {
        int serviceProvider;
    case 1:
    {
        cout << "1. MEPCO\n 2. LESCO\n 3. K-ELECTRIC" << endl;
        cin >> serviceProvider;
        payBill();
    }

    break;
    case 2:
    {
        cout << "1. LWASA\n 2. BWASA\n 3. CDA" << endl;
        cin >> serviceProvider;
        payBill();
    }
    break;
    case 3:
    {
        cout << "1. SSGC\n 2. SNGPL" << endl;
        cin >> serviceProvider;
        payBill();
    }
    break;
    case 4:
    {
        cout << "1. OPTIX\n 2. SB-LINK\n 3. NAYATEL" << endl;
        cin >> serviceProvider;
        payBill();
    }
    break;
    case 5:
    {
        cout << "1. 1Bill INVOICES\n 2. 1BILL TOP UP" << endl;
        cin >> serviceProvider;
        payBill();
    }
    break;
    default:
        cout << "Invalid category selected." << endl;
    }
}

double billDetails()
{
    billStruct bill;
    cout << "Enter Consumer/Reference ID: ";
    cin >> bill.id;
    cout << "Enter amount to be paid: ";
    cin >> bill.billAmount;
    return bill.billAmount;
}

bool validateFunds(double amount)
{
    return account_balance >= amount;
}

void updateBalance(double amount)
{
    account_balance -= amount;
}

void payBill()
{
    double amount = billDetails();
    bool action = validateFunds(amount);
    if (action)
    {
        updateBalance(amount);
    }
    TransactionResult(action);
}

void TransactionResult(bool success)
{
    if (success)
    {
        cout << "SUCCESS: You have successfully paid your bill." << endl;
        cout << "Remaining Balance: " << fixed << setprecision(2) << account_balance << " PKR" << endl;
    }
    else
    {
        cout << "\n------------------------------------------" << endl;
        cout << "Insufficient account balance. Payment failed." << endl;
        cout << "------------------------------------------" << endl;
    }
}