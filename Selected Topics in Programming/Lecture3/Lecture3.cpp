// Lecture3.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <iterator>
#include <fstream>
#include <vector>
#include <algorithm>


std::vector<std::string> load_file(std::string filename) {
    std::ifstream is(filename);
    std::istream_iterator<std::string> start(is), end;
    std::vector<std::string> lines(start, end);

    return lines;
}

void print_vector(std::vector<std::string> vector) {
    std::copy(vector.begin(), vector.end(),
        std::ostream_iterator<std::string>(std::cout, "\n"));
    std::cout << std::endl;
}

void sort_vector(std::vector<std::string> &vector, const int n) {
    std::sort(vector.begin(), vector.end(), [n](std::string a, std::string b) {
        return a.substr(n) < b.substr(n); 
    });
}

void print_lines_containing(std::vector<std::string> &vector, const int n, const std::string s) {
    for (auto& string : vector) {
        if (string.substr(n).find(s) != std::string::npos)
        {
            std::cout << string << std::endl;
        }
    }
}

int main()
{
    auto lines{load_file("input.txt")};
    std::cout << "Before sort" << std::endl;
    print_vector(lines);
    sort_vector(lines, 2);
    std::cout << "After sort" << std::endl;
    print_vector(lines);
    std::cout << "Find lines contaning a after 2nd char" << std::endl;
    print_lines_containing(lines, 2, "a");


}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
