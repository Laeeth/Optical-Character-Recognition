import std.conv : to;
import std.file : readText;
import training : individual, right, test, train, trainIt;

void main()
{
    if (trainIt)
    {
        train(individual, 'O');
        train(individual, 'P');
        train(individual, 'Q');
        train(individual, 'R');
        train(individual, 'S');
        train(individual, 'T');
        train(individual, 'U');
        train(individual, 'V');
        train(individual, 'W');
        train(individual, 'X');
        train(individual, 'Y');
        train(individual, 'Z');
    }
    else
    {
        test(right, 'O');
        test(right, 'P');
        test(right, 'Q');
        test(right, 'R');
        test(right, 'S');
        test(right, 'T');
        test(right, 'U');
        test(right, 'V');
        test(right, 'W');
        test(right, 'X');
        test(right, 'Y');
        test(right, 'Z');
    }
}
