//
//  getMove.cpp
//  tryTrainedFunction
//
//  Created by Yang Jin on 3/4/16.
//  Copyright © 2016 Yang Jin. All rights reserved.
//


#include "getMove.hpp"
#include <iostream>
#include "dlib/svm.h"
#include <string>
using namespace dlib;
using namespace std;
//typedef matrix<double, 30, 1> sample_type;
//typedef radial_basis_kernel<sample_type> kernel_type;
//typedef probabilistic_decision_function<kernel_type> probabilistic_funct_type;
//typedef normalized_function<probabilistic_funct_type> pfunct_type;




typedef matrix<double, 30, 1> sample_type;
typedef radial_basis_kernel<sample_type> kernel_type;

typedef probabilistic_decision_function<kernel_type> probabilistic_funct_type;
typedef normalized_function<probabilistic_funct_type> pfunct_type;

pfunct_type learned_pfunct;

double getMove(double *data,string path) {
    pfunct_type learned_pfunct;
    deserialize(path) >> learned_pfunct;
    sample_type sample;
    for (int i=0; i<30; i++) {
        sample(i) = data[i];
    }
    return learned_pfunct(sample);
}
