#include <ctime>
#include <string>
#include <sstream>
#include <fstream>
#include <iomanip>

using namespace std;

string currentDateTime()
{
    time_t now = time(nullptr);
    tm *ltm = localtime(&now);
    ostringstream oss;
    oss << put_time(ltm, "%Y-%m-%d %H:%M:%S");
    return oss.str();
}

int main(int arguments, char *arg[])
{
    if (arguments == 7)
    {
        int userID = stoi(arg[1]);
        string billType = arg[2];
        string provider = arg[3];
        string consumerName = arg[4];
        string consumerID = arg[5];
        double paidAmount = stod(arg[6]);
        string time = currentDateTime();
        ofstream billPaymentHistoryFile;
        billPaymentHistoryFile.open("billPaymentHistory.txt", ios::app);
        if (billPaymentHistoryFile.is_open())
        {
            billPaymentHistoryFile << userID << '|' << billType << '|' << provider << '|' << consumerName << '|' << consumerID << '|' << paidAmount << '|' << time << endl;
            billPaymentHistoryFile.close();
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
