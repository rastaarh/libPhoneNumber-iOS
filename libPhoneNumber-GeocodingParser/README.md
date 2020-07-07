# **libPhoneNumber-iOS Geocoding File Parser**

An Objective-C program that converts Google's libPhoneNumber geocoding information (found at 
https://github.com/google/libphonenumber/tree/master/resources/geocoding) into SQLite databases that can
be used in the libPhoneNumber-iOS library for geocoding functionality. This program iterates through 
each language folder of geocoding metadata and creates an individual SQLite database file for each 
language. The program creates individual tables for each country code of geocoding region data provided for
each language. 

## Usage

Download libphoneNumber's geocoding resource files (found at 
https://github.com/google/libphonenumber/tree/master/resources/geocoding)
onto your computer's disk space.

This program has two required input arguments for ```main.m```:

1) The local system directory path to the geocoding folder. Example: /Users/JohnDoe/Desktop/geocoding
2) The local system directory path to the desired destination to save the SQLite database files.
Example: /Users/JohnDoe/Documents


##### Visit [libphonenumber](https://github.com/google/libphonenumber) for more information or mail (rastaar@google.com)
