// The contents of this file are in the public domain. See LICENSE_FOR_EXAMPLE_PROGRAMS.txt
/*
 
 This is an example showing how to use sparse feature vectors with
 the dlib C++ library's machine learning tools.
 
 This example creates a simple binary classification problem and shows
 you how to train a support vector machine on that data.
 
 The data used in this example will be 100 dimensional data and will
 come from a simple linearly separable distribution.
 */


#include <iostream>
#include <vector>
#include "dlib/svm.h"
#include <fstream>


using namespace std;
using namespace dlib;

ifstream fin("do.txt");
ofstream fout("pa.txt");

typedef matrix<double, 30, 1> sample_type;


typedef radial_basis_kernel<sample_type> kernel_type;

typedef probabilistic_decision_function<kernel_type> probabilistic_funct_type;
typedef normalized_function<probabilistic_funct_type> pfunct_type;

void test(){
    
    
    pfunct_type learned_pfunct;
    
    deserialize("lalala.txt")>>learned_pfunct;
    
    double input;
    int input2 = 0;
    
    
    while(fin>>input){
        
        
        sample_type sample;
        
        
        
        sample(0) = input;
        
        for(int i=1; i<30; i++){
            fin>>input;
            sample(i) = input;
        }
        
        fin>>input2;
        
        cout<<learned_pfunct(sample)<<" : "<<input2<<endl;
        
    }

    
    
}

int main()
{
    
    test(); return 0;
    
    
    
    
    
    std::vector<sample_type> samples;
    std::vector<double> labels;
    
    double input;
    int input2 = 0;
    
    
    while(fin>>input){
        
        
        sample_type sample;

        
        
        sample(0) = input;
        
        for(int i=1; i<30; i++){
            fin>>input;
            sample(i) = input;
        }
        
        fin>>input2;
        
        
        
        samples.push_back(sample);
        labels.push_back(input2);
        
     
        
        
    }

    
    vector_normalizer<sample_type> normalizer;
    
    normalizer.train(samples);
    
    for (unsigned long i = 0; i < samples.size(); ++i)
        samples[i] = normalizer(samples[i]);
    
    randomize_samples(samples, labels);

    svm_c_trainer<kernel_type> trainer;

    cout << "doing cross validation" << endl;
    for (double gamma = 0.00001; gamma <= 5; gamma *= 2)
    {
        for (double C = 1; C < 100000; C *= 2)
        {
            // tell the trainer the parameters we want to use
            trainer.set_kernel(kernel_type(gamma));
            trainer.set_c(C);
            
            cout << "gamma: " << gamma << "    C: " << C;
            // Print out the cross validation accuracy for 3-fold cross validation using
            // the current gamma and C.  cross_validate_trainer() returns a row vector.
            // The first element of the vector is the fraction of +1 training examples
            // correctly classified and the second number is the fraction of -1 training
            // examples correctly classified.
            cout << "     cross validation accuracy: "
            << cross_validate_trainer(trainer, samples, labels, 3);
        }
    }
    

  //  trainer.set_kernel(kernel_type(0.16384));
    trainer.set_c(16);
    
    typedef probabilistic_decision_function<kernel_type> probabilistic_funct_type;
    typedef normalized_function<probabilistic_funct_type> pfunct_type;
    
    pfunct_type learned_pfunct;
    learned_pfunct.normalizer = normalizer;
    learned_pfunct.function = train_probabilistic_decision_function(trainer, samples, labels, 3);
    
    

    for(int i=0; i<samples.size();i++){
        cout<<learned_pfunct(samples[i])<<" : "<<labels[i]<<endl;
    }

    
    
    serialize("lalala.txt")<<learned_pfunct;
    
    
    
        
}

