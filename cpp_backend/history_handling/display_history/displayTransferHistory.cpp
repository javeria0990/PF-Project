#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
using namespace std;

int main(int arguments, char *arg[])
{
    if (arguments != 2)
    {
        return -6;
    }
    int userID = stoi(arg[1]);
    vector<string> transferVector;
    ifstream readTransferHistoryFile;
    readTransferHistoryFile.open("transferHistory.txt");
    if (readTransferHistoryFile.is_open())
    {
        string line;
        while (getline(readTransferHistoryFile, line))
        {
            int uid;
            char separator;
            stringstream ss(line);
            ss >> uid >> separator;
            if (uid == userID)
            {
                transferVector.push_back(line);
            }
        }
        readTransferHistoryFile.close();
    }
    for (string x : transferVector)
    {
        int uid;
        string currency;
        string method;
        string accountNum;
        string name;
        string amount;
        string time;
        char separator;
        stringstream ss(x);
        ss >> uid >> separator;
        getline(ss, currency, '|');
        getline(ss, method, '|');
        getline(ss, accountNum, '|');
        getline(ss, name, '|');
        getline(ss, amount, '|');
        getline(ss, time);
        cout << uid << '|' << currency << '|' << method << '|' << accountNum << '|' << name << '|' << amount << '|' << time << endl;
    }

    return 0;
}