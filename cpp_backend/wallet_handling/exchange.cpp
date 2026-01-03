#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <iomanip>
using namespace std;

int main(int arguments, char *arg[])
{
    if (arguments == 4)
    {
        double exchangedAmount;
        bool pkrBalanceExchange = false;
        int userID = stoi(arg[1]);
        int balanceType = stoi(arg[2]);
        if (balanceType == 1)
        {
            pkrBalanceExchange = true;
        }
        double toBeExchanged = stod(arg[3]);
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
                    if (pkrBalanceExchange)
                    {
                        if (toBeExchanged < totalPkrBalance)
                        {
                            totalPkrBalance = totalPkrBalance - toBeExchanged;
                            exchangedAmount = toBeExchanged / 280.0;
                            ostringstream oss;
                            oss << uid << '|' << fixed << setprecision(1) << totalPkrBalance << '|' << setprecision(1) << (totalUsdBalance + exchangedAmount);
                            x = oss.str();
                            break;
                        }
                        else
                        {
                            return -7; // insufficient balance
                        }
                    }
                    else if (toBeExchanged < totalUsdBalance)
                    {
                        totalUsdBalance = totalUsdBalance - toBeExchanged;
                        exchangedAmount = toBeExchanged * 280.0;
                        ostringstream oss;
                        oss << uid << '|' << fixed << setprecision(1) << (totalPkrBalance + exchangedAmount) << '|' << setprecision(1) << totalUsdBalance;
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