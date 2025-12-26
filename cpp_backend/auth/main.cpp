#include "auth.h"
#include <iostream>
#include <sstream>
#include <fstream>
using namespace std;

int createSession(int uid);

int main(int arguments, char *arg[])
{
    if (arguments == 6)
    {
        return signUp(arg[2], arg[3], arg[4], arg[5]);
    }
    else if (arguments == 4)
    {
        int result = signIn(arg[2], arg[3]);
        if (result == 0)
        {
            ifstream file;
            file.open("users.txt");
            string line;
            if (file.is_open())
            {
                while (getline(file, line))
                {
                    int uid;
                    char separator;
                    string username, email, password;
                    stringstream ss(line);
                    ss >> uid >> separator;
                    getline(ss, username, '|');
                    getline(ss, email, '|');
                    getline(ss, password);
                    if (email == arg[2])
                    {
                        file.close();
                        return createSession(uid);
                    }
                }
            }
            else
            {
                return -1; // file opening error!
            }
        }

        return result;
    }

    return 9; // invalid arguments/unexpected behaviour!
}

int createSession(int uid)
{
    ofstream file;
    file.open("session.txt");
    if (file.is_open())
    {
        file << uid;
        file.close();
        return 0; // session created successfully!
    }
    else
    {
        return -1; // filse opening error!
    }
}