#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
using namespace std;

int main(int argument, char *arg[])
{
    double balanceToAdd = stod(arg[3]);
    if (argument == 4)
    {
        if (balanceToAdd > 100000000)
        {
            return -9; // out of limit
        }

        bool pkrBalanceUpdate = false;
        int userID = stoi(arg[1]);
        int balanceType = stoi(arg[2]);

        if (balanceType == 1)
        {
            pkrBalanceUpdate = true;
        }
        vector<string> linesV;
        ifstream walletFile;
        walletFile.open("wallet.txt");
        if (walletFile.is_open())
        {
            string line;
            while (getline(walletFile, line))
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
                    if (pkrBalanceUpdate)
                    {
                        totalPkrBalance = totalPkrBalance + balanceToAdd;
                    }
                    else
                    {
                        totalUsdBalance = totalUsdBalance + balanceToAdd;
                    }
                    x = to_string(uid) + "|" + to_string(totalPkrBalance) + "|" + to_string(totalUsdBalance);
                    break;
                }
            }
            walletFile.close();
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
                return -1;
            }
        }
        else
        {
            return -1;
        }
    }
    else
    {
        return -6; // no of arguments is not correct
    }

    return 0;
}