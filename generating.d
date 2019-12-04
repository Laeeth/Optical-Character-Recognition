import training : individual, right, test, train, trainIt;

void main()
{
    if (trainIt)
        foreach (letter; "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            train(individual, letter);
    else
        foreach (letter; "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            test(right, letter);
}
