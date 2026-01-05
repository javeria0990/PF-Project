#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <iomanip>
using namespace std;

int main(int arguments, char *arg[])
{
    if (arguments == 3)
    {
        int userID = stoi(arg[1]);
        double toBePaid = stod(arg[2]);
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
                    if (toBePaid < totalPkrBalance)
                    {
                        totalPkrBalance = totalPkrBalance - toBePaid;
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
            }
        }
        readWalletFile.close();

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