#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <iomanip>
using namespace std;

void transactionFee(bool type, double &totalbalance, double exAmount);

int main(int arguments, char *arg[])
{
    if (arguments == 4)
    {
        bool pkrBalanceTransfer = false;
        int userID = stoi(arg[1]);
        int balanceType = stoi(arg[2]);
        if (balanceType == 1)
        {
            pkrBalanceTransfer = true;
        }
        double amountToBeTransferred = stod(arg[3]);
        ifstream readWalletFile;
        vector<string> linesV;
        string line;
        readWalletFile.open("wallet.txt");
        if (readWalletFile.is_open())
        {
            while (getline(readWalletFile, line))
            {
                linesV.push_back(line);
            }

            for (string &x : linesV)
            {
                int uid;
                char separator;
                double totalPkrBalance, totalUsdBalance;
                stringstream ss(x);
                ss >> uid >> separator >> totalPkrBalance >> separator >> totalUsdBalance;
                if (uid == userID)
                {
                    if (pkrBalanceTransfer)
                    {
                        if (amountToBeTransferred < totalPkrBalance)
                        {
                            transactionFee(true, totalPkrBalance, amountToBeTransferred);
                            totalPkrBalance = totalPkrBalance - amountToBeTransferred;
                            ostringstream oss;
                            oss << uid << '|' << fixed << setprecision(1) << totalPkrBalance << '|' << setprecision(1) << totalUsdBalance;
                            x = oss.str();
                            break;
                        }
                        else
                        {
                            return -7; // insufficient balance
                        }
                    }
                    else if (amountToBeTransferred < totalUsdBalance)
                    {
                        transactionFee(false, totalUsdBalance, amountToBeTransferred);
                        totalUsdBalance = totalUsdBalance - amountToBeTransferred;
                        ostringstream oss;
                        oss << uid << '|' << fixed << setprecision(1) <<totalPkrBalance << '|' << setprecision(1) << totalUsdBalance;
                        x = oss.str();
                        break;
                    }
                    else
                    {
                        return -7; // insufficient balance
                    }
                }
            }
            readWalletFile.close();
        }
        ofstream rewriteWalletFile;
        rewriteWalletFile.open("wallet.txt", ios::trunc);
        if (rewriteWalletFile.is_open())
        {
            for (string x : linesV)
            {
                rewriteWalletFile << x << endl;
            }
            rewriteWalletFile.close();
        }
        else
        {
            return -1; // file opening error
        }
    }
    else
    {
        return -6; // no of arguments is not correct
    }

    return 0;
}

void transactionFee(bool type, double &totalbalance, double amountToTransfer)
{
    if (type)
    {
        if (amountToTransfer < 5000)
        {
            totalbalance = totalbalance - 50;
        }
        else if (amountToTransfer < 10000)
        {
            totalbalance = totalbalance - 100;
        }
        else if (amountToTransfer < 100000)
        {
            totalbalance = totalbalance - 1000;
        }
        else if (amountToTransfer < 1000000)
        {
            totalbalance = totalbalance - 5000;
        }
        else if (amountToTransfer < 10000000)
        {
            totalbalance = totalbalance - 10000;
        }
        else if (amountToTransfer < 100000000)
        {
            totalbalance = totalbalance - 20000;
        }
    }
    else
    {
        if (amountToTransfer < 50)
        {
            totalbalance = totalbalance - 3;
        }
        else if (amountToTransfer < 100)
        {
            totalbalance = totalbalance - 5;
        }
        else if (amountToTransfer < 100000)
        {
            totalbalance = totalbalance - 100;
        }
        else if (amountToTransfer < 1000000)
        {
            totalbalance = totalbalance - 500;
        }
        else if (amountToTransfer < 10000000)
        {
            totalbalance = totalbalance - 1000;
        }
        else if (amountToTransfer < 100000000)
        {
            totalbalance = totalbalance - 2000;
        }
    }
}