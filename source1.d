import std.conv : to;
import std.file : readText;
import training : individual, right, test, train, trainIt;

void main()
{
    //The last font I saved for all letters was KacstArt
    if (trainIt)
    {
        train(individual, 'A');
        train(individual, 'B');
        train(individual, 'C');
        train(individual, 'D');
        train(individual, 'E');
        train(individual, 'F');
        train(individual, 'G');
        train(individual, 'H');
        train(individual, 'I');
        train(individual, 'J');
        train(individual, 'K');
        train(individual, 'L');
        train(individual, 'M');
        train(individual, 'N');
    }
    else
    {
        test(right, 'A');
        test(right, 'B');
        test(right, 'C');
        test(right, 'D');
        test(right, 'E');
        test(right, 'F');
        test(right, 'G');
        test(right, 'H');
        test(right, 'I');
        test(right, 'J');
        test(right, 'K');
        test(right, 'L');
        test(right, 'M');
        test(right, 'N');
    }
}
