module training;

import std.conv : to;
import std.file : readText, write;
import std.stdio : writeln;

bool individual = 0, right = 0, trainIt = 1;

//This function trains it to adjust the weights
void train(bool individual, char inputFile)
{
    byte counter;
    real[400] weights = 0.0L;
    bool[400][] trainingSet = to!(bool[400][])(readText(inputFile ~ "/" ~ inputFile ~ "_trainingSet.txt"));
    foreach (set; trainingSet)
    {
        growingSynapses(set, weights);
        while (100.0L - netSum(set, weights) > 0.01L)
            weightAdjustment(set, weights);
        if (individual)
        {
            foreach (ref weight; weights)
                if (weight == 0.0L)
                    weight = -1.5L;
            write(inputFile ~ "/" ~ inputFile ~ to!string(++counter) ~ "_weights.txt", to!string(weights));
            weights = 0.0L;
        }
    }
    if (!individual)
    {
        foreach (ref weight; weights)
                if (weight == 0.0L)
                    weight = -1.5L;
        write(inputFile ~ "/" ~ inputFile ~ "_weights.txt", to!string(weights));
    }
    writeln("done training");
}

//this function tests the neural network against images on a file
void test(bool right, char inputFile)
{
    char letter = 'A';
    real[400] weights = to!(real[400])(readText(inputFile ~ "/" ~ inputFile ~ "_weights.txt"));
    bool[400][] testSet = void;
    testSet = right ? to!(bool[400][])(readText(inputFile ~ "/" ~ inputFile ~ "_trainingSet.txt")) : to!(bool[400][])(readText("alphabet_testSet.txt"));
    foreach (i; 0 .. testSet.length)
        writeln(letter++, ": ", netSum(testSet[i], weights));
    writeln("done testing");
}

//this function just maps the important parts, giving the highest value to the most important ones
void growingSynapses(bool[] set, real[] weights)
{
    foreach (i; 0 .. 400)
        if (set[i])
            weights[i] += 0.1L;
}

//this function adds all of the weights of the written parts to find the match probability
real netSum(bool[] processedImage, real[] weights)
{
    real result = 0.0L;
    foreach (i; 0 .. 400)
        if (processedImage[i])
            result += weights[i];
    return result;
}

//This function adjusts the weights by increasing them by 1% until they produce the result of 100.0
void weightAdjustment(bool[] set, real[] weights)
{
    foreach (i; 0 .. 400)
        if (set[i])
            weights[i] *= 1.01L;
}
