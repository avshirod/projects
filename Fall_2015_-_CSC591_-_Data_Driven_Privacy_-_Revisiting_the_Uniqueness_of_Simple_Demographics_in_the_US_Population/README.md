# Revisiting the Uniqueness of Simple Demographics in US Population
## CSC 591 - Data Driven Privacy - Fall 2015
#### Course Taken By: Dr. Jessica Staddon

#### Overview
To revisit and compare the deanonymization statistics for 2000 Census to 2010 Census to analyze if the changes over the years have made the release of simple demographics more secure. It was calculated that **87%** of the (then) population can be deanonymized based on the *1990 Census*; that number fell down to **63%** for the *2000 Census*. We aim to replicate the procedures that followed to previous results for the 2010 Census.  
We intend to do this by finding the anonymity values for US population, based on three factors noted in the general census - {Gender, Age, Location}

#### Motivation
The deanonymization of Simple Demographic information, was brought forward by [this](https://dataprivacylab.org/projects/identifiability/paper1.pdf) paper by Dr. Sweeney. Using some simple statistics, the paper shows that based on certain identifiers, you can narrow down a particular row in the data to a handful of people, if not to one single person (k-anonymity).  
This research was done in 1990, and revisited again by Dr. Golle's [paper](http://dl.acm.org/citation.cfm?id=1179615) in 2006.  
The amount of personal data being generated has increased multifold over that period, and so have the techniques to prevent/avoid reidentification. We wish to survey and update the results, and verify the impact of current 'Best Practics'.

#### Approach
The [presentation](CSC591%20Revisiting%20the%20Uniqueness%20of%20Simple%20Demographics%20in%20the%20US%20Population%2012-03-2015%20Aditya-Kunal.pptx) gives a brief intro to the methods used.  
A detailed version is mentioned in the [report](Report.docx).  
The [data](Data/) was obtained from the US Census Bureau website.  
The Java code used to calculate the statistics can be found [here](Code/).

#### Results
![Fraction of Population Reidentifiable 2000 Census](/Images/2000%20-%20Results.png)  

![Fraction of Population Reidentifiable 2010 Census](/Images/2010%20-%20Results.png)  

Refer to [Images](Images/) for related graphs.

#### Conclusion
A basic analysis of 2010 Census over three factors {Zip, Age, Gender} over two granularities {Zip Code, County} shows that about 63% of the US population is uniquely identifiable. This result is similar to the 2000 Census results.  
Pairing this with other datasets and improved computing powers, this number can be telling; proving that the release conditions of simple demographics still require improvement.

